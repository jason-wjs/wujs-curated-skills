---
name: shared-server-git-private
description: Explicit-only ($shared-server-git-private). jason-wjs private Git on shared hosts—per-repo local identity, ask/discover proxy per host, user supplies Fine-grained PAT. Use when invoked for new-cluster git bootstrap or PAT refresh. Not implicit. No hardcoded host paths or proxy URLs.
disable-model-invocation: true
---

# Shared-Server Private Git

**Invoke:** `$shared-server-git-private` only.

Personal skill for **jason-wjs** on shared multi-user hosts.

## Fixed (user-approved only)

| Key | Value |
|-----|--------|
| `user.name` | `jason-wjs` |
| `user.email` | `jason-w@sjtu.edu.cn` |
| HTTPS username (PAT) | `jason-wjs` |

Do **not** ask for name or email. Everything else is **asked or discovered on
this host** — never copied from another cluster.

## Host-specific (ask or discover)

| Item | How |
|------|-----|
| Private workspace root | Ask user |
| `setup_git_local.sh` path | Ask; no default path — see [setup-git-local-helper.md](./references/setup-git-local-helper.md) |
| HTTP(S) proxy for GitHub | Ask user, or check `https_proxy` / `HTTPS_PROXY`, or probe `git ls-remote` / `curl` — never reuse another host's URL |
| Fine-grained PAT | Ask user — [pat-and-credentials.md](./references/pat-and-credentials.md) |

Identity (local `user.*` + optional proxy + cache) ≠ auth (PAT).

## Scenarios

| | When | Focus |
|--|------|--------|
| **A** | New shared server | Helper or inline config; ask/discover proxy; per repo; ask PAT |
| **B** | Repo needs access | Local config if missing; 403/expired cache → ask PAT only |

## Workflow

1. **Ask:** private **repo** path; **workspace root**; **`setup_git_local.sh`** path
   if any; PAT ready or needs token guidance.
2. **Proxy (this host only):** ask user for git HTTPS proxy URL, or read
   `https_proxy`/`HTTPS_PROXY`, or probe connectivity. If none needed, skip
   proxy `git config`. Never hardcode URLs from another cluster.
3. **Per-repo local config** — user helper **or** inline:
   ```bash
   cd <private-repo>
   git config --local user.name  "jason-wjs"
   git config --local user.email "jason-w@sjtu.edu.cn"
   git config --local credential.helper "cache --timeout=3600"
   # only if this host needs proxy for github.com:
   git config --local http.proxy  "<url>"
   git config --local https.proxy "<url>"
   ```
4. **PAT:** ask user →
   ```bash
   printf 'protocol=https\nhost=github.com\nusername=jason-wjs\npassword=%s\n\n' "$PAT" \
     | git credential approve
   ```
   SSH `origin` + publickey failure → switch to HTTPS remote.
5. **Verify:** `git ls-remote origin`; `git push --dry-run origin HEAD`.
6. **Cache expired (~1h):** ask PAT again; redo step 3 only if local config lost.

## Do not

- Invoke without explicit user request.
- Hardcode workspace paths, helper paths, or proxy URLs from another host.
- `git config --global` for identity/proxy/credentials.
- `credential.helper store`; PAT in URLs, repos, or shared dotfiles.
- Read PAT from disk unless user explicitly approves a secrets path.
- Touch paths outside the workspace root the user gave.

## References

- [references/setup-git-local-helper.md](./references/setup-git-local-helper.md)
- [references/pat-and-credentials.md](./references/pat-and-credentials.md)
