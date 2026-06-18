<!--
  AGENT.annotated.md, Operating Contract Template with margin notes
  From: Compound AI Operating Standards v1.0
  Source: https://github.com/cameronpsutcliff/compound-ai-operating-standards
  Canonical URL: https://cameronsutcliff.com/compound-ai
  Author: Cameron Sutcliff
  License: CC BY 4.0, attribution required

  This is the teaching version. Every section is followed by a margin note
  (`> note:`) explaining the choice, the failure mode it prevents, and the
  rule of thumb for filling it in. For the deployable version with
  annotations stripped, use AGENT.md.

  Aliases: Claude Code reads CLAUDE.md natively, Codex CLI reads AGENTS.md,
  Cursor reads .cursorrules, Copilot reads .github/copilot-instructions.md,
  Aider reads CONVENTIONS.md, Continue.dev reads a referenced instructions
  file via config. The simplest portable convention is to keep the content
  in AGENT.md and symlink or duplicate to the platform-native filename.
-->

# [Project Name], Operating Contract

> One sentence: what this project is and who it serves.

**Last reviewed:** YYYY-MM-DD
**Current phase:** [Demo | Ramp-up | Durable]
**Source of truth for state:** `./STATE.md`
**Source of truth for history:** `./session-log.md`

> **note (header):** The single sentence forces clarity about what the project *is* before any tool, framework, or vendor name appears. The phase tag is load-bearing, it tells the session whether to optimize for speed (Demo), structure (Ramp-up), or reliability (Durable). The two source-of-truth pointers prevent the session from re-deriving state.

## 1. What this project is NOT

- Not [common misreading of the project, what it could be mistaken for]
- Not [adjacent project this gets confused with]
- Not [thing reviewers will assume you are building]

> **note (Section 1):** This is the single most token-saving section. An AI agent will burn 2,000+ tokens going down the wrong path if it pattern-matches the project to the wrong reference architecture. Three "is not" statements is usually enough.

## 2. Hard constraints (the things that burn tokens when violated)

- **Never** [destructive op]. Example: never run `git push --force` on `main`.
- **Never** [vendor or tool the project rejected]. Example: never propose Supabase migrations; the project left.
- **Never** [pattern that already failed]. Example: never re-litigate the registry migration; the decision is in `docs/decisions/0007.md`.
- **Always** [non-obvious requirement]. Example: always use `uv`, not pip.
- **Always** [convention the harness enforces]. Example: no em dashes, there is a hook that will block your commit.

> **note (Section 2):** Phrase as "Never X" / "Always Y", imperatives, not suggestions. Each line earns its place by referring to a specific past failure. If you cannot cite a failure or a hard constraint, the line is filler and should be cut.

## 3. Tech stack (the ground truth, not the aspiration)

| Layer | Tool | Why |
|---|---|---|
| Language | [Python 3.12 / TypeScript / etc.] | [one-line rationale] |
| Package manager | [uv / pnpm / cargo] | [one-line rationale] |
| Database | [SQLite at `data/X.db` / Postgres / etc.] | [one-line rationale] |
| Test runner | [pytest / vitest / cargo test] | [one-line rationale] |
| Models | [list, with routing notes] | See `conventions/model-routing.md` |
| Cache | [response cache table / file-based / etc.] | [one-line rationale] |

**Local dev:** `[exact command to run the system locally]`
**Tests:** `[exact command]`
**Lint/format:** `[exact command]`

> **note (Section 3):** The "ground truth, not the aspiration" framing matters. A surprising number of operating contracts list the tech stack the project *wants* to be on, not the one it is on. The session then proposes refactors toward the aspiration and burns the whole budget.

## 4. Where context lives (explicit paths only)

| Question the session might ask | Where to look |
|---|---|
| "What is the current state of the project?" | `./STATE.md` |
| "What changed recently?" | `./session-log.md` (newest entries at top) |
| "What is the full spec?" | `./docs/requirements.md`, `./docs/design.md` |
| "What architectural decisions have we made?" | `./docs/decisions/` (ADRs, numbered) |
| "What is broken or open?" | `./BACKLOG.md` |
| "What patterns apply across our projects?" | `[absolute path to shared patterns doc]` |

