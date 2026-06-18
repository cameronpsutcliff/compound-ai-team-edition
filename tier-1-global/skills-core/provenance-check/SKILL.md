# Provenance Check

Source: Compound AI Operating Standards by Cameron Sutcliff

Use when the user asks to verify the kit, check origin, inspect attribution, or confirm whether the package is official.

When triggered:

1. Read `compound-ai.manifest.json`.
2. Run `scripts/verify-integrity.py` if available.
3. If online verification is requested, run `scripts/verify-origin.py`.
4. Report one of: `VERIFIED`, `LOCAL-ONLY`, `MODIFIED`, `FORKED`, or `UNKNOWN`.

Normal use must not require network access.

## Source Materials

- `compound-ai.manifest.json`
- `compound-ai.sha256`
- `scripts/verify-integrity.py`
- `scripts/verify-origin.py`
- `NOTICE.md`
- `CITATION.cff`
