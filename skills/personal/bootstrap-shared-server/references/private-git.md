# Private Git

Configure private Git per repository. Never change shared/global Git identity,
proxy, or credential settings.

## Fixed personal identity

```text
user.name  = jason-wjs
user.email = jason-w@sjtu.edu.cn
HTTPS user = jason-wjs
```

## Repository setup

Inside each personal repository:

```bash
git config --local user.name "jason-wjs"
git config --local user.email "jason-w@sjtu.edu.cn"
git config --local credential.helper "cache --timeout=3600"
```

Only when the network audit says GitHub needs a proxy:

```bash
git config --local http.proxy "<github-proxy-url>"
git config --local https.proxy "<github-proxy-url>"
```

An optional personal helper may apply these local settings from inside a
repository. Its path is host-specific and must live under the approved
personal root. It must reject directories that are not Git worktrees.

Identity, authentication, and networking are separate:

- `user.*` controls commit attribution;
- the proxy controls connectivity;
- a PAT or SSH key controls repository access.

## HTTPS authentication

Prefer a Fine-grained GitHub PAT with:

- only selected repositories;
- Metadata read;
- Contents read or read/write as required;
- finite expiration.

Do not ask the user to paste the PAT into chat. Have the user enter it in an
interactive terminal without including it in the command text:

```bash
read -rsp "GitHub PAT: " GITHUB_PAT
printf "\n"
printf 'protocol=https\nhost=github.com\nusername=jason-wjs\npassword=%s\n\n' \
  "$GITHUB_PAT" | git credential approve
unset GITHUB_PAT
```

The token must not enter shell history, an origin URL, a generated file,
deployment profile, or service unit. Never use `credential.helper store`.

Credential cache is not private from another person using the same Linux UID.

## Existing helper

If a user-provided `setup_git_local.sh` already exists:

1. Read it without exposing secrets.
2. Confirm it uses only `git config --local`.
3. Remove stale host-specific proxy assumptions.
4. Run it only from the intended repository.
5. Verify all resulting local values.

## Verification

```bash
git config --local --get user.name
git config --local --get user.email
git config --local --get credential.helper
git config --local --get-regexp '^(http|https)\.proxy$' || true
git ls-remote origin
git push --dry-run origin HEAD
```

Do not print the credential cache or token. Diagnose 401/403/404 as token
scope, expiry, SSO, or repository permission before changing identity.

