# Skill Author Guide

Purpose: create small, reliable skills that route work without bloating the default context.

Use this file when adding or revising a skill under `skills/`.

---

## What A Skill Is

A skill is a short pointer file that teaches the agent when and how to load deeper project knowledge.

It should not contain the whole framework. It should route the agent to the right files, checks, commands, and examples.

---

## Size Rule

Keep `SKILL.md` under 100 lines, target 80.

If a skill needs more detail, move the detail into a referenced file and link to it.

---

## Required Sections

Each skill should include:

1. **Trigger:** when to use the skill.
2. **Goal:** what the skill helps accomplish.
3. **Inputs:** files, data, or context needed.
4. **Procedure:** the smallest useful workflow.
5. **Outputs:** expected artifact or answer.
6. **Checks:** how to verify the result.
7. **References:** deeper files to load on demand.

---

## Good Skill Behavior

A good skill:

1. Loads the least context needed.
2. Names specific files and commands.
3. Gives the agent a repeatable workflow.
4. Has an obvious finish condition.
5. Can be improved after use.

---

## Bad Skill Behavior

Avoid skills that:

1. Duplicate the whole field guide.
2. Depend on private context unless clearly marked internal.
3. Tell the agent to "be thoughtful" without operational steps.
4. Hide important constraints in prose.
5. Have no verification step.

---

## Promotion Rule

Promote a repeated workflow into a skill when:

1. The workflow happens at least three times.
2. It needs a consistent order of operations.
3. It uses project-specific references.
4. Mistakes are expensive or annoying.

Do not create a skill for one-off work.

---

## Naming

Use short kebab-case names:

- `context-loader`
- `token-economist`
- `quality-gate`
- `pattern-promoter`

The name should describe the job, not the tool.