**Rule:** Vague pointers ("see the docs") cost the session 500-2,000 tokens of file-hunting. Explicit paths cost 0. Update this table when files move.

> **note (Section 4):** This is the layered-context architecture in its smallest form. The session loads this file (cheap) and now knows exactly where to load deeper context from (also cheap, only what is needed). The alternative, front-loading everything into the operating contract, burns tokens on every session for context most sessions do not need.

## 5. Context tiers (what to load when)

This project uses three context tiers. The session chooses based on task:

- **Tier 0 (always load, ~300 tokens):** This file.
- **Tier 1 (load for most sessions, ~1,500 tokens):** `./context/tier1-current.md` (live state, written by the previous session). Plus the relevant `./context/tier1-subsystem/[area].md` if working in one area.
- **Tier 2 (load on demand, 2K-10K tokens):** Full spec, full design doc, full session log. Only when the task explicitly requires it.
- **Tier 3 (never load directly, use RAG or DB query):** Full codebase, full historical archive, large reference taxonomies.

If the session is mechanical (one-file fix, formatter, validator), Tier 0 alone is enough. Resist loading Tier 1+ for mechanical work.

> **note (Section 5):** This is the explicit policy. Without it, the model defaults to "load everything just in case", which is the most expensive failure mode of all. The numbers (300 / 1,500 / 2K-10K) are calibrations from production systems; adjust for your project's actual file sizes.

## 6. Model routing

Default routing for this project (override per-task if needed):

| Task type | Model | Rationale |
|---|---|---|
| Parsing, classification, extraction | Local (Ollama or equivalent) | Free, fast, deterministic enough. |
| Mechanical edits (rename, format, port) | Cheap tier | No judgment needed. |
| Multi-file engineering | Mid tier | Real engineering, normal cost. |
| Architecture decisions, synthesis | Top tier | The work that produces the value. |
| Status confirmations | Local or cheap | Do not use top tier for "did the test pass?" |

**Rule:** The most expensive token waste is using a top-tier model for a parsing-tier task. The second-most expensive is the inverse.

> **note (Section 6):** The routing table is a *policy*, not a *suggestion*. It belongs in the operating contract (visible to the session) and ideally also enforced by a model-routing constant the codebase reads. Sessions that route their own work waste tokens deliberating; sessions that follow a table just execute.

## 7. Session lifecycle (read at start, write at end)

**At session start:**
1. Read this file (you are doing this now).
2. Read `./STATE.md` (current state, 30 seconds).
3. If the task is in a specific subsystem, read its `./context/tier1-subsystem/[area].md`.
4. If the task is ambiguous, run one semantic search over the project's knowledge index before reading more files. (One search, not five.)

**At session end (before exit):**
1. Update `./STATE.md`, what changed, what is blocked, what is next.
2. Prepend an entry to `./session-log.md`:
   `## YYYY-MM-DD, [one-line summary]`
3. Update `./BACKLOG.md` if items closed or new ones surfaced.
4. If a reusable pattern emerged, promote it to the shared patterns doc.

**The discipline:** a session that does not update `STATE.md` is a session that burned tokens without leaving a trace. The next session has to re-derive everything you learned.

> **note (Section 7):** This is the "filesystem is durable, the session is stateless" principle in operational form. A session that follows this lifecycle costs 5-10 minutes of housekeeping at the end and saves 30-60 minutes of re-orientation at the start of the next session. Net positive across any project with more than three sessions.

## 8. Governance, what NOT to do without a human gate

The agent operates with broad latitude inside this repo. The following are gated, confirm with the human before acting:

- **Destructive git operations:** `push --force`, `reset --hard`, `branch -D`, `clean -f`, history rewrites on shared branches.
- **Anything that costs money** beyond the existing subscription. Cloud spin-ups, paid API calls, billing changes.
- **Publishing externally:** social posts, emails, PRs to public repos, messages to channels with non-team members.
- **Schema changes that drop data:** migrations that `DROP COLUMN` or `DROP TABLE` get human approval, no exceptions.
- **Modifying authentication, permissions, or secrets** in any file the harness reads (`settings.json`, `.env`, key files).

For everything else: act, do not ask.

