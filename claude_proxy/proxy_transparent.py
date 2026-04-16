import os
import subprocess
import httpx
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse, JSONResponse
import uvicorn


def get_bitwarden_password(item_name: str) -> str:
    """Récupère un mot de passe depuis Bitwarden CLI."""
    try:
        session = os.environ.get("BW_SESSION", "")
        cmd = ["bw", "get", "password", item_name]
        if session:
            cmd.extend(["--session", session])
        result = subprocess.run(
            cmd,
            capture_output=True, text=True, check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return ""


# --- TOKENS depuis Bitwarden (priorité) ou variables d'environnement (fallback) ---
TOKEN_PRINCIPAL = (
    get_bitwarden_password("anthropic-token-principal")
    or os.environ.get("ANTHROPIC_TOKEN_PRINCIPAL", "")
)
TOKEN_FALLBACK = (
    get_bitwarden_password("anthropic-token-fallback")
    or os.environ.get("ANTHROPIC_TOKEN_FALLBACK", "")
)

if not TOKEN_PRINCIPAL or not TOKEN_FALLBACK:
    raise RuntimeError(
        "Tokens introuvables. Verifier que Bitwarden est unlocked (BW_SESSION defini)\n"
        "et que les items suivants existent dans le vault :\n"
        "  - anthropic-token-principal\n"
        "  - anthropic-token-fallback"
    )

# --- Client HTTP partagé avec lifespan ---
http_client: httpx.AsyncClient | None = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    global http_client
    http_client = httpx.AsyncClient(timeout=None)
    print("🚀 Proxy Transparent Claude Max V4 démarré sur http://127.0.0.1:4000")
    yield
    await http_client.aclose()

app = FastAPI(lifespan=lifespan)

@app.api_route("/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"])
async def transparent_proxy(request: Request, path: str):
    body = await request.body()
    headers = dict(request.headers)

    # Nettoyage des en-têtes
    headers.pop("host", None)
    headers.pop("content-length", None)
    headers.pop("authorization", None)
    headers.pop("accept-encoding", None)

    async def forward_request(token):
        req_headers = headers.copy()
        req_headers["authorization"] = f"Bearer {token}"
        url = f"https://api.anthropic.com/{path}"

        req = http_client.build_request(
            method=request.method,
            url=url,
            headers=req_headers,
            content=body,
            params=request.query_params
        )
        resp = await http_client.send(req, stream=True)
        return resp

    try:
        print(f"\n[>] Requête envoyée à Anthropic avec le Token Principal...")
        resp = await forward_request(TOKEN_PRINCIPAL)

        # Si limite atteinte sur le Principal (429)
        if resp.status_code == 429:
            print("[!] Limite atteinte sur le Principal ! Bascule automatique...")
            await resp.aclose()

            resp = await forward_request(TOKEN_FALLBACK)

            if resp.status_code == 429:
                print("[!] Limite atteinte sur les deux tokens !")
            else:
                print(f"[<] Succès de la bascule. Statut Anthropic : {resp.status_code}")

    except httpx.HTTPError as e:
        print(f"[!] Erreur réseau vers Anthropic : {e}")
        return JSONResponse(
            status_code=502,
            content={"error": "Impossible de joindre l'API Anthropic."}
        )

    # Streaming de la réponse
    async def stream_generator():
        try:
            async for chunk in resp.aiter_bytes():
                yield chunk
        finally:
            await resp.aclose()

    response_headers = {k: v for k, v in resp.headers.items() if k.lower() not in ["content-encoding", "transfer-encoding"]}

    return StreamingResponse(
        stream_generator(),
        status_code=resp.status_code,
        headers=response_headers
    )

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=4000, log_level="warning")
