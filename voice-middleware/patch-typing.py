#!/usr/bin/env python3
"""Patch le plugin Telegram pour maintenir le typing indicator pendant que Claude reflechit."""

import os
import re
import sys

SERVER_FILE = os.environ.get("SERVER_FILE")
if not SERVER_FILE or not os.path.isfile(SERVER_FILE):
    print(f"SERVER_FILE invalide: {SERVER_FILE}", file=sys.stderr)
    sys.exit(1)

with open(SERVER_FILE, "r") as f:
    src = f.read()

MARKER = "/* TYPING_KEEPALIVE_PATCH */"
if MARKER in src:
    print("[skip] typing keepalive patch deja present")
    sys.exit(0)

# 1. Insertion du helper en top-level, juste apres les imports/state init.
# On cherche la ligne `void (async () => {` qui demarre le bot polling — on insere juste avant.
helper_block = """
/* TYPING_KEEPALIVE_PATCH */
const activeTypingIntervals = new Map<string, ReturnType<typeof setInterval>>()
const activeTypingTimeouts = new Map<string, ReturnType<typeof setTimeout>>()
function startTypingKeepalive(chat_id: string): void {
  stopTypingKeepalive(chat_id)
  void bot.api.sendChatAction(chat_id, 'typing').catch(() => {})
  const interval = setInterval(() => {
    bot.api.sendChatAction(chat_id, 'typing').catch(() => {})
  }, 4000)
  activeTypingIntervals.set(chat_id, interval)
  const timeout = setTimeout(() => stopTypingKeepalive(chat_id), 5 * 60 * 1000)
  activeTypingTimeouts.set(chat_id, timeout)
}
function stopTypingKeepalive(chat_id: string): void {
  const interval = activeTypingIntervals.get(chat_id)
  if (interval) { clearInterval(interval); activeTypingIntervals.delete(chat_id) }
  const timeout = activeTypingTimeouts.get(chat_id)
  if (timeout) { clearTimeout(timeout); activeTypingTimeouts.delete(chat_id) }
}
/* END TYPING_KEEPALIVE_PATCH */

"""

# Inserer avant la ligne `bot.catch(err => {`
catch_pattern = re.compile(r"^(bot\.catch\(err\s*=>\s*\{)", re.MULTILINE)
m = catch_pattern.search(src)
if not m:
    print("ERROR: bot.catch anchor not found", file=sys.stderr)
    sys.exit(2)
src = src[: m.start()] + helper_block + src[m.start() :]

# 2. Remplacer le `void bot.api.sendChatAction(chat_id, 'typing').catch(() => {})` dans handleInbound
old_call = "void bot.api.sendChatAction(chat_id, 'typing').catch(() => {})"
new_call = "startTypingKeepalive(chat_id)"
if old_call not in src:
    print("ERROR: sendChatAction call not found in handleInbound", file=sys.stderr)
    sys.exit(3)
src = src.replace(old_call, new_call, 1)

# 3. Dans le case 'reply', apres le `try` de sending chunks, on ajoute stopTypingKeepalive.
# On cible juste apres `const chat_id = args.chat_id as string` pour ajouter le stop avant l'envoi
# Non — mieux : on le met apres l'envoi complet (succes) en le rajoutant dans le finally ou juste avant le return/response.
# Approche simple : chercher le debut du case 'reply' et ajouter un `finally` ou un appel apres le dernier sendMessage.
# On localise le pattern specifique apres les files for-loop dans reply.
reply_hook_marker = "const chat_id = args.chat_id as string\n        const text = args.text as string"
replace_with = "const chat_id = args.chat_id as string\n        stopTypingKeepalive(chat_id)\n        const text = args.text as string"
if reply_hook_marker not in src:
    print("ERROR: reply tool chat_id destructure not found", file=sys.stderr)
    sys.exit(4)
src = src.replace(reply_hook_marker, replace_with, 1)

with open(SERVER_FILE, "w") as f:
    f.write(src)

print("[ok] typing keepalive patch applique")
