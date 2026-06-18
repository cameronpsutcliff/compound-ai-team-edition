# Loop Spec: {loop-name}

<!-- @origin: compound-ai-operating-standards v2.7.0 -->

> Required before any loop runs. One file per loop, living next to the loop's
> definition. Full specification:
> `tier-2-capabilities/skills/loop-engineering/references/loop-engineering-full-spec.md`

| Field | Value |
|---|---|
| Purpose (one sentence) | |
| Owner (human) | |
| Runtime + trigger | {runtime + job id/label} @ {schedule or event} |
| Goal / stop condition (verifiable) | |
| Max iterations (per run / per goal) | / |
| No-progress rule | halt after 2 no-op or repeated-rejected iterations |
| Budget ceiling | {tokens / time / iterations / quota} |
| Verification (checker is not maker) | {gate name + how it runs} |
| Memory file (read first, write last) | {path} |
| Escalation target | {inbox / ticket / alert channel} + what is never auto-acted |
| Autonomy ceiling | {scope} because {reversibility / blast radius} |
| Open or closed | closed (open requires explicit operator go) |
| Skills loaded | |
| Registry entry | {job registry id} |
| Review cadence (human reads output) | |

## Iteration anchor set (context reset each cycle)

- this spec
- {state file}
- {skills}

## Notes / incident history

-
