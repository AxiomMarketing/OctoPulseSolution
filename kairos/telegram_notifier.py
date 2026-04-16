"""KAIROS direct Telegram bot API notifier with throttling."""
import asyncio, json, os, time
from collections import deque
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional
import httpx

PRIORITY_PREFIX = {
    "critical": "🚨 KAIROS CRITICAL",
    "high":     "⚡ KAIROS",
    "normal":   "🤖 KAIROS",
    "debug":    "🔍 KAIROS[debug]",
}

TELEGRAM_MSG_LIMIT = 4000  # under 4096 to leave room for prefix

def _load_bot_token(env_path: str = "~/.claude/channels/telegram/.env") -> Optional[str]:
    p = Path(os.path.expanduser(env_path))
    if not p.exists(): return None
    for line in p.read_text().splitlines():
        line = line.strip()
        if line.startswith("TELEGRAM_BOT_TOKEN="):
            val = line.split("=", 1)[1].strip().strip('"').strip("'")
            return val or None
    return None

@dataclass
class NotifyResult:
    ok: bool
    message_id: Optional[int]
    error: Optional[str]
    throttled: bool
    skipped: bool  # skipped because debug + not dry-run

class TelegramNotifier:
    def __init__(self, *, token: Optional[str] = None, log_dir: str = None,
                 throttle_per_min: int = 5, dry_run: bool = False,
                 env_path: str = "~/.claude/channels/telegram/.env"):
        self.token = token or _load_bot_token(env_path)
        self.dry_run = dry_run or os.environ.get("DRY_RUN") == "1"
        self.throttle_per_min = throttle_per_min
        self._sent_timestamps: dict[str, deque] = {}  # chat_id → deque of monotonic
        self.log_dir = Path(os.path.expanduser(log_dir or "~/logs/kairos"))
        self.log_dir.mkdir(parents=True, exist_ok=True)

    def _is_throttled(self, chat_id: str) -> bool:
        now = time.monotonic()
        dq = self._sent_timestamps.setdefault(chat_id, deque())
        while dq and now - dq[0] > 60:
            dq.popleft()
        if len(dq) >= self.throttle_per_min:
            return True
        dq.append(now)
        return False

    def _chunks(self, text: str, limit: int = TELEGRAM_MSG_LIMIT) -> list[str]:
        if len(text) <= limit:
            return [text]
        out = []
        while text:
            out.append(text[:limit])
            text = text[limit:]
        return out

    async def notify(self, chat_id: str, text: str, priority: str = "normal",
                     parse_mode: str = "Markdown") -> NotifyResult:
        prefix = PRIORITY_PREFIX.get(priority, PRIORITY_PREFIX["normal"])
        full = f"*{prefix}*\n{text}"

        # debug priority: log only, never send (unless dry_run override)
        if priority == "debug" and not self.dry_run:
            self._log({"skipped": "debug priority", "chat_id": chat_id, "preview": text[:120]})
            return NotifyResult(ok=True, message_id=None, error=None, throttled=False, skipped=True)

        if self._is_throttled(chat_id):
            self._log({"throttled": True, "chat_id": chat_id, "priority": priority, "preview": text[:120]})
            return NotifyResult(ok=False, message_id=None, error="throttled", throttled=True, skipped=False)

        if self.dry_run:
            self._log({"dry_run": True, "chat_id": chat_id, "priority": priority, "preview": full[:200]})
            return NotifyResult(ok=True, message_id=None, error=None, throttled=False, skipped=False)

        if not self.token:
            err = "TELEGRAM_BOT_TOKEN introuvable"
            self._log({"error": err})
            return NotifyResult(ok=False, message_id=None, error=err, throttled=False, skipped=False)

        url = f"https://api.telegram.org/bot{self.token}/sendMessage"
        message_id: Optional[int] = None
        try:
            async with httpx.AsyncClient(timeout=15) as client:
                for chunk in self._chunks(full):
                    resp = await client.post(url, json={
                        "chat_id": chat_id, "text": chunk, "parse_mode": parse_mode,
                    })
                    data = resp.json()
                    if not data.get("ok"):
                        err = data.get("description", str(data))
                        # retry without parse_mode (markdown errors)
                        resp2 = await client.post(url, json={"chat_id": chat_id, "text": chunk})
                        data2 = resp2.json()
                        if not data2.get("ok"):
                            self._log({"error": err, "chunk_preview": chunk[:200]})
                            return NotifyResult(ok=False, message_id=message_id, error=err, throttled=False, skipped=False)
                        data = data2
                    message_id = data["result"]["message_id"]
            self._log({"sent": True, "chat_id": chat_id, "priority": priority, "message_id": message_id,
                       "preview": text[:120]})
            return NotifyResult(ok=True, message_id=message_id, error=None, throttled=False, skipped=False)
        except Exception as e:
            self._log({"error": str(e)})
            return NotifyResult(ok=False, message_id=None, error=str(e), throttled=False, skipped=False)

    def _log(self, payload: dict) -> None:
        payload = {"ts": datetime.now(timezone.utc).isoformat(), **payload}
        path = self.log_dir / "telegram.jsonl"
        with path.open("a") as f:
            f.write(json.dumps(payload, ensure_ascii=False) + "\n")

if __name__ == "__main__":
    import sys
    chat_id = sys.argv[1] if len(sys.argv) > 1 else "7234705861"
    text = sys.argv[2] if len(sys.argv) > 2 else "Test KAIROS notifier"
    priority = sys.argv[3] if len(sys.argv) > 3 else "normal"
    n = TelegramNotifier()
    r = asyncio.run(n.notify(chat_id, text, priority))
    print(f"ok={r.ok} mid={r.message_id} err={r.error} throttled={r.throttled} skipped={r.skipped}")
