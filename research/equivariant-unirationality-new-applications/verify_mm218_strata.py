#!/usr/bin/env python3
"""Fixed loci, Condition (A), and the deeper-stratum table for the Fermat No. 2.18 threefold.

Everything reduces to exact linear algebra over Q(zeta_24):

  * a point of X is ([t], [x], w) with w^2 = F(t,x), modulo (t,x,w) ~ (a t, b x, a b w);
  * g = (A, B, mu) acts by (t,x,w) |-> (A t, B x, mu w);
  * (P^1 x P^2)^H = P(W1) x P(W2) summed over pairs of simultaneous eigenspaces,
    because H acts through a product action;
  * over a component, alpha_g and beta_g are the scalars by which g acts on W1, W2,
    and chi_g = mu_g / (alpha_g beta_g) is a character of H.  A fibre point
    (p,q,w) with w != 0 is H-fixed iff chi is trivial; the point w = 0 is always
    H-fixed and lies on Z = X^tau.

Hence, on each component,

    X^H  =  (double cover of P(W1) x P(W2))       if chi is trivial,
            { F = 0 } inside P(W1) x P(W2)        otherwise.

Since chi(tau) = -1, every subgroup containing tau has X^H = Z^{H/<tau>}.

Run:  python3 verify_mm218_strata.py
"""

from __future__ import annotations

from typing import Dict, FrozenSet, List, Optional, Sequence, Tuple

from verify_mm218_model import (
    F, FiniteGroup, IDENT, ONE, TAU, ZERO, Elt, Fld, Mat,
    add, build_G, canonical, closure, common_eigenspaces, div, eigenvalue_at,
    fld, fld_str, is_zero, make_F, mat, mul, neg, norm_point, padd, peq, peval,
    pmul, pscale, psub, sub, substitution_check, x, y, z, z24,
)

I_UNIT = z24(6)

Point = Tuple[Fld, ...]


# --------------------------------------------------------------------------
# Restriction of F to a product of linear subspaces
# --------------------------------------------------------------------------

def restrict_F(W1: List[List[Fld]], W2: List[List[Fld]], poly=None) -> Dict[Tuple[int, ...], Fld]:
    """Coefficients of F on P(W1) x P(W2) in the bases W1, W2.

    Returns a dict {(i,j,k,l,...)} -> coeff of s_i s_j * u_k u_l, stored as
    a dict keyed by (sorted t-index pair, sorted x-index pair).
    """
    d1, d2 = len(W1), len(W2)
    out: Dict[Tuple[int, ...], Fld] = {}
    for i in range(d1):
        for j in range(i, d1):
            for k in range(d2):
                for l in range(k, d2):
                    # coefficient of s_i s_j u_k u_l in F(sum s W1, sum u W2)
                    # obtained by polarization: evaluate on basis combinations.
                    out[(i, j, k, l)] = _coeff(W1, W2, i, j, k, l, poly)
    return out


def _coeff(W1, W2, i, j, k, l, poly=None) -> Fld:
    """Coefficient of s_i s_j u_k u_l in the (2,2)-form F(s.W1, u.W2)."""
    # F is bilinear-symmetric of bidegree (2,2); use polarization identities.
    pol = F if poly is None else poly

    def ev(t_vec, x_vec):
        return peval(pol, (t_vec[0], t_vec[1], x_vec[0], x_vec[1], x_vec[2]))

    def tv(*coeffs):
        v = [ZERO, ZERO]
        for c, b in zip(coeffs, W1):
            for m in range(2):
                v[m] = add(v[m], mul(c, b[m]))
        return v

    def xv(*coeffs):
        v = [ZERO, ZERO, ZERO]
        for c, b in zip(coeffs, W2):
            for m in range(3):
                v[m] = add(v[m], mul(c, b[m]))
        return v

    d1, d2 = len(W1), len(W2)

    def tcoef(idx):
        return tuple(ONE if m == idx else ZERO for m in range(d1))

    def xcoef(idx):
        return tuple(ONE if m == idx else ZERO for m in range(d2))

    def tsum(a, b):
        return tuple(add(p, q) for p, q in zip(a, b))

    # Bilinear form in t: B_t(u,v) with F = B_t(t,t) as a quadratic in t.
    # Similarly quadratic in x.  Polarize both slots.
    def quad(tc, xc):
        return ev(tv(*tc), xv(*xc))

    ti, tj = tcoef(i), tcoef(j)
    xk, xl = xcoef(k), xcoef(l)

    def polar_t(tc1, tc2, xc):
        if i == j:
            return quad(tc1, xc)
        return sub(quad(tsum(tc1, tc2), xc), add(quad(tc1, xc), quad(tc2, xc)))

    def full(xc):
        return polar_t(ti, tj, xc)

    if k == l:
        return full(xk)
    return sub(full(tsum(xk, xl)), add(full(xk), full(xl)))


