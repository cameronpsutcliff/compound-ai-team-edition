# Command Center

The Command Center is a single-page HTML dashboard that shows your team's live task state. It has two parts:

- **task_state.json** - the source of truth. team-router writes to it. You can also edit it by hand.
- **command-center.html** - the rendered view. refresh.py generates it. Open in any browser.

---

## Quick Start

**Step 1.** Copy the example state file to create your own:

```
cp task_state.example.json task_state.json
```

Edit task_state.json to set your name, headline, and real tasks. See the schema notes below.

**Step 2.** Render the dashboard:

```
python3 refresh.py
```

Open command-center.html in your browser. Reload after each run to see updates.

---

## How State Works

Completion is stored in task_state.json, not in the HTML. When you mark a task `"status": "done"`, that state survives every future rebuild. refresh.py only renders - it never resets a "done" back to "open".

The three valid status values are: `open`, `waiting`, `done`.

task_state.json is the one file to back up or put under version control. The HTML is disposable - regenerate it any time.

---

## Running on a Schedule

If your `team/capability-profile.md` has `scheduled_agents: true`, you can wire refresh.py to a system timer (cron, launchd, Task Scheduler) so the dashboard rebuilds automatically whenever team-router updates task_state.json.

If `scheduled_agents: false` (the default for a bare laptop), just run `python3 refresh.py` on demand - before a standup, after a planning session, whenever you want a fresh view.

---

## task_state.json at a Glance

```json
{
  "generated": "2026-06-16",
  "owner": "Your Name",
  "headline": "What needs my attention next.",
  "workstreams": [
    {
      "key": "platform",
      "label": "Platform",
      "accent": "blue",
      "lead": "Dana Lee",
      "items": [
        {
          "id": "p1",
          "title": "Short imperative task",
          "status": "open",
          "due": "2026-06-20",
          "note": "one line of context",
          "lineage": "knowledge/acme-platform-kickoff.md"
        }
      ]
    }
  ]
}
```

Workstream accents are: `blue`, `purple`, `green`, `amber`. The `lineage` field points to the source note that produced the task - follow it for full context.

---

## No Dependencies

refresh.py uses Python 3 standard library only. No packages to install. No network calls. Works on any machine with Python 3.
