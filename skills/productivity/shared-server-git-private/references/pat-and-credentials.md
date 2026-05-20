# PAT (Fine-grained)

**Prerequisite:** SKILL workflow step 3 must have run in the target repo so
`credential.helper` is `cache --timeout=...` (via user helper or inline
`git config --local`). PAT does not replace local identity or proxy setup.

**Agent rule:** always **ask the user** for the token in chat. HTTPS username:
`jason-wjs`. Do not read PATs from disk unless the user explicitly approves a
secrets path.

## Create

GitHub → Settings → Developer settings → **Fine-grained personal access tokens**

| Setting | Value |
|---------|--------|
| Repository access | Only select repositories → target private repo(s) |
| Metadata | Read (required) |
| Contents | Read (fetch only) or Read and write (push) |
| Expiration | Finite (30–90 days); avoid "no expiration" on shared hosts |

Use **Fine-grained** over Classic `repo` scope unless a tool requires Classic.

## Deliver

After the user provides the PAT:

```bash
printf 'protocol=https\nhost=github.com\nusername=jason-wjs\npassword=%s\n\n' "$PAT" \
  | git credential approve
```

**Alternative:** user pastes the PAT when `git fetch` / `git push` prompts for
password (username `jason-wjs`).

Cache lifetime is typically ~1 hour. When it expires, ask for the PAT again;
step 3 config (identity/proxy) usually stays — only re-run step 3 if local
config was lost.

## Never

- `credential.helper store`
- PAT in `origin` URL, shell history, or any committed file
- Reusing another user's token or `~/.git-credentials`

## Diagnose

| Symptom | Likely cause | Action |
|---------|----------------|--------|
| `Repository not found` (known private repo) | Repo not in token scope | Add repo to PAT or create new token |
| `403` / write denied on push | Missing `Contents: Read and write` or org SSO | Widen permission; authorize token for org |
| `could not read Username` | Cache empty, no TTY | `credential approve` or interactive prompt |
| `Permission denied (publickey)` | SSH remote on host that blocks SSH | `git remote set-url origin https://github.com/...` |
| Wrong commit author | Step 3 not applied in this repo | Re-run helper or inline `user.*` |
| Works in one repo, fails in another | PAT not scoped to second repo | Add repo to token |

`401` / `403` / `404` from GitHub → fix PAT, scope, expiry, or SSO — not
`user.email`.

## Rotate

1. User creates new Fine-grained PAT (same repo scope).
2. `git credential approve` with new token.
3. Revoke old PAT in GitHub.
4. Verify: `git ls-remote origin` and `git push --dry-run origin HEAD`.
