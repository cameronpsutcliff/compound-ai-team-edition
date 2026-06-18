# Compound AI Team Edition

The complete Compound AI operating standard, plus a team and enterprise organization layer.

By Cameron Sutcliff. https://cameronsutcliff.com/compound-ai

## What this is

A thin translation layer between your team's plain-text notes and whatever AI model you use. Your
knowledge lives in folders you control; the model is interchangeable; no lock-in.

The Team Edition bundles everything in the Compound AI **Individual** kit and adds the organization
layer on top.

**From the Individual kit (the core):**
- The field guide (`docs/FIELD-GUIDE.md`): token economics, durable context, repeatable AI work, and
  agentic quality control.
- The tiered skill system (`tier-1-global/`, `tier-2-capabilities/`, `tier-3-shells/`): a global
  behavioral layer, reusable capability skills, and deliverable shells.
- Enforcement hooks (`hooks/`) and reusable code (`code/`).

**Added by the Team Edition (the org layer):**
- **team-router** (`tier-2-capabilities/skills/team-router/`): routes your team's notes, meetings, and
  messages into a structured ledger and daily log, with a capability profile so it behaves the same on
  a bare laptop or a power-user box.
- **Command Center** (`command-center/`): a dark dashboard answering "what needs my attention next,"
  with completion persistence across rebuilds. `refresh.py` only renders; state lives in
  `task_state.json`.
- **Installer** (`install/install.py`): plug-and-play setup that asks a couple of questions and wires
  the kit into your workspace.
- **Capability profile** (`capability-profile.md`): a default-off seam so the same skills are smart
  locally and clean on a bare machine.

## Install

```
python install/install.py         # interactive
python install/install.py --auto  # defaults, no questions
```

## Verify portability

```
bash bin/verify-portable.sh
```

## Credits

The three-layer "AI operating system" model and the A.C.E. structure are from Nick Milo (Linking Your
Thinking). This kit is Compound AI by Cameron Sutcliff.

Dual licensed: documentation and templates under CC BY 4.0, code under Apache 2.0. See LICENSE.md.
