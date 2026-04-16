# MCP Scan Audit Report

**Date:** 2026-04-15
**Tool:** mcp-scan (Snyk Agent Scan) v0.4.16
**Config scanned:** ~/.claude.json

---

## MCP Servers Scanned

| Server | Type | Path |
|--------|------|------|
| clawmem | local process (bun) | ~/.bun/install/global/node_modules/clawmem/bin/clawmem |

Note: `telegram@claude-plugins-official` was not found in `~/.claude.json` at time of audit. Only `clawmem` is registered globally.

---

## Findings: clawmem

**Version:** 0.10.0  
**Description:** On-device memory layer for AI agents (QMD search + SAME memory layer, hooks + MCP server)

### Tools Exposed (30 tools)

| Tool | Risk Category | Notes |
|------|--------------|-------|
| `__IMPORTANT` | WARNING | System prompt injection vector — tool name starting with `__` and containing instructions is a known prompt injection pattern |
| `memory_retrieve` | LOW | Read-only memory access |
| `search` | LOW | Search memory |
| `vsearch` | LOW | Vector similarity search |
| `query` | LOW | Query memory store |
| `memory_forget` | MEDIUM | Destructive — can delete memories |
| `profile` | LOW | Read profile data |
| `get` / `multi_get` | LOW | Retrieve memory entries |
| `status` | LOW | Status check |
| `find_similar` | LOW | Similarity search |
| `reindex` | MEDIUM | Modifies index structure |
| `index_stats` | LOW | Read-only stats |
| `session_log` | MEDIUM | Access to session history logs |
| `beads_sync` | MEDIUM | Sync operation — scope unclear |
| `build_graphs` | MEDIUM | Builds knowledge graphs from memory |
| `intent_search` | LOW | Semantic search |
| `query_plan` | LOW | Read-only query planning |
| `find_causal_links` | MEDIUM | Graph traversal across memory |
| `kg_query` | MEDIUM | Knowledge graph queries |
| `memory_evolution_status` | LOW | Read-only |
| `timeline` | LOW | Timeline view |
| `memory_pin` | MEDIUM | Can pin/prioritize memories (persistence control) |
| `memory_snooze` | LOW | Temporarily hide memories |
| `lifecycle_status` | LOW | Read-only |
| `lifecycle_sweep` | HIGH | Bulk memory deletion/cleanup operation |
| `lifecycle_restore` | MEDIUM | Restore deleted memories |
| `list_vaults` | LOW | List storage vaults |
| `vault_sync` | MEDIUM | Sync vault contents |
| `diary_write` | HIGH | Writes to persistent diary — exfiltration vector if compromised |
| `diary_read` | MEDIUM | Reads diary contents |

### Resources Exposed

- `temp. document` — temporary document resource (scope: session)

---

## Security Analysis

### WARNING — `__IMPORTANT` Tool

The tool named `__IMPORTANT` is a well-known prompt injection pattern. Malicious MCP servers use tools starting with `__` or containing `IMPORTANT` to inject instructions into the model context. This tool should be inspected at the source level to verify its description does not contain adversarial instructions.

**Recommendation:** Run `clawmem mcp inspect-tool __IMPORTANT` or check the tool description in the MCP server source.

### MEDIUM — High Privilege Tools

`lifecycle_sweep`, `diary_write`, and `memory_forget` can respectively bulk-delete memories, write persistent data, and delete specific memories. If a compromised prompt reaches Claude while clawmem is active, these tools could be abused to:
- Exfiltrate context via `diary_write`
- Destroy memory state via `lifecycle_sweep`

### LOW — No Network Exposure

clawmem is a local process (stdio transport). It does not expose an HTTP endpoint, reducing the attack surface significantly. No remote code execution vector identified.

---

## Verdict

| Category | Status |
|----------|--------|
| Network exposure | OK — local stdio only |
| Tool count | OK — 30 tools, within norms |
| `__IMPORTANT` pattern | WARNING — inspect tool description |
| Destructive tools | WARNING — lifecycle_sweep + diary_write |
| Snyk cloud verification | SKIPPED — SNYK_TOKEN not configured |
| telegram MCP server | N/A — not present in config |

**Overall: WARNING** (2 warnings, no critical, no token for full cloud analysis)

---

## Recommendations

1. Inspect `__IMPORTANT` tool description in clawmem source to verify no prompt injection payload
2. Set `SNYK_TOKEN` env var to enable full Snyk cloud analysis on next scan
3. Consider restricting `lifecycle_sweep` and `diary_write` to explicit user confirmation flows
4. Add `telegram@claude-plugins-official` to config if intended, then re-audit

---

## Next Scan

Weekly cron via KAIROS — every Monday at 11:00 UTC (see `kairos/config.yml` job `mcp-scan-weekly`)
