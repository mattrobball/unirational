#!/usr/bin/env python3
"""
Module-system migration tool for hand-written V14Formalization files.

Applies a deterministic, idempotent transformation driven by a JSON config:

  * inserts the `module` keyword before the first import,
  * rewrites `import X` to `public import X` (Mathlib's own convention),
  * prefixes configured declarations with `public` or `@[expose] public`,
  * makes every `instance` public (they act through TC resolution, so
    textual-usage scans cannot prove them unused),
  * makes every decl carrying an inline `@[simp]`/`@[norm_num]` attribute
    public (they act through simp sets, same reason),
  * leaves existing `private` declarations untouched (old file-private
    becomes module-private, which is what we want).

Only visibility annotations are ever added; no statement is touched.
Generated files are NOT handled here — their emitters carry the same
annotations (see export_d12_lean.py and export_d12_poly_lean.py).

Usage:
  python3 scripts/module_migrate.py scripts/migration_stage1.json [--check]

The config maps file path (relative to repo root) to:
  {"public": [names...], "expose": [names...]}
Names are matched against the declaration name exactly as written in the
file (including a namespace prefix if the decl is written with one).
`expose` implies `public`. Running twice is a no-op (--check verifies).
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

DECL_KWS = r"(?:def|theorem|lemma|abbrev|structure|inductive|class|instance|opaque)"
# column-0 declaration line, optionally preceded (same line) by attributes
# and/or `noncomputable`.
DECL_RE = re.compile(
    r"^(?P<attrs>(?:@\[[^\]\n]*\]\s*)*)"
    r"(?P<nc>noncomputable\s+)?"
    r"(?P<kw>" + DECL_KWS + r")"
    r"(?P<rest>\s+[^\s:(\[{⦃]+|\s*(?=[:\[({⦃]))",
)
SIMP_ATTR_RE = re.compile(r"@\[[^\]\n]*\b(?:simp|norm_num)\b[^\]\n]*\]")


def decl_name(rest: str) -> str | None:
    rest = rest.strip()
    return rest if rest else None


def migrate_text(text: str, cfg: dict) -> str:
    public = set(cfg.get("public", []))
    expose = set(cfg.get("expose", []))
    public |= expose

    lines = text.split("\n")
    out: list[str] = []
    inserted_module = any(l.strip() == "module" for l in lines)
    in_block_comment = 0

    for line in lines:
        stripped = line.strip()

        # crude block-comment tracking (leaves use only top-level /- ... -/)
        opens = stripped.count("/-")
        closes = stripped.count("-/")

        if in_block_comment > 0:
            out.append(line)
            in_block_comment += opens - closes
            continue

        if not inserted_module and re.match(r"^(?:public\s+)?import\s", line):
            out.append("module")
            out.append("")
            inserted_module = True

        if re.match(r"^import\s", line):
            out.append("public " + line)
            in_block_comment += opens - closes
            continue

        m = DECL_RE.match(line)
        if m and not line.startswith(("public ", "private ", "protected ")):
            attrs = m.group("attrs") or ""
            body_start = m.start("nc") if m.group("nc") else m.start("kw")
            name = decl_name(m.group("rest"))
            is_instance = m.group("kw") == "instance"
            is_simp = bool(SIMP_ATTR_RE.search(attrs))
            already = line[body_start:].startswith("public ")
            want_public = (
                is_instance
                or is_simp
                or (name is not None and name in public)
            )
            want_expose = name is not None and name in expose
            if not already and want_public:
                prefix = line[:body_start]
                if want_expose and "@[expose]" not in attrs:
                    prefix = prefix[: m.start("attrs")] + "@[expose] " + attrs
                out.append(prefix + "public " + line[body_start:])
                in_block_comment += opens - closes
                continue

        out.append(line)
        in_block_comment += opens - closes

    return "\n".join(out)


def main() -> int:
    cfg_path = Path(sys.argv[1])
    check = "--check" in sys.argv[2:]
    config = json.loads(cfg_path.read_text())
    changed = []
    for rel, cfg in config.items():
        p = ROOT / rel
        old = p.read_text()
        new = migrate_text(old, cfg)
        if new != old:
            if check:
                changed.append(rel)
            else:
                p.write_text(new)
                print(f"migrated {rel}")
        else:
            print(f"unchanged {rel}")
    if check and changed:
        print("NOT IDEMPOTENT / PENDING:", changed)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
