# Skill: pattern-promoter
# Compound AI Operating Standards
# Source: cameronsutcliff.com/compound-ai | License: Apache 2.0

## What this skill does
Moves a reusable pattern from the session log to the project knowledge layer.

## Triggers
"promote pattern", "save this lesson", "reusable pattern", "add to knowledge", "this should be a standard"

## Promotion checklist
Before promoting, confirm:
- [ ] Does this pattern apply to more than one project or session?
- [ ] Would a new session benefit from knowing this before starting?
- [ ] Is there a reference implementation that can be pointed to?

If yes to all three, promote it.

## Promotion format
Add to `_knowledge/patterns.md`:

```markdown
## Pattern: [Name]

**Problem:** [What situation does this solve?]
**Solution:** [The pattern in one paragraph]
**Reference implementation:** [Explicit path to where this is implemented]
**When NOT to use:** [The conditions where this pattern is wrong]
**First observed:** [Session ID or date]
```

## What NOT to promote
- One-off fixes that are project-specific
- Patterns that only work with a specific vendor or tool (unless the vendor-neutral form is also documented)
- Patterns that have not been validated in at least two contexts

## Source references
- `_knowledge/patterns.md` -- the destination for promoted patterns
- `session-log.md` -- the source for patterns to promote
- Field Guide Chapter 26: The Promotion Rule
