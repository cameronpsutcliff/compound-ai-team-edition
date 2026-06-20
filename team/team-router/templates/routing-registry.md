# Routing Registry

This file tells team-router how to assign each item to a workstream.
Fill it with your own teams, people, and keywords. The skill reads this
table at run time; no code change is needed when the team changes.

---

## Workstream Table

| Workstream / folder | People (signals) | Clients / keywords |
|---|---|---|
| `workstreams/platform/` | Dana Lee, Sam Rivera | Project Atlas, platform, infra, infrastructure, deploy, integration, API, backend |
| `workstreams/data/` | Priya Nair | pipeline, model, reporting, analytics, schema, ETL, data quality, dashboard |
| `workstreams/adoption/` | Marco Bianchi | training, rollout, enablement, onboarding, change management, user feedback |
| `workstreams/risk/` | _(unassigned)_ | risk, compliance, blocker, escalation, legal, security, SLA |

---

## Routing Rules

- **Highest signal match wins.** Count keyword and people hits across all rows. Route to the workstream
  with the most hits. One strong hit (a person's name, a client name) outweighs three weak keyword hits.

- **Tie or no clear match: propose and ask.** If two workstreams score equally, or if no row scores above
  a single weak hit, team-router outputs its best guess with a confidence note and asks the operator to
  confirm before writing. Never silently drop an item.

- **Add a row when a new person or client appears.** If intake mentions someone not listed here, add a
  row before routing that batch. Keep the table under 10 rows; split large teams into sub-registries.

- **Keywords are case-insensitive substring matches.** "Platform" matches "platform-level" and "PLATFORM".
  Order within a row does not matter.
