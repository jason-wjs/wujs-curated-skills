# setup_git_local.sh (optional helper)

Not shipped with this skill. On each host the user may have their own script
at a path **they provide** — there is no canonical path in the skill.

## If the user has a helper

Run from inside the target repo:

```bash
cd <private-repo>
<user-provided-path>/setup_git_local.sh
```

Expected behavior (verify after run):

- `git config --local user.name` → `jason-wjs`
- `git config --local user.email` → `jason-w@sjtu.edu.cn`
- `git config --local credential.helper` → `cache --timeout=...`
- `http.proxy` / `https.proxy` → set only when this host needs them

The helper must not use `git config --global` or store a PAT.

## New host

1. Ask workspace root and whether a helper exists.
2. If copying from another machine: user supplies source path or file content;
  update **proxy** for this host before use.
3. `chmod +x` if needed.
4. One run per new clone (config is per `.git/config`).

Do not embed cluster-specific paths or proxy values in the skill repo.
