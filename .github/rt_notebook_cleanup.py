#!/usr/bin/env python3
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
NOTEBOOK = ROOT / "problems/E-klein-cubic/NOTEBOOK.md"
HEAD = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
FINAL_HEADING = "## 2026-08-10 RT split, restricted dichotomy, and support-escape audit"

text = NOTEBOOK.read_text(encoding="utf-8")

# Remove the stale interim publication entry.  Its degree window and local
# specialization language were superseded by the audited entry immediately
# following it.
pattern = re.compile(
    r"\n## 2026-08-10 RT split completion and correction\n.*?"
    r"(?=\n## 2026-08-10 RT split, restricted dichotomy, and support-escape audit\n)",
    re.S,
)
text, count = pattern.subn("\n", text, count=1)
if count != 1:
    raise SystemExit("stale interim RT entry not found exactly once")

needle = FINAL_HEADING + "\n\nPacket:"
replacement = (
    FINAL_HEADING
    + "\n\nThis entry supersedes the earlier same-day packet-opened entry and all "
      "interim RT-split publication notes.\n\nPacket:"
)
if text.count(needle) != 1:
    raise SystemExit("final RT heading/packet marker not found exactly once")
text = text.replace(needle, replacement, 1)

# Notebook protocol: pin the pre-commit parent at the top and in the final
# entry.  The resulting notebook is committed as the child of this HEAD.
text, count = re.subn(
    r"(notebook parent head: `)[0-9a-f]{7,40}(`)",
    rf"\g<1>{HEAD}\g<2>",
    text,
    count=1,
)
if count != 1:
    raise SystemExit("top notebook parent-head pin not updated")

text, count = re.subn(
    r"(This notebook\nrevision was authored against parent head `)[0-9a-f]{7,40}(`\.)",
    rf"\g<1>{HEAD}\g<2>",
    text,
    count=1,
)
if count != 1:
    raise SystemExit("final-entry parent-head pin not updated")

NOTEBOOK.write_text(text, encoding="utf-8")

for rel in (".github/workflows/rt_notebook_cleanup.yml", ".github/rt_notebook_cleanup.py"):
    path = ROOT / rel
    if path.exists():
        path.unlink()
