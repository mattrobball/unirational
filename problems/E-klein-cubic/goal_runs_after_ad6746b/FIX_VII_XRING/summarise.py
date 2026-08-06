"""Consolidated payload + the S-recipe deviation record."""
import json, os
from lib_xring import check

HERE = os.path.dirname(os.path.abspath(__file__))
P, P2 = 397, 1321


def L(name, p=None):
    fn = name % p if p is not None else name
    return json.load(open(os.path.join(HERE, "payload", fn)))


fam = L("S_family_analysis.json")
d1, t1, s1 = L("cov_dims_p%d.json", P), L("ideal_table_p%d.json", P), L("stage4_p%d.json", P)
g1 = L("G660_p%d.json", P)

check("S_recipe_is_weil_sqrt_labeling",
      tuple(fam["sqrt_labeling"]) == tuple(g1["recipe"]["b"]) and not fam["intersection"],
      "brief's b=(1,2,4,3,5) family has 0 hits; the 5 working labelings are the "
      "u-orbit of the Weil square-root labeling b_i^2 = e_i mod 11, b=%s"
      % g1["recipe"]["b"])

summary = {
    "primes": [P, P2],
    "group": {"order": g1["linear_order"], "projective_order": g1["projective_order"],
              "order_profile": g1["order_profile"],
              "S_recipe": g1["recipe"],
              "S_recipe_note": "M_{jk} = s_j s_k (zeta^{t b_j b_k} - zeta^{-t b_j b_k}) with "
                               "b_i^2 = e_i mod 11 (Weil odd-function basis), then rescaled "
                               "to S^2 = I, det S = 1",
              "S_family_analysis": fam},
    "cov_dims": {"map": d1["map"], "polar": d1["polar"], "triv": d1["triv"]},
    "hessian_curve": {"H": s1["H"], "degree": 20, "genus_pa": 26,
                      "HP": "20i-25", "HF": t1["HF_C"], "min_gens": "15 quartics"},
    "ideal_table": t1["table"],
    "banked_bounds": {"map": t1["bound_map"], "polar": t1["bound_polar"]},
    "bounds_are_tight_at_every_degree": all(
        t1["table"][k][d]["ideal_mult"] == t1["bound_%s" % k][d]
        for k in ("map", "polar") for d in range(12)),
    "generators": {
        "invariants": {"F(deg 3)": "x0^2x1+x1^2x2+x2^2x3+x3^2x4+x4^2x0",
                       "H(deg 5)": s1["H"], "J6(deg 6)": s1["J6"],
                       "Fdual(deg 3 on W-bar)": s1["Fdual"]},
        "polar": {"d=2": "gradF (spans)", "d=4": "gradH (spans)",
                  "d=5": "{F*gradF, gradJ6} (spans; coords %s / %s)"
                         % (s1["polar5"]["F*gradF"], s1["polar5"]["gradJ6"])},
        "map": {"d=1": "x (identity)",
                "d=4": "{F*x, gradFdual o gradF} (spans; coords %s / %s)"
                       % (s1["map4"]["F_times_x"], s1["map4"]["gradFdual_o_gradF"]),
                "d=6": "{H*x, Fdual''(gradF,gradH)} (spans; both in I_C)"},
        "non_covariants_tested": ["HessF*gradH", "HessH*gradF"]},
    "identities": (
        [r["balanced"] for r in s1.get("polar5_relations", [])] +
        [r["balanced"] for r in s1.get("map6_relations", [])] +
        s1.get("pair_in_terms_of_candidates", {}).get("readable", [])),
    "files": sorted(os.listdir(os.path.join(HERE, "payload"))),
}
with open(os.path.join(HERE, "payload", "SUMMARY.json"), "w") as f:
    json.dump(summary, f, indent=1)
print(json.dumps({k: summary[k] for k in
                  ("cov_dims", "ideal_table", "bounds_are_tight_at_every_degree",
                   "identities")}, indent=1)[:2000])
print("J6 =", s1["J6"])
