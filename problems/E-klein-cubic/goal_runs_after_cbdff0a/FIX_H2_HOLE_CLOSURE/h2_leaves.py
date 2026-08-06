#!/usr/bin/env python3
"""FIX-H2 TASK A step 1: reproduce the six residual FIX-H1 leaves.

Runs the FIX-H1 branch-and-reduce (copied verbatim into this packet) on the
r = 8 strata B and D in all three eigenblocks and prints the leaf table, so
that the identity of the six undecided leaves (B_43, D_41 per block) is
re-established here rather than taken on trust.

usage:  h2_leaves.py [r]
"""
import sys
import time

import holes_reduce as RD
import holes_track as TR


def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    for lam in ('one', 'om', 'om2'):
        for which in ('A', 'B', 'C', 'D'):
            t0 = time.time()
            br, blk, vs = TR.stratum_branch(r, lam, which)
            leaves = TR.solve(br)
            big = [(i, lf) for i, lf in enumerate(leaves) if len(lf.names) >= 8]
            print('r=%d lam=%-4s stratum %s (%s=1,%s=0): %d leaves, '
                  'max vars %d  (%.1f s)'
                  % (r, lam, which, vs[0], vs[1], len(leaves),
                     max(len(lf.names) for lf in leaves), time.time() - t0),
                  flush=True)
            for i, lf in big:
                print('   HARD leaf %s_%d: %d vars %s, %d gens, path %s'
                      % (which, i, len(lf.names), lf.names, len(lf.polys),
                         lf.path), flush=True)
                degs = sorted({sum(k) for q in lf.polys for k in q})
                print('        degrees %s' % degs, flush=True)
                for q in sorted(lf.polys, key=len)[:4]:
                    s = RD.polystr(q, lf.names)
                    print('        %s' % (s if len(s) < 400 else s[:400] + ' ...'),
                          flush=True)


if __name__ == '__main__':
    main()
