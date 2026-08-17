#!/usr/bin/env python3
"""
Stage driver tooling for the module-system migration (stages 2-5).

Subcommands:
  gen-config <files.txt> <out.json>
      Compute a migration config (public/expose sets per file) for the
      listed modules, from downstream usage scans:
        public  = declaration names referenced by any transitive importer
        expose  = defs referenced downstream inside unfold contexts
                  (simp/dsimp/norm_num lists, `unfold`)
      The apply step (module_migrate.py) additionally publics every
      instance and @[simp]/@[norm_num] declaration automatically.

  fix <config.json> <lake-log>
      Parse compile errors and grow the config:
        - "private declaration `X` ... would need to be public"  -> public X
        - "Unknown identifier `X`" with a private note            -> public X
        - exported-theorem defeq failures                         -> expose head
      Prints what it added; exits 1 if nothing could be auto-fixed.

Used with scripts/module_migrate.py (the applier). See MODULE_MIGRATION.md.
"""
from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

IDENT = r"[^\W\d][\w'!?«»₀-ₜᵢ-ᵫ]*"
DECL_RE = re.compile(
    r"^(?P<mods>(?:@\[[^\]\n]*\]\s*)*(?:public\s+|private\s+|protected\s+|noncomputable\s+|unsafe\s+|partial\s+)*)"
    r"(?P<kind>def|theorem|lemma|abbrev|structure|inductive|class|instance|opaque)"
    r"\s+(?P<name>[\w.«»'!?ₐ-ₜ₀-₉Ͱ-Ͽᵢ-ᵫ]+)",
    re.M,
)
UNFOLD_CTX_RE = re.compile(
    r"(?:simp(?: only)?|norm_num|dsimp(?: only)?|unfold_let|decide)\s*\[([^\]]*)\]"
    r"|unfold\s+((?:[\w.'!?«»₀-ₜͰ-Ͽᵢ-ᵫ]+\s*)+)"
)


def strip_comments(t: str) -> str:
    t = re.sub(r"/-.*?-/", "", t, flags=re.S)
    return re.sub(r"--[^\n]*", "", t)


def load_graph():
    files = {}
    for p in (ROOT / "V14Formalization").glob("*.lean"):
        files["V14Formalization." + p.stem] = p
    for stem in ("V14Solution", "V14Challenge", "V14Formalization", "AxiomAudit"):
        p = ROOT / f"{stem}.lean"
        if p.exists():
            files[stem] = p
    imports = {}
    for m, p in files.items():
        t = strip_comments(p.read_text())
        imports[m] = [
            i
            for i in re.findall(r"^\s*(?:public\s+)?import\s+([\w.«»]+)", t, flags=re.M)
            if i in files
        ]
    return files, imports


def transitive_importers(imports):
    sys.setrecursionlimit(100000)
    memo = {}

    def clo(m):
        if m in memo:
            return memo[m]
        s = set()
        memo[m] = s
        for i in imports.get(m, []):
            s.add(i)
            s |= clo(i)
        return s

    rev = defaultdict(set)
    for m in imports:
        for dep in clo(m):
            rev[dep].add(m)
    return rev


def gen_config(stage_files, out_path):
    files, imports = load_graph()
    rev = transitive_importers(imports)
    tok_re = re.compile(IDENT)
    tok_where = defaultdict(set)     # token -> set(modules containing it)
    unfold_where = defaultdict(set)  # token -> set(modules unfolding it)
    for m, p in files.items():
        t = p.read_text()
        for tok in set(tok_re.findall(t)):
            tok_where[tok].add(m)
        for mm in UNFOLD_CTX_RE.finditer(t):
            inner = (mm.group(1) or "") + " " + (mm.group(2) or "")
            for tok in set(tok_re.findall(inner)):
                unfold_where[tok].add(m)
    cfg = {}
    for m in stage_files:
        p = files[m]
        importers = rev.get(m, set())
        text = strip_comments(p.read_text())
        public, expose = set(), set()
        for d in DECL_RE.finditer(text):
            if "private" in d.group("mods"):
                continue
            name, kind = d.group("name"), d.group("kind")
            last = name.split(".")[-1]
            if tok_where.get(last, set()) & importers:
                public.add(name)
                if kind == "def" and unfold_where.get(last, set()) & importers:
                    expose.add(name)
        # statement closure: defs mentioned in public decl headers must be
        # public; defs mentioned in public term-mode `:= rfl` statements
        # must additionally be exposed (exported-context defeq).
        decls = list(DECL_RE.finditer(text))
        spans = []
        for i, d in enumerate(decls):
            end = decls[i + 1].start() if i + 1 < len(decls) else len(text)
            body = text[d.start():end]
            head, _, proof = body.partition(":=")
            spans.append((d.group("name"), d.group("kind"), head, proof.strip()))
        by_last = {}
        for name, kind, _, _ in spans:
            by_last.setdefault(name.split(".")[-1], (name, kind))
        # blanket posture (see MODULE_MIGRATION.md): every public def is
        # exposed, so reduction (decide/rfl/change) never gets stuck on a
        # converted module's public surface.
        for name, kind, _, _ in spans:
            if name in public and kind == "def":
                expose.add(name)
        tok = re.compile(IDENT)
        changed = True
        while changed:
            changed = False
            for name, kind, head, proof in spans:
                if name not in public:
                    continue
                is_rfl = proof == "rfl" or proof.startswith("rfl\n")
                for w in set(tok.findall(head)):
                    hit = by_last.get(w)
                    if not hit:
                        continue
                    hname, hkind = hit
                    if hname not in public:
                        public.add(hname); changed = True
                    if is_rfl and hkind == "def" and hname not in expose:
                        expose.add(hname); changed = True
                # exposed-body closure: an exposed def's body may only
                # reference public names, and defeq continues through it
                if kind in ("def", "instance") and (name in expose or kind == "instance"):
                    for w in set(tok.findall(proof)):
                        hit = by_last.get(w)
                        if hit and hit[1] == "def":
                            if hit[0] not in public:
                                public.add(hit[0]); changed = True
                            if hit[0] not in expose:
                                expose.add(hit[0]); changed = True
                        elif hit and hit[0] not in public:
                            public.add(hit[0]); changed = True
        rel = str(p.relative_to(ROOT))
        cfg[rel] = {
            "public": sorted(public),
            "expose": sorted(expose),
            "expose_all_public_defs": True,
        }
    Path(out_path).write_text(json.dumps(cfg, indent=1, ensure_ascii=False))
    print(f"wrote {out_path}: {len(cfg)} files")


