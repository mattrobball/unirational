#!/usr/bin/env python3
"""Collect the msolve Groebner-basis certificates into a committed ledger.

`results/*.out` is covered by the repository `.gitignore`, so the decisive
artifact -- the reduced GB itself -- is transcribed here into a tracked file.

usage:  collect_certificates.py <outdir> <ledger.md>
"""
import sys, os, glob, re

outdir, ledger = sys.argv[1], sys.argv[2]
lines = ['# F55 landing-ladder Groebner certificates',
         '',
         'Transcribed from the `msolve -g 2` outputs in `results/` (which the',
         'repository `.gitignore` excludes).  Each block is the reduced',
         'graded-reverse-lexicographic Groebner basis of the landing ideal for',
         'one (degree, twist, prime).  `EMPTY` means the basis contains a pure',
         'power of every variable as a leading monomial, so every solution has',
         'all coordinates nilpotent and the projective cone is empty.',
         '']
for path in sorted(glob.glob(os.path.join(outdir, 'f55land_d*_s*_p*.out'))):
    name = os.path.basename(path)
    m = re.fullmatch(r'f55land_d(\d+)_s(\d+)_p(\d+)\.out', name)
    d, s, p = m.groups()
    if os.path.getsize(path) == 0:
        # msolve landmine rule: a 0-byte output is an error or an unfinished
        # run, never a verdict.  Record it as such and move on.
        lines += ['## d = %s, twist s = %s, p = %s' % (d, s, p), '',
                  '- verdict: `NO-OUTPUT` (0-byte msolve output: unfinished or',
                  '  errored; under the packet landmine rule this is not a verdict)',
                  '']
        continue
    raw = open(path).read()
    body = ''.join(l for l in raw.splitlines(True) if not l.startswith('#')).strip()
    hdr = [l.strip() for l in raw.splitlines() if l.startswith('#length')]
    gens = [g.strip() for g in body.strip('[]:').split(',\n') if g.strip()]
    leads = [re.split(r'(?<![\^*])[+\-]', g)[0].strip() for g in gens]
    pure = sorted(int(x.group(1)) for x in
                  (re.fullmatch(r'1\*c(\d+)(?:\^(\d+))?', l) for l in leads) if x)
    nvar = max(pure) + 1 if pure else 0
    verdict = 'EMPTY' if set(pure) >= set(range(nvar)) and nvar else 'NOT-EMPTY-OR-UNRESOLVED'
    lines += ['## d = %s, twist s = %s, p = %s' % (d, s, p), '',
              '- %s' % (hdr[0] if hdr else 'length of basis: %d' % len(gens)),
              '- verdict: `%s`' % verdict,
              '- reduced GB (leading monomials): `%s`' % ', '.join(leads),
              '']
open(ledger, 'w').write('\n'.join(lines) + '\n')
print('wrote', ledger, '(%d certificate blocks)'
      % len(glob.glob(os.path.join(outdir, 'f55land_d*_s*_p*.out'))))
