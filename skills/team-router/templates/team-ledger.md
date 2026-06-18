# Platform Workstream Ledger

**Engagement:** Project Atlas
**Lead:** Dana Lee
**Updated:** {{YYYY-MM-DD}}

---

## Assets we are building

- API integration layer between Acme Corp's data pipeline and the Platform services
- Deployment runbook covering environment setup, rollback steps, and health checks
- Architecture decision log capturing key choices and the reasoning behind them
- Stakeholder-facing status page (static HTML, no backend dependency)

---

## My accountabilities

### Open

- [ ] Finalize API contract with Acme Corp infrastructure team by 2026-06-20
- [ ] Draft rollback runbook and route to Dana Lee for review
- [ ] Update architecture decision log with the connector-selection rationale
- [ ] Confirm staging environment credentials with Marco Bianchi
- [ ] Validate end-to-end data flow in staging before cutover window

### Done

- [x] Completed discovery call with Acme Corp Platform owners (2026-06-10)
- [x] Mapped existing integration points and flagged three risk areas
- [x] Stood up shared project folder with agreed naming convention
- [x] Delivered scope-of-work summary to Sam Rivera for sign-off

---

## Key knowledge

- The Acme Corp Platform team operates on a two-week sprint cadence; align delivery requests to their sprint boundary (source: knowledge/acme-platform-kickoff.md)
- The connector must use the v2 API endpoint; v1 is deprecated and returns partial data after 2026-07-01 (source: knowledge/acme-api-versioning.md)
- Staging and production use different auth mechanisms; staging uses a shared token, production requires per-service certificates (source: knowledge/acme-env-credentials.md)
- Dana Lee owns the final architecture sign-off; no infrastructure changes ship without her approval (source: knowledge/platform-decision-authority.md)
- Rollback window is 15 minutes post-cutover; beyond that, a full re-deployment is required (source: knowledge/deployment-runbook-draft.md)

---

## People

| Name | Role | Contact note |
|---|---|---|
| Dana Lee | Platform Lead | Primary decision-maker for architecture and sign-off |
| Sam Rivera | Engagement Manager | Owns stakeholder communication and scope changes |
| Priya Nair | Data Workstream Lead | Coordinate on shared pipeline contract |
| Marco Bianchi | Acme Corp Infrastructure | Point of contact for environment access and credentials |

---

## What to run with now

1. Send the draft API contract to Marco Bianchi and request written confirmation of the v2 endpoint details by end of week.
2. Complete the rollback runbook, circulate it to Dana Lee, and capture her approval comment in the architecture decision log.
3. Schedule a 30-minute staging walkthrough with Priya Nair to confirm the shared pipeline contract before the cutover window opens.
