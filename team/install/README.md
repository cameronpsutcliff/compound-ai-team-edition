# Team edition installers

Three ways to install the Team edition (same result):

| Installer | When to use |
|---|---|
| `install.py` | Python 3 available; supports custom routing registry prompts |
| `install.sh` | macOS, Linux, or Git Bash; no Python required |
| `install.bat` | Windows cmd or PowerShell |

All three copy the kit into a `Compound AI` folder under your cloud-docs root,
create a `Teams` area in your notes root, and write `team/team-router/templates/routing-registry.md`.
They skip `.git`, `reference-impl`, `derive`, and other maintainer-only paths (same rules as `install.py`).

Non-interactive install:

```bash
bash team/install/install.sh --yes
```

```bat
team\install\install.bat --yes
```

After install, verify from the installed kit root:

```bash
bash "Compound AI/enforcement/bin/check-kit.sh" "Compound AI"
```

On Windows, run that verify command from Git Bash or WSL.

Optional Claude Code hook wiring (requires Python 3 for the merge helper):

```bash
bash "Compound AI/runtime/claude-code/install-adapter.sh" --dry-run
bash "Compound AI/runtime/claude-code/install-adapter.sh" --install
```

See `team/README.md` for the full quick start.
