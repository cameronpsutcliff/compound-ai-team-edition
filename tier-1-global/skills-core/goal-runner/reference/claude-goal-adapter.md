# goal-runner: Claude Code `/goal` Adapter

Claude Code has a built-in `/goal` command in v2.1.139 and later. It sets a
completion condition for the current session, then Claude continues across
turns until a small evaluator model decides the condition is met.

Compound AI treats `/goal` as an adapter, not a dependency. The portable layer
is the goal contract in `goal-contract.md`.

Source checked: official Claude Code docs, `https://code.claude.com/docs/en/goal`.

## When to use `/goal`

Use it when all are true:

1. Host agent is Claude Code v2.1.139 or later.
2. Work has a verifiable completion condition.
3. The operator wants continuation across turns.
4. The stop conditions are clear.

## How to translate

Write the goal contract first, then pass only the completion condition to
Claude Code:

```text
/goal <completion condition>
```

Good:

```text
/goal all package counts are internally consistent, integrity verification
passes from a clean unzip, and README/AGENT/HANDOFF mention v2.6.0
```

Still keep validation and memory in the visible plan. `/goal` decides whether
to keep working; it does not replace the kit's quality gate, token budget, or
closeout discipline.

## Non-Claude fallback

For Codex, Cursor, Aider, Continue, or any agent without `/goal`, run the same
contract manually:

1. Act on the next unit.
2. Validate.
3. Check completion condition.
4. Continue, slow-lane, or stop.

The behavior is the standard; `/goal` is one vendor's automation shortcut.
