#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "compound-ai.manifest.json"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def aggregate_hash(entries: list[dict[str, Any]]) -> str:
    digest = hashlib.sha256()
    for entry in entries:
        line = f"{entry['path']}:{entry['sha256']}:{entry['bytes']}\n"
        digest.update(line.encode("utf-8"))
    return digest.hexdigest()


def main() -> int:
    if not MANIFEST_PATH.exists():
        print("UNKNOWN: compound-ai.manifest.json is missing")
        return 2

    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    expected = manifest.get("files", [])
    if not expected:
        print("UNKNOWN: manifest has no file entries")
        return 2

    checked: list[dict[str, Any]] = []
    missing: list[str] = []
    modified: list[str] = []

    for entry in expected:
        rel = entry["path"]
        path = ROOT / rel
        if not path.exists():
            missing.append(rel)
            continue
        actual_hash = sha256_file(path)
        actual_size = path.stat().st_size
        checked.append({"path": rel, "sha256": actual_hash, "bytes": actual_size})
        if actual_hash != entry["sha256"] or actual_size != entry["bytes"]:
            modified.append(rel)

    aggregate = aggregate_hash(checked)
    aggregate_expected = manifest.get("aggregate_sha256", "")
    aggregate_ok = aggregate == aggregate_expected and len(checked) == len(expected)

    if missing or modified or not aggregate_ok:
        print("MODIFIED: local files do not match bundled manifest")
        if missing:
            print("Missing:")
            for rel in missing:
                print(f"  - {rel}")
        if modified:
            print("Modified:")
            for rel in modified:
                print(f"  - {rel}")
        if not aggregate_ok:
            print(f"Aggregate expected: {aggregate_expected}")
            print(f"Aggregate actual:   {aggregate}")
        return 1

    print("LOCAL-ONLY: local files match bundled manifest")
    print(f"Package: {manifest.get('package_name')}")
    print(f"Version: {manifest.get('version')}")
    print(f"Origin:  {manifest.get('canonical_url')}")
    print(f"Files:   {len(checked)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

