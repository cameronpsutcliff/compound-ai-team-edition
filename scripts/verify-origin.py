#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path
from urllib.error import URLError
from urllib.request import urlopen


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "compound-ai.manifest.json"
VERIFY_INTEGRITY = ROOT / "scripts" / "verify-integrity.py"


def load_local_manifest() -> dict:
    return json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))


def fetch_manifest(url: str) -> dict:
    with urlopen(url, timeout=8) as response:
        return json.loads(response.read().decode("utf-8"))


def local_integrity_ok() -> bool:
    result = subprocess.run(
        [sys.executable, str(VERIFY_INTEGRITY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    print(result.stdout.strip())
    if result.stderr.strip():
        print(result.stderr.strip(), file=sys.stderr)
    return result.returncode == 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify Compound AI Starter Kit origin.")
    parser.add_argument("--online", action="store_true", help="Compare against the canonical online manifest.")
    parser.add_argument("--manifest-url", help="Override canonical manifest URL.")
    args = parser.parse_args()

    if not MANIFEST_PATH.exists():
        print("UNKNOWN: local manifest missing")
        return 2

    local = load_local_manifest()
    if not local_integrity_ok():
        print("Status: MODIFIED")
        return 1

    if not args.online:
        print("Status: LOCAL-ONLY")
        print("Online verification not requested.")
        return 0

    manifest_url = args.manifest_url
    if not manifest_url:
        canonical = str(local.get("canonical_url", "")).rstrip("/")
        manifest_url = f"{canonical}/manifest.json"

    try:
        remote = fetch_manifest(manifest_url)
    except (URLError, TimeoutError, json.JSONDecodeError) as exc:
        print(f"Status: LOCAL-ONLY")
        print(f"Online verification unavailable: {exc}")
        return 0

    comparable_fields = ["origin_id", "version", "aggregate_sha256"]
    mismatches = [
        field for field in comparable_fields
        if local.get(field) != remote.get(field)
    ]
    if mismatches:
        print("Status: FORKED")
        print("Remote manifest differs in:")
        for field in mismatches:
            print(f"  - {field}")
        return 1

    print("Status: VERIFIED")
    print(f"Manifest URL: {manifest_url}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