def restricted_is_zero(W1, W2, poly=None) -> bool:
    return all(is_zero(c) for c in restrict_F(W1, W2, poly).values())


# --------------------------------------------------------------------------
# Fixed loci
# --------------------------------------------------------------------------

class Component:
    """A component P(W1) x P(W2) of the H-fixed locus of P^1 x P^2."""

    def __init__(self, W1: List[List[Fld]], W2: List[List[Fld]], chi_trivial: bool,
                 poly=None) -> None:
        self.W1 = W1
        self.W2 = W2
        self.chi_trivial = chi_trivial
        self.poly = F if poly is None else poly

    @property
    def dim(self) -> int:
        return (len(self.W1) - 1) + (len(self.W2) - 1)

    def base_point(self) -> Optional[Tuple[Point, Point]]:
        if len(self.W1) == 1 and len(self.W2) == 1:
            return (norm_point(self.W1[0]), norm_point(self.W2[0]))
        return None

    def on_Z(self) -> bool:
        """Whether the component meets Z = {F = 0}."""
        if len(self.W1) == 1 and len(self.W2) == 1:
            p, q = self.base_point()  # type: ignore[misc]
            return is_zero(peval(self.poly, (p[0], p[1], q[0], q[1], q[2])))
        return True  # a positive-dimensional linear family always meets the (2,2)-divisor

    def Z_dim(self) -> int:
        """Dimension of Z inside this component (-1 = empty)."""
        if self.dim == 0:
            return 0 if self.on_Z() else -1
        if restricted_is_zero(self.W1, self.W2, self.poly):
            return self.dim
        return self.dim - 1

    def X_dim(self) -> int:
        """Dimension of X^H over this component (-1 = empty)."""
        if self.chi_trivial:
            return self.dim
        return self.Z_dim()

    def describe(self) -> str:
        d1, d2 = len(self.W1) - 1, len(self.W2) - 1
        tag = f"P^{d1} x P^{d2}"
        return f"{tag}{' [chi trivial]' if self.chi_trivial else ''}"


def fixed_components(G: FiniteGroup, elements: List[Elt], H: FrozenSet[int],
                     poly=None) -> List[Component]:
    gens = G.small_gens(H) if len(H) > 1 else []
    matsA = [elements[i][0] for i in gens]
    matsB = [elements[i][1] for i in gens]
    W1s = common_eigenspaces(matsA, 2) if matsA else [[[ONE, ZERO], [ZERO, ONE]]]
    W2s = common_eigenspaces(matsB, 3) if matsB else [
        [[ONE, ZERO, ZERO], [ZERO, ONE, ZERO], [ZERO, ZERO, ONE]]]
    comps = []
    for W1 in W1s:
        for W2 in W2s:
            trivial = True
            for gi in gens:
                A, B, mu = elements[gi]
                alpha = eigenvalue_at(A, W1[0])
                beta = eigenvalue_at(B, W2[0])
                if div(mu, mul(alpha, beta)) != ONE:
                    trivial = False
                    break
            comps.append(Component(W1, W2, trivial, poly))
    return comps


def fixed_dim(G: FiniteGroup, elements: List[Elt], H: FrozenSet[int], poly=None) -> int:
    """dim X^H, with -1 for empty."""
    return max([c.X_dim() for c in fixed_components(G, elements, H, poly)] + [-1])


def fixed_report(G: FiniteGroup, elements: List[Elt], H: FrozenSet[int], poly=None) -> str:
    comps = fixed_components(G, elements, H, poly)
    pieces = []
    for c in comps:
        d = c.X_dim()
        if d < 0:
            continue
        if c.chi_trivial and c.dim == 0:
            pieces.append("2 pts (off Z)" if not c.on_Z() else "1 pt (on Z)")
        elif c.dim == 0:
            pieces.append("1 pt (on Z)")
        else:
            pieces.append(f"dim {d} in {c.describe()}")
    return " + ".join(pieces) if pieces else "empty"


