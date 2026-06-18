# Compound AI Operating Standards v1.0.0

Release date: 2026-05-13

Canonical URL: `https://cameronsutcliff.com/compound-ai`

Source repo: `https://github.com/cameronpsutcliff/compound-ai-operating-standards`

## What Ships

This release includes:

1. `compound-ai-starter-kit-v1.0.0.zip`
2. `Compound-AI-Operating-Standards-v1.0.0.md`
3. `WEBSITE-COPY-v1.0.0.md`
4. `RELEASE-NOTES.md`
5. `starter-kit-internal-SHA256SUMS`
6. `SHA256SUMS`

## Starter Kit

The starter kit is the agent-facing download. It includes:

1. `AGENT.md` and `AGENT.annotated.md`
2. Current-state and session-log files
3. Tiered context files
4. Pointer skills
5. Checklists and templates
6. Public style-guide conventions
7. Code examples for schema validation, cache keys, phase wrappers, and pipeline logging
8. Provenance metadata, manifest, checksum, and verification scripts

## Field Guide

The field guide includes 31 chapters and 6 appendices covering:

1. Compound vs. reset AI work
2. Three-era maturity model
3. Context tiers and handoffs
4. Token economics and caching
5. Model routing and orchestration
6. Schema validation, lineage, and quality gates
7. Cross-platform translation
8. Governance and when not to use AI
9. An anonymized worked example
10. Starter-kit tour and citation index

## Website Copy

The downloadable kit is technique-first and anonymized so agents can apply it without product-specific context.

## Three-Agent Review

v1.0.0 passed:

1. Kiro technical accuracy review.
2. Codex package integrity and release packaging review.
3. Claude voice and anti-AI-slop review.

## Verification

The starter kit includes:

```bash
scripts/verify-integrity.py
scripts/verify-origin.py
```

Local verification is the default. Online origin verification is enabled when the canonical website hosts the manifest and checksum.

## License

Documentation and templates: CC BY 4.0.

Code samples: Apache 2.0.

Attribution: Compound AI Operating Standards by Cameron Sutcliff.
