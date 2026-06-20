# team-router procedure (reference)

Full step detail for `team/team-router/SKILL.md`. Load on demand.

## Distillation contract

For each distinct intake item:

1. **Key points.** 2 to 4 facts in plain language.
2. **Captured tasks.** Actions with owner and due date when present.
3. **Key quotes.** Short verbatim lines, attributed.
4. **Knowledge.** Durable facts or decisions worth keeping.
5. **Lineage link.** Relative path under `knowledge/`, for example `knowledge/acme-platform-kickoff.md`.

Save unsaved sources under `knowledge/` first. Never paste raw intake into ledgers.

## Routing

Score against `templates/routing-registry.md` (people + client/keyword signals).

- Strong match: file into that workstream.
- Tie or low confidence: propose the workstream, one-line rationale, wait for approval.

Default workstreams: Platform (blue), Data (purple), Adoption (green), Risk (amber).

## Ledger shape

Update in place using `templates/team-ledger.md`:

- Assets, My accountabilities, Key knowledge, People, What to run with now.

## Daily log

Append completions to today's log via `templates/daily-log.md`. Ledger is current state; log is history.

## Command Center schema

Update `team/command-center/task_state.json`:

- Workstream: `key`, `label`, `accent`, `lead`, `items[]`
- Item: `id`, `title`, `status` (`open`|`waiting`|`done`), `due`, `note`, `lineage`
- Done items persist across rebuilds; refresh.py only renders.

After update:

- `scheduled_agents: false` -> prompt `python3 team/command-center/refresh.py`
- `scheduled_agents: true` -> note timer will rebuild

## Capability profile keys

Read `team/capability-profile.md`:

| Key | `none` / `false` / `folders` behavior |
|-----|----------------------------------------|
| `vector_search` | Folder and link recall only |
| `detail_store` | Lineage as markdown files under `knowledge/` |
| `scheduled_agents` | Manual refresh.py |

Normative contract: `capabilities/team-routing.md`.