def fixed_points_finite(G: FiniteGroup, elements: List[Elt],
                        H: FrozenSet[int]) -> Optional[List[Tuple[Point, Point, str]]]:
    """Explicit fixed points when X^H is finite; None if positive-dimensional."""
    comps = fixed_components(G, elements, H)
    out: List[Tuple[Point, Point, str]] = []
    for c in comps:
        d = c.X_dim()
        if d < 0:
            continue
        if d > 0:
            return None
        p, q = c.base_point()  # type: ignore[misc]
        if c.on_Z():
            out.append((p, q, "w=0"))
        else:
            out.append((p, q, "w=+-sqrt(F)"))
    return out


def pt_str(p: Point) -> str:
    return "[" + " : ".join(fld_str(c) for c in p) + "]"


# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------


def find_lift(A: Mat, B: Mat, poly) -> Optional[Elt]:
    """Find mu with F(At, Bx) = mu^2 F, searching the K-rational candidates."""
    from fractions import Fraction
    sqrt2 = sub(z24(2), z24(22))
    sqrt3 = sub(mul(z24(4), fld(2)), ONE)
    units = [ONE, sqrt2, sqrt3, mul(sqrt2, sqrt3)]
    rats = sorted({Fraction(a, b) for a in (1, 2, 3, 4, 6, 9) for b in (1, 2, 3, 4, 6, 9)})
    for k in range(24):
        for u in units:
            for r in rats:
                mu = mul(mul(z24(k), u), fld(r))
                cand = canonical((A, B, mu))
                if substitution_check(cand, poly):
                    return cand
    return None