def build_decl_index():
    files, _ = load_graph()
    idx = defaultdict(set)  # last-component -> set(relpath)
    for m, p in files.items():
        for d in DECL_RE.finditer(strip_comments(p.read_text())):
            idx[d.group("name").split(".")[-1]].add(str(p.relative_to(ROOT)))
    return idx


def fix(cfg_paths, log_path):
    cfgs = {p: json.load(open(p)) for p in cfg_paths}
    merged = {}
    for p, c in cfgs.items():
        for f in c:
            merged[f] = p
    idx = build_decl_index()
    log = open(log_path).read()
    added = []

    def add(kind, name, err_file):
        # prefer the file the error occurred in, else the unique declarer
        cands = [f for f in (err_file,) if f in merged and f in idx.get(name, set())]
        if not cands:
            cands = sorted(idx.get(name, set()) & set(merged))
        if not cands:
            return False
        f = cands[0]
        target = cfgs[merged[f]][f][kind]
        if name not in target:
            target.append(name)
            target.sort()
            added.append((kind, name, f))
        return True

    # private-name errors (both phrasings), with the erroring file
    pat = re.compile(
        r"error: (\S+?\.lean):\d+:\d+: [^\n]*?(?:Unknown identifier|Unknown constant)[^\n]*`(?:[\w.]*?)([\w'!?«»₀-ₜͰ-Ͽᵢ-ᵫ]+)`"
        r"(?:[^\n]*\n)+?Note: A private declaration"
    )
    for m in pat.finditer(log):
        add("public", m.group(2), m.group(1))
    pat2 = re.compile(
        r"error: (\S+?\.lean):\d+:\d+: [^\n]*?private declaration `(?:[\w.]*?)([\w'!?«»₀-ₜͰ-Ͽᵢ-ᵫ]+)`[^\n]*?(?:would need to be public|cannot be exposed|in public)"
    )
    for m in pat2.finditer(log):
        add("public", m.group(2), m.group(1))
    # simp on non-exposed def
    pat4 = re.compile(
        r"error: (\S+?\.lean):\d+:\d+: Invalid simp theorem `(?:[\w.]*?)([\w'!?«»₀-ₜͰ-Ͽᵢ-ᵫ]+)`: Expected a definition with an exposed body"
    )
    for m in pat4.finditer(log):
        add("expose", m.group(2), m.group(1))
    # exported-theorem defeq: expose the LHS head constant
    pat3 = re.compile(
        r"error: (\S+?\.lean):\d+:\d+: Not a definitional equality: the left-hand side\n\s+([\w.'!?«»₀-ₜͰ-Ͽᵢ-ᵫ]+)"
    )
    for m in pat3.finditer(log):
        head = m.group(2).split(".")[-1]
        add("expose", head, m.group(1)) or add("public", head, m.group(1))
    for p, c in cfgs.items():
        json.dump(c, open(p, "w"), indent=1, ensure_ascii=False)
    for kind, name, f in added:
        print(f"  + {kind} {name}  ({f})")
    print(f"fix: {len(added)} additions")
    return 0 if added else 1


if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "gen-config":
        stage_files = [l.strip() for l in open(sys.argv[2]) if l.strip()]
        gen_config(stage_files, sys.argv[3])
    elif cmd == "fix":
        raise SystemExit(fix(sys.argv[2:-1], sys.argv[-1]))
    else:
        raise SystemExit(f"unknown command {cmd}")
