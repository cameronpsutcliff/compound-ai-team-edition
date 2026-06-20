# Capability Profile

This file is the portability seam for the Compound AI Team edition. It declares what the local
environment can do so every skill can branch on facts instead of assumptions. Change these values
to match your setup; never hard-code environment assumptions inside a skill.

The normative routing contract lives in `capabilities/team-routing.md`.

---

## Shipped (minimal) values

```yaml
filesystem_access: true        # read/write to local folders is always assumed
vector_search: none            # none | chroma | other - set to "chroma" locally if installed
scheduled_agents: false        # true only if a timer (cron, launchd, Task Scheduler) is available
detail_store: folders          # folders | chroma - where lineage detail and intake artifacts live
```

---

## Key by key

| Key | Shipped value | What it controls |
|-----|--------------|-----------------|
| `filesystem_access` | `true` | Skills may read and write markdown files in the vault. Always true in this edition. |
| `vector_search` | `none` | Recall strategy for the team-router. `none` means plain-text grep. `chroma` enables semantic search if Chroma is running locally. |
| `scheduled_agents` | `false` | Whether a background timer can fire `refresh.py` automatically. `false` means the user runs it manually. |
| `detail_store` | `folders` | Where intake artifacts and lineage detail are stored. `folders` keeps everything as markdown files. `chroma` would index them into a local vector store. |

---

## How skills use this

A skill reads this file first. It checks for the capability it needs. If the capability is absent or
set to a minimal value, the skill falls back gracefully.

Fallback rules:

- `vector_search: none` - the team-router uses plain-text keyword search across workstream ledgers.
  No error is thrown. Coverage is slightly lower but the output is correct.
- `scheduled_agents: false` - the user is prompted to run `python team/command-center/refresh.py`
  manually. The skill never assumes a timer fired it.
- `detail_store: folders` - lineage links point to markdown files under `knowledge/`. No vector
  index is built or queried.

Absence of a capability is never an error. It is a branch condition. Every skill must have a
filesystem-only path that works on a bare laptop with no external dependencies.

---

## Going richer locally

A power user may set higher values in a local copy named `capability-profile.local.md`. That file is
already gitignored, so it is never published or shared with the team.

Example local override (not shipped):

```yaml
filesystem_access: true
vector_search: chroma          # a local Chroma instance on its default port
scheduled_agents: true         # cron job fires refresh.py at 08:00 daily
detail_store: chroma           # intake artifacts indexed into chroma collection
```

With `vector_search: chroma`, the team-router sends recall queries to a local Chroma instance
instead of grepping files. With `scheduled_agents: true`, the Command Center refreshes on its
own. Neither value changes the schema or the skill interface - only the execution path.

The shipped profile is deliberately minimal so the kit works anywhere, first time, with no setup
beyond Python 3 and a text editor.
