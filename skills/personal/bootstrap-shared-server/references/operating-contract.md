# Operating Contract

## Control plane

Run full bootstrap from the local machine that owns:

- the base SSH config and keys;
- Codex App or local Codex CLI;
- local Codex App logs;
- access to any always-on proxy machine.

A local GUI does not prove local execution. Cursor Remote SSH and a Codex CLI
started after `ssh` normally execute on the server. Detect `$SSH_CONNECTION`,
`$SSH_TTY`, hostname, and local filesystem paths before proceeding.

Remote-only mode may inspect or repair one personal server artifact when the
user explicitly requests it. It must not claim full bootstrap completion.

## Boundary

Multiple people using one Linux UID have the same kernel identity. File modes,
credential caches, process ownership, and loopback listeners do not isolate
them from each other.

This workflow provides:

- explicit personal commands;
- separate state directories;
- workspace allowlists;
- scoped shell and proxy behavior;
- repeatable configuration and rollback.

It does not provide adversarial confidentiality or authorization.

## Change ownership

| Surface | Default |
| --- | --- |
| Local SSH config | Read-only until approved |
| Personal persistent root | May change after candidate review and approval |
| Shared shell files | Never change |
| Global `codex` or Git config | Never change |
| `authorized_keys` | Backup, then append one reviewed key only |
| Proxy laptop user services | Change only after explicit approval |
| Tokens and auth files | User-controlled; do not read or print |

Use timestamped backups next to personal files. For shared files, record a
checksum and preserve exact existing content.

## Authorization

Prepare and review the actual candidate files, selected modules, mappings, and
rollback commands before asking for missing approval. Explicit approval of an
audited plan covers its named actions, including local SSH entries, dedicated
keys, append-only authorized_keys changes, personal launchers, managed Codex,
and user services. Do not ask again for each already-approved step. Ask for
new authorization if scope, host, shared-state impact, or destructive cleanup
changes. Audit and candidate rendering are read-only with respect to live state.

## Preconditions

Require:

1. Working base SSH alias.
2. Existing user-approved persistent personal root.
3. Known workspace root or a decision to use the personal root.
4. Permission to create files under the personal root.
5. A local-controller task when full mode is requested.

Continue read-only discovery and candidate preparation where possible. Ask for
the missing prerequisite before the dependent live action.

## Idempotency

- Discover before rendering.
- Render candidates outside live paths.
- Compare candidate and live file.
- Leave matching files unchanged.
- Back up only before a real replacement.
- Append an SSH key only when its exact public key is absent.
- Enable a service only after unit content and endpoint mappings match.
- Validate every profile against a fixed list and, when stable, its remote
  hostname.

