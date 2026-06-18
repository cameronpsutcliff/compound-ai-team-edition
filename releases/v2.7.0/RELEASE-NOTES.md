# Compound AI Operating Standards v2.7.0

Release date: 2026-06-10

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What ships

1. `compound-ai-starter-kit-v2.7.0.zip`
2. `RELEASE-NOTES.md`

## What's new in v2.7.0

v2.7.0 adds the loop engineering layer. v2.6.0 made adoption active; v2.7.0
makes the kit safe to run unattended.

The leverage point in agentic work moved again in mid-2026: from prompting the
agent to designing the loop that prompts the agent. A loop is cron plus a
decision-maker in the body, and a loop without governance is an incident
scheduled for later. This release ships the governance.

### New skill: `loop-engineering` (Tier 2, orchestration)

The checklist any agent follows before building or modifying a recurring,
self-prompting, or goal-seeking run. It enforces:

- **The Loop Spec**: a one-page contract written before the loop first runs
  (purpose, verifiable stop condition, cadence, verification, memory,
  escalation, autonomy ceiling).
- **The three hard stops**: max iterations, no-progress detection, and a
  budget ceiling. A loop missing any of the three is not a loop.
- **Closed-loop default**: bounded paths with evals at every step; open
  exploration requires an explicit operator go and a tighter budget.
- **Maker/checker split**: the model that wrote the work never grades its own
  homework.
- **Memory on disk**: state lives in files, not in conversation context; each
  iteration resets to an anchor set (spec + state + skills).
- **Fail loud**: freshness, exit, and output assertions; a loop that cannot
  fail visibly cannot be trusted to run alone.

### New template: `loop-spec.md` (Tier 2 templates)

The fill-in per-loop contract. One file per loop, living next to the loop's
definition. Pairs with the skill's enforcement rule: no loop runs without a
spec.

### Field Guide: new Chapter 21, Loop Engineering

The long-form chapter joins Part IV (Execution and Orchestration). Chapters
formerly numbered 21 through 33 are now 22 through 34; all inline
cross-references updated.

## Counts

- 28 active skills (13 Tier 1 session infrastructure, 15 Tier 2 capabilities).
- 5 Tier 2 templates.
- 4 project shells (unchanged).

## Compatibility

Additive release. No existing skill, template, convention, or shell changed
behavior. Adopting projects upgrade by copying the new skill and template
directories and re-running `trigger-indexer` (or merging the registry entry
manually).

## License

- Documentation: CC BY 4.0
- Code: Apache 2.0
- Origin: Compound AI Operating Standards by Cameron Sutcliff
