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
    r"(?:noncomputable\s+)?(?:unsafe\s+)?(?:partial\s+)?(?:(?:local|scoped)\s+)?)"
    r"(?P<kw>" + "|".join(DECL_KWS) + r")\b\s*(?P<rest>.*)$"
)
IDENT = re.compile(r"[A-Za-zα-ωΑ-Ωͱ-ϿͰ_][\w'!?ₐ-ₜ₀-₉ᵢ-ᵫα-ωΑ-Ωͱ-Ͽ]*")
# declaration names may be written dotted (def Foo.bar); references via dot
# notation appear as the bare last component.
DOTTED = re.compile(IDENT.pattern + r"(?:\." + IDENT.pattern + r")*")
SIMP_ATTR = re.compile(r"@\[[^\]\n]*\b(?:simp|norm_num)\b[^\]\n]*\]")


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
        nm = DOTTED.match(rest)
        name = nm.group(0) if nm else None
        auto_pub = m.group("kw") == "instance" or bool(SIMP_ATTR.search(prefix))
        yield (name, m.group("kw"), "public" in prefix or auto_pub,
               "@[expose]" in prefix, "private " in prefix, decl_text)


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


def sweep_file(path: Path, cfg: dict):
    text = strip_comments(path.read_text())
    expose_all = bool(cfg.get("expose_all_public_defs", False))
    decls = list(parse_decls(text))
    pub_cfg = set(cfg.get("public", [])) | set(cfg.get("expose", []))
    cfg_expose = set(cfg.get("expose", []))
    no_expose = set(cfg.get("no_expose", []))
    by_name: dict[str, tuple] = {}
    for d in decls:
        if d[0]:
            by_name.setdefault(d[0], d)
            by_name.setdefault(d[0].split(".")[-1], d)

    added: set[str] = set()          # names to pull `public`
    added_no_expose: set[str] = set()  # defs whose exposure must be dropped
    changed = True
    while changed:
        changed = False
        for (name, kw, pub, exp, priv, dtext) in decls:
            if priv or name is None:
                continue
            eff_pub = pub or (name in pub_cfg) or (name in added)
            eff_exp = (exp or (expose_all and eff_pub
                               and kw in ("def", "instance"))) \
                and name not in no_expose and name not in added_no_expose
            if not eff_pub:
                continue
            sig, body = split_sig_body(dtext)
            # exported surface: signature always; the body only for exposed
            # defs/instances/abbrevs (term proofs of theorems stay private).
            scans = [("sig", sig)]
            if eff_exp and kw in ("def", "instance", "abbrev"):
                # a Prop-classed instance's `:= by ...` block is a PROOF, not
                # an exported body — never part of the exposure surface.
                is_proof_body = kw == "instance" and \
                    re.match(r"(?::=|where)?\s*by\b", body.strip())
                if not is_proof_body:
                    scans = [("sig", sig), ("body", body)]
            for region, scan in scans:
                for ref in set(IDENT.findall(scan)):
                    if ref == name or ref == name.split(".")[-1]:
                        continue
                    d = by_name.get(ref)
                    if d is None:
                        continue
                    tgt = d[0]
                    if d[4]:  # explicitly `private` in the source
                        if region == "body":
                            # an exposed body may not mention it: drop the
                            # exposure unless downstream needs the unfold,
                            # in which case the private name must go public.
                            if name in cfg_expose:
                                if tgt not in added:
                                    added.add(tgt); changed = True
                                    print(f"  NOTE {path.name}: exposed-by-need "
                                          f"`{name}` forces private `{tgt}` public")
                            elif name not in added_no_expose:
                                added_no_expose.add(name); changed = True
                        # private in a public SIGNATURE would be a hard error
                        # even in legacy-style modules; leave for the build.
                        continue
                    if not (d[2] or tgt in pub_cfg or tgt in added):
                        added.add(tgt); changed = True
        pub_cfg |= added
    return added, added_no_expose


def main() -> int:
    apply = "--apply" in sys.argv
    cfgs = [a for a in sys.argv[1:] if a.endswith(".json")]
    total = 0
    for cpath in cfgs:
        cfg_all = json.loads(Path(cpath).read_text())
        dirty = False
        for rel, cfg in cfg_all.items():
            added, added_ne = sweep_file(ROOT / rel, cfg)
            if added or added_ne:
                total += len(added) + len(added_ne)
                if added:
                    print(f"{rel}: +public {sorted(added)}")
                if added_ne:
                    print(f"{rel}: +no_expose {sorted(added_ne)}")
                if apply:
                    if added:
                        cfg["public"] = sorted(set(cfg.get("public", [])) | added)
                    if added_ne:
                        cfg["no_expose"] = sorted(
                            set(cfg.get("no_expose", [])) | added_ne)
                    dirty = True
        if apply and dirty:
            Path(cpath).write_text(json.dumps(cfg_all, indent=1, sort_keys=True) + "\n")
            print(f"updated {cpath}")
    print(f"total names pulled public: {total}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
