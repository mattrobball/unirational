"""Stage 5: compare all dimension / ideal tables between p=397 and p2=1321."""
import json, os, sys
from lib_xring import check

HERE = os.path.dirname(os.path.abspath(__file__))


def load(name, p):
    return json.load(open(os.path.join(HERE, "payload", name % p)))


def run(p=397, p2=1321):
    d1, d2 = load("cov_dims_p%d.json", p), load("cov_dims_p%d.json", p2)
    t1, t2 = load("ideal_table_p%d.json", p), load("ideal_table_p%d.json", p2)
    diffs = []
    for k in ("map", "polar", "triv"):
        if d1[k] != d2[k]:
            diffs.append(("cov_dims." + k, d1[k], d2[k]))
    if t1["HF_C"] != t2["HF_C"]:
        diffs.append(("HF_C", t1["HF_C"], t2["HF_C"]))
    for k in ("map", "polar"):
        if t1["table"][k] != t2["table"][k]:
            diffs.append(("ideal_table." + k, t1["table"][k], t2["table"][k]))
    g1, g2 = load("G660_p%d.json", p), load("G660_p%d.json", p2)
    for k in ("projective_order", "linear_order", "order_profile"):
        if g1[k] != g2[k]:
            diffs.append(("group." + k, g1[k], g2[k]))
    if g1["recipe"]["b"] != g2["recipe"]["b"] or g1["recipe"]["t"] != g2["recipe"]["t"] \
            or g1["recipe"]["signs"] != g2["recipe"]["signs"]:
        diffs.append(("S_recipe", g1["recipe"], g2["recipe"]))
    check("control_prime_agrees", not diffs,
          "p=%d vs p=%d; diffs=%s" % (p, p2, [d[0] for d in diffs]))

    s1, s2 = load("stage4_p%d.json", p), load("stage4_p%d.json", p2)
    idiffs = []
    for key in ("polar5_relations", "map6_relations"):
        r1 = [r["balanced"] for r in s1.get(key, [])]
        r2 = [r["balanced"] for r in s2.get(key, [])]
        if r1 != r2:
            idiffs.append((key, r1, r2))
    if s1.get("Fdual") != s2.get("Fdual"):
        idiffs.append(("Fdual", s1.get("Fdual"), s2.get("Fdual")))
    check("identities_prime_independent", not idiffs, "diffs=%s" % idiffs)
    for key in ("polar5_relations", "map6_relations"):
        for r in s1.get(key, []):
            print("  %s: %s" % (key, r["balanced"]), flush=True)
    return diffs, idiffs


if __name__ == "__main__":
    run()
