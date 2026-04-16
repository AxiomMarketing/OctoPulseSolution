#!/usr/bin/env python3
"""Patch voice handler du plugin Telegram pour transcription Groq in-line."""

import os
import re
import sys

SERVER_FILE = os.environ.get("SERVER_FILE")
if not SERVER_FILE or not os.path.isfile(SERVER_FILE):
    print(f"SERVER_FILE invalide: {SERVER_FILE}", file=sys.stderr)
    sys.exit(1)

with open(SERVER_FILE, "r") as f:
    src = f.read()

MARKER = "/* VOICE_TRANSCRIBE_PATCH */"
if MARKER in src:
    print("[skip] patch deja present")
    sys.exit(0)

# Pattern: bot.on('message:voice', async ctx => { ... })
pattern = re.compile(
    r"bot\.on\('message:voice',\s*async\s+ctx\s*=>\s*\{.*?\n\}\)",
    re.DOTALL,
)

# Nouveau handler: download + transcribe + passe texte a handleInbound
replacement = r"""/* VOICE_TRANSCRIBE_PATCH */
bot.on('message:voice', async ctx => {
  const voice = ctx.message.voice
  let transcribed: string | undefined
  let localPath: string | undefined
  try {
    const file = await ctx.api.getFile(voice.file_id)
    if (file.file_path) {
      const url = `https://api.telegram.org/file/bot${TOKEN}/${file.file_path}`
      const res = await fetch(url)
      const buf = Buffer.from(await res.arrayBuffer())
      const ext = file.file_path.split('.').pop() ?? 'ogg'
      localPath = join(INBOX_DIR, `${Date.now()}-${voice.file_unique_id}.${ext}`)
      mkdirSync(INBOX_DIR, { recursive: true })
      writeFileSync(localPath, buf)
      const TRANSCRIBE_CMD = process.env.VOICE_TRANSCRIBE_CMD || `${homedir()}/octopulse/voice-middleware/transcribe.sh`
      try {
        const proc = Bun.spawnSync([TRANSCRIBE_CMD, localPath], {
          stdout: 'pipe', stderr: 'pipe',
        })
        const out = (await new Response(proc.stdout).text()).trim()
        if (proc.success && out) {
          transcribed = out
        } else {
          const err = await new Response(proc.stderr).text()
          process.stderr.write(`voice transcribe failed: ${err}\n`)
        }
      } catch (e) {
        process.stderr.write(`voice transcribe exception: ${e}\n`)
      }
    }
  } catch (err) {
    process.stderr.write(`voice download failed: ${err}\n`)
  }
  const text = transcribed
    ? transcribed
    : (ctx.message.caption ?? '(voice message)')
  await handleInbound(ctx, text, undefined, {
    kind: 'voice',
    file_id: voice.file_id,
    size: voice.file_size,
    mime: voice.mime_type,
    ...(transcribed ? { transcribed: true } : {}),
  })
})"""

new_src, n = pattern.subn(replacement, src, count=1)
if n == 0:
    print("ERROR: pattern bot.on('message:voice') introuvable", file=sys.stderr)
    sys.exit(2)

with open(SERVER_FILE, "w") as f:
    f.write(new_src)

print(f"[ok] Patch applique ({n} replacement)")
