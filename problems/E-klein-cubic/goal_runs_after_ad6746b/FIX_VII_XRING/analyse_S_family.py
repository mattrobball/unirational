"""Which b-labelings in the antisymmetrised-Fourier family actually work?"""
import json, os
import stage1_group as S1

HERE = os.path.dirname(os.path.abspath(__file__))
B = S1.build_generators(397, verbose=False)
hits = B["hits"]
bs = sorted(set(h[0] for h in hits))
print("distinct b-labelings that work (%d):" % len(bs), bs)

base = (1, 2, 4, 3, 5)                       # the brief's suggested labeling
fam = sorted({tuple(min((u * b) % 11, 11 - (u * b) % 11) for b in base)
              for u in range(1, 6)})
print("brief-suggested family (b_i -> u*b_i mod +-11):", fam)
print("intersection with working labelings:", sorted(set(fam) & set(bs)))

EXP = (1, 9, 4, 3, 5)
sq = [[b for b in range(1, 6) if (b * b) % 11 == e][0] for e in EXP]
print("square-root labeling (b_i^2 = e_i mod 11):", sq)
print("is it a hit? ", tuple(sq) in set(bs))
print("t values per working labeling:",
      {b: sorted({h[1] for h in hits if h[0] == b}) for b in bs})
json.dump({"working_b": [list(b) for b in bs],
           "brief_family": [list(b) for b in fam],
           "intersection": [list(b) for b in sorted(set(fam) & set(bs))],
           "sqrt_labeling": sq,
           "n_hits": len(hits)},
          open(os.path.join(HERE, "payload", "S_family_analysis.json"), "w"), indent=1)