> **note (Section 8):** The closing line ("For everything else: act, do not ask") is the most important sentence in the file. Without it, the agent will ask for permission on safe operations and burn the human's attention. With it (and a tight gate list above), the human's attention is spent only on actual risk.

## 9. Voice and convention

- **No em dashes.** Use commas, colons, periods, or hyphens. Hook-enforced if available.
- **No "you are a world-class expert" preambles.** They are a tax on the input and a signal of low-effort prompting.
- **Output schema** for any non-trivial task: specify the JSON or table shape. Prose is the failure mode, not the goal.
- **Voice for external content:** see `./docs/voice-profile.md` if applicable.
- **Imperative for commits, declarative for docs.** "Add the cache attribution sidecar" not "Adding the cache attribution sidecar."

> **note (Section 9):** Keep these conventions, or replace with your own. The principle is: explicit conventions get followed; implicit conventions do not. Hook-enforced conventions outlive stated conventions.

## 10. Active operating facts (the things that change)

> Items here are time-sensitive. Review monthly. Move to the design doc if they stabilize. Move to the backlog if they become stale.

- [Active fact 1, with date]
- [Active fact 2, with date]
- [Active fact 3, with date]

> **note (Section 10):** This section is the "STATE.md adjacent" zone, facts that are temporary but affect every session. Keep it short (5-10 items). When an item has been stable for 60+ days, promote it to a more permanent section. When an item has been stale for 30+ days, delete it.

## 11. Pointers (deep references, on demand only)

Don't load these by default. Load when the task is in their domain.

- Patterns library: `Patterns for Durable Agentic Systems` (your durable-patterns reference)
- Token optimization reference: `[absolute path]/Token Optimization Strategies.md`
- Decision log: `./docs/decisions/`
- Past session reflections: `./session-log.md`
- Voice profile: `./docs/voice-profile.md`
- Cross-project state: `[absolute path]/shared/STATE.md`

> **note (Section 11):** The Greater Vault pattern. The session knows what exists and where to find it, but does not pay the token cost of loading it. This is the difference between a 600-token operating contract and a 6,000-token one. The session is faster, the cache is hotter, and the model's attention is concentrated on the actual task.

---

## End-of-file checklist (review when this file is edited)

- [ ] One-sentence project description still accurate?
- [ ] Phase tag still correct? (Demo / Ramp-up / Durable)
- [ ] "What this is NOT" section reflects current misreadings?
- [ ] Hard constraints all still earned by a real failure?
- [ ] Tech stack table matches what `git status` shows?
- [ ] Path table, every path resolves?
- [ ] Model routing table still applies?
- [ ] Active operating facts, anything older than 60 days that should be promoted, or older than 30 days that should be deleted?
- [ ] Total length under ~600 lines? If not, something belongs in a deeper file.

---

## Cross-platform portability

This template is filename-portable across modern agentic IDEs. Same content, different load mechanism per platform:

| Platform | Native filename | Notes |
|---|---|---|
| Claude Code | `CLAUDE.md` (root, also nested per-directory) | Auto-loaded into every session. Nested files cascade. |
| Codex CLI | `AGENTS.md` (or `codex.md`) | Read identically; same eleven sections apply. |
| Cursor | `.cursorrules` or `.cursor/rules/*.mdc` | `.mdc` files take YAML frontmatter that can scope rules to file globs. |
| Copilot CLI | `.github/copilot-instructions.md` | Repo-scoped. |
| Aider | `CONVENTIONS.md` (referenced from `.aider.conf.yml`) | Two-file split. |
| Continue.dev | Referenced from `config.json` `systemMessage` | Same content as above. |

**Portability principle:** the *content* is the same; only the *filename and load mechanism* differ. A reader who has invested 30 minutes in their `AGENT.md` does not need to re-invest 30 minutes to use Cursor or Codex tomorrow. They `cp AGENT.md AGENTS.md` (or symlink) and the work transfers. The AI is interchangeable; the architecture is not.

---

*This operating contract is part of Compound AI Operating Standards by Cameron Sutcliff, licensed under CC BY 4.0. See `LICENSE.md` and `NOTICE.md` for attribution requirements.*
