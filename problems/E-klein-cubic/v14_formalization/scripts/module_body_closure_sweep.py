#!/usr/bin/env python3
"""
Static in-file body-closure sweep for the module-system migration.

An `@[expose]` def's exported body may only reference public names, and a
`public` theorem's exported statement likewise.  The expose-all posture
(stage 2+) can therefore break a file whose exposed def bodies reference
same-file private lemmas (seen: CentralizerD12.dihedralTo12_mul,
EllipticPolynomialConstancy.mvSuccToRatFuncBase_injective, ...).

This tool scans every file of the given stage configs, computes the
fixpoint of:

  * exposed def/instance (annotated `@[expose]` in the text, or would be
    under expose_all_public_defs): its whole decl text may only reference
    public same-file names;
  * public decl: its statement/signature (text before `:= | by | where`,
    approximated as the first 'proof-start' token at paren depth 0) may
    only reference public same-file names;

pulling every referenced private name into the config's "public" list
(defs get @[expose] automatically under expose_all).  Prints a per-file
report; with --apply, rewrites the config JSONs in place.

Approximate by design: regex decl splitting, bare-identifier matching.
The single stage rebuild catches anything it misses; the point is to fix
the whole set in ONE pass instead of one 25-minute rebuild per name.
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

DECL_KWS = ("def", "theorem", "lemma", "abbrev", "structure", "inductive",
            "class", "instance", "opaque", "macro", "macro_rules", "example")
DECL_LINE = re.compile(
    r"^(?P<prefix>(?:@\[[^\]\n]*\]\s*)*(?:public\s+|private\s+|protected\s+)?"
    r"(?:noncomputable\s+)?(?:unsafe\s+)?(?:partial\s+)?)"
    r"(?P<kw>" + "|".join(DECL_KWS) + r")\b\s*(?P<rest>.*)$"
)
IDENT = re.compile(r"[A-Za-zα-ωΑ-Ωͱ-ϿͰ_][\w'!?ₐ-ₜ₀-₉ᵢ-ᵫα-ωΑ-Ωͱ-Ͽ]*")


def strip_comments(t: str) -> str:
    t = re.sub(r"/-.*?-/", lambda m: "\n" * m.group(0).count("\n"), t, flags=re.S)
    return re.sub(r"--[^\n]*", "", t)


def parse_decls(text: str):
    """Yield (name, kind, is_public, is_exposed, decl_text)."""
    lines = text.split("\n")
    starts = []
    for i, l in enumerate(lines):
        m = DECL_LINE.match(l)
        if m:
            starts.append((i, m))
    for idx, (i, m) in enumerate(starts):
        end = starts[idx + 1][0] if idx + 1 < len(starts) else len(lines)
        decl_text = "\n".join(lines[i:end])
        prefix = m.group("prefix") or ""
        rest = m.group("rest").strip()
        nm = IDENT.match(rest)
        name = nm.group(0) if nm else None
        yield (name, m.group("kw"), "public" in prefix, "@[expose]" in prefix,
               "private" in prefix, decl_text)


def split_sig_body(decl_text: str):
    """Crude split at the top-level ':=' / ' by ' / 'where'."""
    depth = 0
    i = 0
    n = len(decl_text)
    while i < n:
        c = decl_text[i]
        if c in "([{⟨":
            depth += 1
        elif c in ")]}⟩":
            depth -= 1
        elif depth == 0:
            if decl_text.startswith(":=", i):
                return decl_text[:i], decl_text[i:]
            if decl_text.startswith("where", i) and (i == 0 or not decl_text[i-1].isalnum()):
                return decl_text[:i], decl_text[i:]
        i += 1
    return decl_text, ""


def sweep_file(path: Path, cfg: dict) -> set[str]:
    text = strip_comments(path.read_text())
    expose_all = bool(cfg.get("expose_all_public_defs", False))
    decls = list(parse_decls(text))
    pub_cfg = set(cfg.get("public", [])) | set(cfg.get("expose", []))
    by_name: dict[str, tuple] = {}
    for d in decls:
        if d[0]:
            by_name.setdefault(d[0], d)

    def is_public(name):
        d = by_name.get(name)
        if d is None:
            return True  # not a same-file decl; out of scope
        if d[4]:  # explicitly `private`: module-private by design, skip
            return True
        return d[2] or name in pub_cfg

    def is_exposed(name):
        d = by_name.get(name)
        if d is None:
            return False
        return d[3] or (expose_all and is_public(name) and d[1] in ("def", "instance"))

    added: set[str] = set()
    changed = True
    while changed:
        changed = False
        for (name, kw, pub, exp, priv, dtext) in decls:
            if priv:
                continue
            eff_pub = pub or (name in pub_cfg) or (name in added)
            eff_exp = exp or (
                expose_all and eff_pub and kw in ("def", "instance"))
            if not eff_pub:
                continue
            sig, body = split_sig_body(dtext)
            # exported surface: signature always; body if exposed def, or
            # term-mode (non-`by`) proof of a public theorem is NOT exported,
            # so only defs/instances/abbrevs count.
            scan = sig
            if eff_exp and kw in ("def", "instance", "abbrev"):
                scan = dtext
            for ref in set(IDENT.findall(scan)):
                if ref == name or ref in added:
                    continue
                d = by_name.get(ref)
                if d is None or d[4]:
                    continue
                if not (d[2] or ref in pub_cfg):
                    added.add(ref)
                    changed = True
        pub_cfg |= added
    return added


def main() -> int:
    apply = "--apply" in sys.argv
    cfgs = [a for a in sys.argv[1:] if a.endswith(".json")]
    total = 0
    for cpath in cfgs:
        cfg_all = json.loads(Path(cpath).read_text())
        dirty = False
        for rel, cfg in cfg_all.items():
            added = sweep_file(ROOT / rel, cfg)
            if added:
                total += len(added)
                print(f"{rel}: +public {sorted(added)}")
                if apply:
                    cfg["public"] = sorted(set(cfg.get("public", [])) | added)
                    dirty = True
        if apply and dirty:
            Path(cpath).write_text(json.dumps(cfg_all, indent=1, sort_keys=True) + "\n")
            print(f"updated {cpath}")
    print(f"total names pulled public: {total}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