def main() -> None:
    failures: List[str] = []

    def check(label: str, cond: bool, extra: str = "") -> None:
        if not cond:
            failures.append(label)
        print(f"[{'PASS' if cond else 'FAIL'}] {label}{(' :: ' + extra) if extra else ''}")

    elements = build_G()
    G = FiniteGroup(elements)
    tau = G.index[TAU]
    full = frozenset(range(G.n))

    print("== 1. Global fixed locus ==")
    print(f"    X^G       : {fixed_report(G, elements, full)}")
    check("X^G is empty", fixed_dim(G, elements, full) < 0)

    Zdeck = fixed_components(G, elements, frozenset({G.e, tau}))
    print(f"    X^tau     : {fixed_report(G, elements, frozenset({G.e, tau}))}")
    check("X^tau is the branch surface Z (dimension 2)",
          fixed_dim(G, elements, frozenset({G.e, tau})) == 2)

    print("\n== 2. Condition (A) ==")
    abelians = G.abelian_subgroups()
    maximal = [A for A in abelians if not any(A < B for B in abelians)]
    print(f"    abelian subgroups: {len(abelians)}; maximal abelian: {len(maximal)}")
    bad = []
    for A in maximal:
        if fixed_dim(G, elements, A) < 0:
            bad.append(A)
    check("Condition (A) FAILS for the full group G of order 192", bool(bad),
          f"{len(bad)} maximal abelian subgroups with empty fixed locus")
    check("every witness is an elementary abelian (Z/2)^3 containing tau",
          bool(bad) and all(len(A) == 8 and tau in A and all(G.order(a) <= 2 for a in A)
                            for A in bad))
    for A in bad[:6]:
        print(f"      X^A empty for {G.structure_name(A)} (order {len(A)}), "
              f"contains tau: {tau in A}")
    sizes: Dict[int, int] = {}
    for A in maximal:
        sizes[len(A)] = sizes.get(len(A), 0) + 1
    print(f"    maximal abelian orders: {dict(sorted(sizes.items()))}")

    print("\n== 3. Element conjugacy classes and their fixed loci ==")
    classes = G.conjugacy_classes()
    classes.sort(key=lambda c: (G.order(min(c)), len(c)))
    print(f"    {'ord':>3} {'|class|':>7}  {'in <tau>-part':>13}  fixed locus X^g")
    for cls in classes:
        g = min(cls)
        rep = frozenset({G.e, g})
        rep = G.sub_closure([g])
        desc = fixed_report(G, elements, rep)
        print(f"    {G.order(g):>3} {len(cls):>7}  {'yes' if tau in rep else 'no':>13}  {desc}")

    print("\n== 4. Involution classes, centralizers, and the centralizer test ==")
    invol = [min(c) for c in G.conjugacy_classes() if G.order(min(c)) == 2]
    print(f"    {'class':>5} {'|class|':>7} {'|C_G(s)|':>9}  X^s -> X^{{C_G(s)}}")
    for s in invol:
        C = G.centralizer_elt(s)
        cls = frozenset(G.conj(h, s) for h in range(G.n))
        d_s = fixed_report(G, elements, G.sub_closure([s]))
        d_c = fixed_report(G, elements, C)
        tag = "tau" if s == tau else f"s{s}"
        print(f"    {tag:>5} {len(cls):>7} {len(C):>9}  {d_s}   ->   {d_c}")

    print("\n== 5. Subgroups containing tau: the deeper strata (X^H = Z^Hbar) ==")
    subs = G.all_subgroups()
    with_tau = [H for H in subs if tau in H]
    reps = G.conjugacy_reps(with_tau)
    print(f"    subgroups of G: {len(subs)}; containing tau: {len(with_tau)}; "
          f"up to conjugacy: {len(reps)}")
    print(f"    {'|H|':>4} {'|Hbar|':>6} {'ab':>3}  dim  X^H = Z^Hbar")
    for H in sorted(reps, key=len):
        d = fixed_dim(G, elements, H)
        print(f"    {len(H):>4} {len(H)//2:>6} {'y' if G.is_abelian_sub(H) else 'n':>3}"
              f"  {d:>3}  {fixed_report(G, elements, H)}")

    print("\n== 6. Subgroup audit: Condition (A) and empty fixed locus ==")
    minbad = [A for A in abelians if fixed_dim(G, elements, A) < 0
              and not any(B < A and fixed_dim(G, elements, B) < 0 for B in abelians)]
    print(f"    minimal abelian subgroups with empty fixed locus: {len(minbad)} "
          f"(orders {sorted(len(A) for A in minbad)})")
    orb0 = {frozenset(G.conj(g, h) for h in minbad[0]) for g in range(G.n)}
    check("they form a single conjugacy class of (Z/2)^3 subgroups containing tau",
          len(orb0) == len(minbad) and set(map(frozenset, minbad)) == orb0
          and all(G.order(a) <= 2 for a in minbad[0]) and tau in minbad[0])

    def condA(H: FrozenSet[int]) -> bool:
        return not any(A <= H for A in minbad)

    allreps = G.conjugacy_reps(subs)
    good = [(H, fixed_dim(G, elements, H)) for H in allreps
            if condA(H) and fixed_dim(G, elements, H) < 0]
    print(f"    subgroup classes: {len(allreps)}; with Condition (A) and empty fixed "
          f"locus: {len(good)}")

    def contained_up_to_conj(H, K):
        return any(frozenset(G.conj(g, h) for h in H) <= K for g in range(G.n))

    maxgood = [H for H, _ in good
               if not any(len(K) > len(H) and contained_up_to_conj(H, K)
                          for K, _ in good)]
    print(f"    {'|H|':>4} {'tau':>4} {'|Z(H)|':>7}  order statistics")
    for H in sorted(maxgood, key=lambda h: -len(h)):
        cnt: Dict[int, int] = {}
        for h in H:
            cnt[G.order(h)] = cnt.get(G.order(h), 0) + 1
        zc = len(G.centralizer_set(H) & H)
        print(f"    {len(H):>4} {'yes' if tau in H else 'no':>4} {zc:>7}  "
              f"{dict(sorted(cnt.items()))}")
    lab = [H for H in maxgood if len(H) == 96 and tau in H]
    check("the maximal Condition-(A) subgroup with empty fixed locus has order 96, "
          "contains tau, and has Z(H) = <tau>",
          len(lab) == 1 and len(G.centralizer_set(lab[0]) & lab[0]) == 2)
    if lab:
        H = lab[0]
        print(f"    frozen laboratory H: |H| = 96, index 2 in G, Z(H) = <tau>, "
              f"X^H = {fixed_report(G, elements, H)}, X^tau = Z (Fermat dP2)")

    print("\n== 7. Condition (A) for the residual group Hbar acting on the surface Z ==")
    print("    Z^Abar = X^{A'} where A' is the preimage of Abar in H (A' contains tau).")

    def abelian_quotient(A: FrozenSet[int]) -> bool:
        return all(G.table[a][b] == G.table[b][a]
                   or G.table[a][b] == G.table[tau][G.table[b][a]]
                   for a in A for b in A)

    if lab:
        Hlab = lab[0]
        badbar = [A for A in subs if A <= Hlab and tau in A and abelian_quotient(A)
                  and fixed_dim(G, elements, A) < 0]
        minbar = [A for A in badbar if not any(B < A for B in badbar)]
        check("Condition (A) FAILS for the Hbar-action on Z", bool(badbar),
              f"{len(badbar)} abelian subgroups Abar of Hbar with Z^Abar empty")
        for A in minbar:
            cnt2: Dict[int, int] = {}
            for a in A:
                cnt2[G.order(a)] = cnt2.get(G.order(a), 0) + 1
            comm = G.sub_closure([G.table[G.table[G.table[a][b]][G.inv[a]]][G.inv[b]]
                                  for a in A for b in A])
            print(f"      witness: |A'| = {len(A)}, |Abar| = {len(A)//2}, "
                  f"Abar abelian, A' {'abelian' if G.is_abelian_sub(A) else 'nonabelian'}, "
                  f"orders {dict(sorted(cnt2.items()))}, [A',A'] = "
                  f"{'<tau>' if comm == frozenset({G.e, tau}) else 'order ' + str(len(comm))}")
            check("the witness A' is nonabelian with commutator subgroup exactly <tau>",
                  comm == frozenset({G.e, tau}) and not G.is_abelian_sub(A))
        print("    ==> Z is not weakly Hbar-versal: no Hbar-equivariant rational map")
        print("        P(W) --> Z exists for a faithful linear Hbar-representation W.")
        print("        (This does NOT close the H-linear-source case: the preimage A' is")
        print("         nonabelian, and tau lies in [A',A'], so a character of A' inside V")
        print("         must have tau acting trivially.  See the boxed gap.)")

    print("\n== 8. Contrast: Abe's order-12 example (non-Fermat discriminant) ==")
    y2, xz = pmul(y, y), pmul(x, z)
    z2, xy = pmul(z, z), pmul(x, y)
    yz = pmul(y, z)
    e1 = pscale(padd(y2, xz), I_UNIT)                    # Q1 = i(y^2 + xz)
    e2 = padd(pmul(x, x), yz)                            # Q2 = x^2 + yz
    e3 = pscale(padd(z2, xy), I_UNIT)                    # Q3 = i(z^2 + xy)
    F12 = make_F(e1, e2, e3)
    disc12 = psub(pmul(e2, e2), pmul(e1, e3))
    target = padd(padd(padd(pmul(pmul(x, x), pmul(x, x)),
                            pmul(x, padd(pmul(y2, y), pmul(z2, z)))),
                       pscale(pmul(pmul(x, x), yz), fld(3))),
                  pscale(pmul(y2, z2), fld(2)))
    check("discriminant is x^4 + x(y^3+z^3) + 3 x^2 y z + 2 y^2 z^2 (alpha=3, beta=2)",
          peq(disc12, target))
    zeta3 = z24(8)
    zeta3sq = mul(zeta3, zeta3)
    # SL-normalized generators of Abe's S3 (det A = det B = 1)
    gens12 = [
        (mat([[zeta3sq, ZERO], [ZERO, zeta3]]),
         mat([[ONE, ZERO, ZERO], [ZERO, zeta3, ZERO], [ZERO, ZERO, zeta3sq]])),
        (mat([[ZERO, I_UNIT], [I_UNIT, ZERO]]),
         mat([[neg(ONE), ZERO, ZERO], [ZERO, ZERO, neg(ONE)], [ZERO, neg(ONE), ZERO]])),
    ]
    fixed12 = [find_lift(A, B, F12) for A, B in gens12]
    check("both generators of Abe's S3 are in SL2 x SL3 and lift to X_12",
          all(f is not None for f in fixed12))
    if all(f is not None for f in fixed12):
        el12 = closure(fixed12 + [TAU])
        G12 = FiniteGroup(el12)
        check("|Aut(X_12)| = 12", len(el12) == 12, f"got {len(el12)}")
        t12 = G12.index[TAU]
        check("tau is central in the order-12 group", t12 in G12.center())
        ab12 = G12.abelian_subgroups()
        bad12 = [A for A in ab12 if fixed_dim(G12, el12, A, F12) < 0]
        check("Condition (A) HOLDS for Abe's order-12 action", not bad12,
              f"{len(bad12)} abelian subgroups with empty fixed locus")
        full12 = frozenset(range(G12.n))
        print(f"    X_12^G  : {fixed_report(G12, el12, full12, F12)}")
        print(f"    X_12^tau: {fixed_report(G12, el12, frozenset({G12.e, t12}), F12)}")
        print(f"    Condition (A) holds and X_12^G is "
              f"{'empty' if fixed_dim(G12, el12, full12, F12) < 0 else 'nonempty'}: "
              f"a second, much smaller network laboratory.")

    if failures:
        print("\nFAILURES: " + "; ".join(failures))
        raise SystemExit(1)
    print("\nSTRATA COMPUTATION COMPLETE")


if __name__ == "__main__":
    main()
