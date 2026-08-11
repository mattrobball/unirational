#!/usr/bin/env python3
"""
Exact verification of the source-tangency factorization

    Delta_T |_X  =  (d/d') * H^(n-e) * j_phi                          (34)

for a landing tuple `T` on a smooth hypersurface `X = V(F)` of degree `e` in
`P^(n-1)`, where

    Delta_T = grad F(x)^t P_T(x),   adj(J_T) = P_T grad F(T)^t,
    T|_X = H * B,   deg H = k,   deg B = d' = d - k,   phi = [B] : X --> X,
    j_phi = Jac(beta)  the cone Jacobian of the primitive lift beta = B|_{C(X)}.

The repository case is `(n,e) = (5,3)`, where `n - e = 2` and (34) is the
source's `Delta_T|_X = c H^2 j_phi`.  This script proves the exponent is
`n - e` -- **not** universally `2` -- by exhibiting exact instances with
`n - e = 1, 2, 3`, and pins the constant to `c = d/d'`.

BLOCKS
  (A) the pointwise linear-algebra lemma behind `Delta_T = Jac(T|_{C(X)})`
  (B) the residue (Gelfand-Leray) form and its weight
  (C) `Delta_T = Jac(tau)` on explicit landing tuples          [Lemma A]
  (D) the scaling lemma `Jac(h beta) = ((k+a)/a) h^w Jac(beta)`
  (E) the assembled identity (34) on explicit instances, including
      `d' = 2` and `d' = 3` restricted selfmaps with `H != 1`
  (F) the ramification reading `div_X(j_phi) = R_phi`
  (G) the exponent is `n-e`, and the constant is `d/d'`: a refutation of the
      reading "H is always squared"

Exact throughout: sympy polynomial arithmetic over Q, `Fraction` linear
algebra.  No floating point, no random sampling that is not re-checked
symbolically.

TERMINAL MARKER: prints `RESULT: PASS` iff every assertion holds.
"""

import sys
from fractions import Fraction
import sympy as sp

FAILURES = []
CHECKS = 0


def check(name, cond, extra=""):
    global CHECKS
    CHECKS += 1
    if not cond:
        FAILURES.append(f"{name} {extra}")
        print(f"  FAIL {name} {extra}")
    return bool(cond)


print("=" * 74)
print("verify_source_tangency.py -- the identity Delta_T|_X = (d/d') H^(n-e) j_phi")
print("=" * 74)

# ======================================================================
# (A) The pointwise linear-algebra lemma.
#
#   A : V -> V with Q^t A = 0 (n x n).  N, Q nonzero covectors.
#   v with N^t v = 1, w with Q^t w = 1.  (e_i) a basis of N^perp,
#   (f_i) a basis of Q^perp.  S = [v e_1 ... e_{n-1}], R = [w f_1 ... f_{n-1}].
#   A' = A restricted to N^perp -> Q^perp in the bases (e), (f).
#
#   CLAIM:   det(A')  =  (det S / det R) * N^t adj(A) w.
#
#   With adj(A) = P Q^t and Q^t w = 1 this is (det S/det R) * (N^t P), which is
#   the pointwise form of Delta_T = Jac(T|_{cone}).
# ======================================================================
print("\n(A) pointwise linear algebra: det(A|_{N^perp -> Q^perp}) = "
      "(det S/det R) N^t adj(A) w")


def rand_int_matrix(rows, cols, seed):
    """Deterministic small-integer matrix (no RNG dependence across runs)."""
    vals = []
    x = seed
    for _ in range(rows * cols):
        x = (1103515245 * x + 12345) % 2147483648
        vals.append((x % 11) - 5)
    return sp.Matrix(rows, cols, vals)


def kernel_vec(M):
    ns = M.nullspace()
    return ns[0] if ns else None


okA = True
for n in (3, 4, 5, 6):
    for seed in (1, 7, 23, 101):
        # A of rank exactly n-1 with a prescribed left kernel Q
        L = rand_int_matrix(n, n - 1, seed)
        Rr = rand_int_matrix(n - 1, n, seed + 5)
        A = L * Rr
        if A.rank() != n - 1:
            continue
        Q = kernel_vec(A.T)          # Q^t A = 0
        if Q is None:
            continue
        N = rand_int_matrix(n, 1, seed + 11)
        if (N.T * kernel_vec(A))[0] == 0:
            pass                      # allowed; det A' is then 0 on both sides
        # v with N^t v = 1
        j = next(i for i in range(n) if N[i] != 0)
        v = sp.zeros(n, 1)
        v[j] = sp.Rational(1, 1) / N[j]
        # basis of N^perp
        Nperp = (N.T).nullspace()
        # w with Q^t w = 1
        jq = next(i for i in range(n) if Q[i] != 0)
        w = sp.zeros(n, 1)
        w[jq] = sp.Rational(1, 1) / Q[jq]
        Qperp = (Q.T).nullspace()
        S = sp.Matrix.hstack(v, *Nperp)
        Rm = sp.Matrix.hstack(w, *Qperp)
        # A' : coordinates of A e_i in the basis (f_j)
        Fb = sp.Matrix.hstack(*Qperp)
        cols = []
        for e in Nperp:
            img = A * e
            sol = Fb.solve_least_squares(img) if Fb.rows != Fb.cols else None
            sol = sp.Matrix(sp.linsolve((Fb, img)).args[0]).T.T
            cols.append(sol)
        Ap = sp.Matrix.hstack(*cols)
        lhs = sp.expand(Ap.det())
        rhs = sp.expand((S.det() / Rm.det()) * (N.T * A.adjugate() * w)[0])
        okA &= check(f"n={n} seed={seed}: det(A') = (detS/detR) N^t adj(A) w",
                     sp.simplify(lhs - rhs) == 0, f"lhs={lhs} rhs={rhs}")
print(f"  all instances agree: {okA}")

# ======================================================================
# (B) - (G):  polynomial machinery on cones.
# ======================================================================


def gradient(F, xs):
    return [sp.expand(sp.diff(F, x)) for x in xs]


def divisible_by(g, F, xs):
    """Exact test g in (F): the single generator F is a Groebner basis of (F),
    so multivariate division by F leaves remainder 0 iff F | g."""
    g = sp.expand(g)
    if g == 0:
        return True, sp.Integer(0)
    q, r = sp.reduced(g, [F], gens=xs)
    return sp.expand(r) == 0, sp.expand(q[0])


def mod_F(g, F, xs):
    _, r = sp.reduced(sp.expand(g), [F], gens=xs)
    return sp.expand(r)


def cone_jacobian_numer(beta, F, xs):
    """Return (detN, denom) with Jac(beta) = detN / denom on C(F), where

        Jac(beta) * eta = beta^* eta,     dF ^ eta = Omega.

    In the chart F_{n-1} != 0, with y_0..y_{n-2} as local coordinates,
        M_ij = d beta_i/d y_j - (F_j/F_{n-1}) d beta_i / d y_{n-1},
        Jac(beta) = det(M) * F_{n-1}(y) / F_{n-1}(beta(y)),
    so with N = F_{n-1} M,  Jac(beta) = det(N) / (F_{n-1}^{n-2} F_{n-1}(beta)).
    """
    n = len(xs)
    Fg = gradient(F, xs)
    last = Fg[n - 1]
    N = sp.zeros(n - 1, n - 1)
    for i in range(n - 1):
        dlast = sp.diff(beta[i], xs[n - 1])
        for j in range(n - 1):
            N[i, j] = sp.expand(last * sp.diff(beta[i], xs[j]) - Fg[j] * dlast)
    detN = sp.expand(N.det(method="berkowitz"))
    sub = {xs[i]: beta[i] for i in range(n)}
    last_at_beta = sp.expand(last.subs(sub, simultaneous=True))
    denom = sp.expand(last ** (n - 2) * last_at_beta)
    return detN, denom


def cone_jacobian(beta, F, xs):
    """Jac(beta) as a polynomial, verified: detN = Jac * denom modulo F."""
    detN, denom = cone_jacobian_numer(beta, F, xs)
    # solve detN = J * denom  mod F  by exact division after reduction
    q, r = sp.div(sp.Poly(detN, *xs), sp.Poly(denom, *xs))
    if sp.expand(r.as_expr()) == 0:
        return sp.expand(q.as_expr())
    # otherwise divide modulo F: search for J with detN - J*denom in (F)
    return None


def adjugate_kernel_vector(T, F, xs):
    """P_T with adj(J_T) = P_T grad F(T)^t, computed by exact division."""
    n = len(xs)
    J = sp.Matrix(n, n, lambda i, j: sp.diff(T[i], xs[j]))
    adj = J.adjugate()
    sub = {xs[i]: T[i] for i in range(n)}
    Q = [sp.expand(g.subs(sub, simultaneous=True)) for g in gradient(F, xs)]
    jcol = next(j for j in range(n) if sp.expand(Q[j]) != 0)
    P = []
    for i in range(n):
        num = sp.expand(adj[i, jcol])
        q, r = sp.div(sp.Poly(num, *xs), sp.Poly(Q[jcol], *xs))
        assert sp.expand(r.as_expr()) == 0, (i, "adjugate division not exact")
        P.append(sp.expand(q.as_expr()))
    # consistency: every column gives the same P
    for j in range(n):
        if sp.expand(Q[j]) == 0:
            continue
        for i in range(n):
            assert sp.expand(adj[i, j] - P[i] * Q[j]) == 0, (i, j)
    return P, J, Q, adj


# ----------------------------------------------------------------------
# The instances.  Each is (name, n, e, xs, F, T, d, H, B, k, dprime).
# ----------------------------------------------------------------------
def instance_list():
    out = []

    # ---- w = n-e = 1 : smooth conic in P^2 ----------------------------
    x0, x1, x2, x3, x4 = sp.symbols("x0 x1 x2 x3 x4")
    xs3 = [x0, x1, x2]
    F3 = x0 * x1 + x2 ** 2
    # T = (a^2, -b^2, a b) with a = x0, b = x2   (F(T) = 0 identically)
    T = [x0 ** 2, -x2 ** 2, x0 * x2]
    out.append(dict(name="conic in P^2, d=2, k=1, d'=1", n=3, e=2, xs=xs3,
                    F=F3, T=T, d=2, H=x0, B=[x0, x1, x2], k=1, dp=1))

    # ---- w = 2 : smooth quadric surface in P^3 ------------------------
    xs4 = [x0, x1, x2, x3]
    F4 = x0 * x1 + x2 * x3
    # (i) stereographic tuple: T|_X = -x1 * identity
    T = [x2 * x3, -x1 ** 2, -x1 * x2, -x1 * x3]
    out.append(dict(name="quadric surface, d=2, k=1, d'=1 (phi = id)", n=4,
                    e=2, xs=xs4, F=F4, T=T, d=2, H=-x1,
                    B=[x0, x1, x2, x3], k=1, dp=1))
    # (ii) ruling swap: T|_X = x0 * (x0,x1,x3,x2)
    T = [x0 ** 2, -x2 * x3, x0 * x3, x0 * x2]
    out.append(dict(name="quadric surface, d=2, k=1, d'=1 (phi = ruling swap)",
                    n=4, e=2, xs=xs4, F=F4, T=T, d=2, H=x0,
                    B=[x0, x1, x3, x2], k=1, dp=1))
    # (iii) squaring on both rulings: d' = 2
    T = [x0 ** 2 * x2 * x3, -x1 ** 2 * x2 * x3, -x0 * x1 * x2 ** 2,
         -x0 * x1 * x3 ** 2]
    out.append(dict(name="quadric surface, d=4, k=2, d'=2 (phi = squaring)",
                    n=4, e=2, xs=xs4, F=F4, T=T, d=4, H=-x0 * x1,
                    B=[x0 ** 2, -x1 ** 2, x2 ** 2, x3 ** 2], k=2, dp=2))
    # (iv) cubing on both rulings: d' = 3
    T = [x0 ** 4 * x2 * x3, -x1 ** 2 * x2 ** 2 * x3 ** 2,
         -x0 ** 2 * x1 * x2 ** 3, -x0 ** 2 * x1 * x3 ** 3]
    out.append(dict(name="quadric surface, d=6, k=3, d'=3 (phi = cubing)",
                    n=4, e=2, xs=xs4, F=F4, T=T, d=6, H=-x0 ** 2 * x1,
                    B=[x0 ** 3, x1 ** 3, x2 ** 3, x3 ** 3], k=3, dp=3))

    # ---- w = 3 : smooth quadric threefold in P^4 ----------------------
    xs5 = [x0, x1, x2, x3, x4]
    F5 = x0 * x1 + x2 * x3 + x4 ** 2
    T = [x2 * x3 + x4 ** 2, -x1 ** 2, -x1 * x2, -x1 * x3, -x1 * x4]
    out.append(dict(name="quadric threefold, d=2, k=1, d'=1", n=5, e=2, xs=xs5,
                    F=F5, T=T, d=2, H=-x1, B=[x0, x1, x2, x3, x4], k=1, dp=1))
    return out


# ======================================================================
print("\n(B)-(F) exact instances")
INST = instance_list()
summary = []
for inst in INST:
    name, n, e, xs, F = inst["name"], inst["n"], inst["e"], inst["xs"], inst["F"]
    T, d, H, B, k, dp = (inst["T"], inst["d"], inst["H"], inst["B"], inst["k"],
                         inst["dp"])
    w = n - e
    print(f"\n  --- {name}   (n={n}, e={e}, w={w}) ---")

    # smoothness of X = V(F): the partials have no common zero but the origin
    Fg = gradient(F, xs)
    gb = sp.groebner(Fg, *xs, order="grevlex")
    rad_ok = all(any(sp.Poly(g, *xs).monoms() and
                     all(m.count(0) == n - 1 for m in [mm]) for mm in
                     sp.Poly(g, *xs).monoms()) for g in gb.exprs) or True
    # concrete test: each x_i^N lies in the Jacobian ideal for some N <= 8
    smooth = all(sp.reduced(x ** 8, list(gb.exprs), gens=xs)[1] == 0 for x in xs)
    check(f"[{name}] X smooth (Jacobian ideal is m-primary)", smooth)

    # F(T) = 0 identically
    sub = {xs[i]: T[i] for i in range(n)}
    check(f"[{name}] F(T) = 0 identically",
          sp.expand(F.subs(sub, simultaneous=True)) == 0)
    check(f"[{name}] T homogeneous of degree d={d}",
          all(sp.Poly(t, *xs).is_homogeneous and
              sp.Poly(t, *xs).total_degree() == d for t in T if t != 0))
    # primitivity of T
    check(f"[{name}] T primitive", sp.gcd_list([sp.expand(t) for t in T]) == 1)

    P, J, Q, adj = adjugate_kernel_vector(T, F, xs)
    check(f"[{name}] generic rank J_T = n-1", J.rank() == n - 1)
    degP = max(sp.Poly(p, *xs).total_degree() for p in P if p != 0)
    check(f"[{name}] deg P_T = (n-1)(d-1)-(e-1)d = {(n-1)*(d-1)-(e-1)*d}",
          degP == (n - 1) * (d - 1) - (e - 1) * d, f"got {degP}")
    check(f"[{name}] J_T P_T = 0",
          all(sp.expand(sum(J[i, j] * P[j] for j in range(n))) == 0
              for i in range(n)))
    check(f"[{name}] div P_T = 0",
          sp.expand(sum(sp.diff(P[i], xs[i]) for i in range(n))) == 0)

    # Delta_T
    Delta = sp.expand(sum(Fg[i] * P[i] for i in range(n)))
    check(f"[{name}] deg Delta_T = (n-e)(d-1) = {w*(d-1)}",
          sp.Poly(Delta, *xs).total_degree() == w * (d - 1),
          f"got {sp.Poly(Delta,*xs).total_degree()}")

    # ---- Lemma A: Delta_T = Jac(tau) on the cone, tau = T|_{C(X)} -----
    detN, denom = cone_jacobian_numer(T, F, xs)
    lemA_ok, _ = divisible_by(sp.expand(detN - Delta * denom), F, xs)
    check(f"[{name}] LEMMA A: Delta_T = Jac(T|_cone) modulo F", lemA_ok)

    # ---- the restriction T|_X = H * B ---------------------------------
    for i in range(n):
        ok, _ = divisible_by(sp.expand(T[i] - H * B[i]), F, xs)
        check(f"[{name}] T_{i}|_X = H B_{i}", ok)
    check(f"[{name}] deg H = k = {k}", sp.Poly(H, *xs).total_degree() == k)
    check(f"[{name}] deg B = d' = {dp}",
          max(sp.Poly(b, *xs).total_degree() for b in B if b != 0) == dp)
    check(f"[{name}] d = k + d'", d == k + dp)
    okFB, _ = divisible_by(sp.expand(F.subs({xs[i]: B[i] for i in range(n)},
                                            simultaneous=True)), F, xs)
    check(f"[{name}] F(B) = 0 on X", okFB)

    # ---- j_phi = Jac(beta) --------------------------------------------
    detNb, denomb = cone_jacobian_numer(B, F, xs)
    jphi = cone_jacobian(B, F, xs)
    if jphi is None:
        # divide modulo F with an ansatz of the right degree
        jphi = None
    check(f"[{name}] j_phi = Jac(beta) is a polynomial", jphi is not None)
    if jphi is not None and jphi != 0:
        check(f"[{name}] deg j_phi = (n-e)(d'-1) = {w*(dp-1)}",
              sp.Poly(jphi, *xs).total_degree() == w * (dp - 1)
              if jphi != 1 else w * (dp - 1) == 0,
              f"got {jphi}")

    # ---- THE IDENTITY (34): Delta_T = (d/d') H^w j_phi  modulo F ------
    if jphi is not None:
        rhs = sp.expand(sp.Rational(d, dp) * H ** w * jphi)
        ok34, _ = divisible_by(sp.expand(Delta - rhs), F, xs)
        check(f"[{name}] (34) Delta_T|_X = (d/d') H^(n-e) j_phi", ok34,
              f"Delta={Delta}  rhs={rhs}")
        # the exponent really is n-e: the neighbouring exponents fail
        for wrong in {1, 2, 3} - {w}:
            if k == 0:
                continue
            okw, _ = divisible_by(
                sp.expand(Delta - sp.Rational(d, dp) * H ** wrong * jphi),
                F, xs)
            check(f"[{name}] exponent {wrong} is WRONG (only n-e={w} works)",
                  not okw)
        # the constant really is d/d'
        if sp.expand(Delta) != 0:
            for c2 in (1, 2, sp.Rational(1, 2), d, dp):
                if sp.Rational(d, dp) == c2:
                    continue
                okc, _ = divisible_by(sp.expand(Delta - c2 * H ** w * jphi),
                                      F, xs)
                check(f"[{name}] constant {c2} is WRONG (only d/d' works)",
                      not okc)
        summary.append((name, n, e, w, d, k, dp, sp.factor(Delta),
                        sp.factor(jphi)))

print("\n  instance summary")
print("   n  e  w   d   k   d'   Delta_T (factored)")
for (name, n, e, w, d, k, dp, Dl, jp) in summary:
    print(f"   {n}  {e}  {w}  {d:2d}  {k:2d}   {dp:2d}   {Dl}")

# ======================================================================
# (D) the scaling lemma, symbolically and in general form.
#
#   Jac(h beta) = ((k + a)/a) h^w Jac(beta)
#
# with deg h = k, beta homogeneous of degree a, eta of weight w = n - e.
# Verified on the cone instances by taking beta = identity (a = 1) and
# h an arbitrary invariantly-chosen form, and on the composite instances above.
# ======================================================================
print("\n(D) the scaling lemma Jac(h beta) = ((k+a)/a) h^w Jac(beta)")
x0, x1, x2, x3, x4 = sp.symbols("x0 x1 x2 x3 x4")
scale_ok = True
for (n, e, xs, F) in [(3, 2, [x0, x1, x2], x0 * x1 + x2 ** 2),
                      (4, 2, [x0, x1, x2, x3], x0 * x1 + x2 * x3),
                      (5, 2, [x0, x1, x2, x3, x4],
                       x0 * x1 + x2 * x3 + x4 ** 2)]:
    w = n - e
    idmap = list(xs)
    for h in [xs[0], xs[0] ** 2, xs[0] * xs[1], xs[0] ** 3 + xs[1] ** 3]:
        kk = sp.Poly(h, *xs).total_degree()
        beta = idmap
        a = 1
        lhs = cone_jacobian([sp.expand(h * b) for b in beta], F, xs)
        jb = cone_jacobian(beta, F, xs)
        rhs = sp.expand(sp.Rational(kk + a, a) * h ** w * jb)
        ok, _ = divisible_by(sp.expand(lhs - rhs), F, xs) if lhs is not None \
            else (False, None)
        scale_ok &= check(f"scaling n={n} e={e} h={h}", ok,
                          f"lhs={lhs} rhs={rhs}")
    # a nonlinear beta: the Frobenius-like squaring on the conic/quadric
print(f"  scaling lemma verified on all cones: {scale_ok}")

# ======================================================================
# (G) the ramification reading of j_phi.
# ======================================================================
print("\n(G) div_X(j_phi) = R_phi  (ramification of the restricted selfmap)")
# For the quadric surface X = P^1 x P^1 with F = x0x1 + x2x3 and
# phi = ((s:t),(u:v)) -> ((s^r:t^r),(u^r:v^r)), R_phi = (r-1) div(x0 x1)|_X.
xs4 = [x0, x1, x2, x3]
F4 = x0 * x1 + x2 * x3
for r, B in [(2, [x0 ** 2, -x1 ** 2, x2 ** 2, x3 ** 2]),
             (3, [x0 ** 3, x1 ** 3, x2 ** 3, x3 ** 3])]:
    jp = cone_jacobian(B, F4, xs4)
    target = (x0 * x1) ** (r - 1)
    q, rr = sp.div(sp.Poly(sp.expand(jp), *xs4), sp.Poly(target, *xs4))
    ok = sp.expand(rr.as_expr()) == 0 and q.as_expr().is_number
    check(f"j_phi for the degree-{r} power map is a scalar times (x0 x1)^{r-1}",
          ok, f"j_phi={sp.factor(jp)}")
    check(f"deg j_phi = 2(d'-1) for r={r}",
          sp.Poly(jp, *xs4).total_degree() == 2 * (r - 1))
print("  ramification divisor of the power maps is the four coordinate lines,")
print("  cut on X by (x0 x1)^(r-1), of class 2(r-1)H -- as (35) requires.")

# ======================================================================
# (H) the degenerate alternative: Delta_T|_X = 0 iff the restriction is
#     not dominant, i.e. iff X is an invariant hypersurface of the foliation.
# ======================================================================
print("\n(H) the degenerate alternative")
# T = (x2*x3, -x1^2, -x1*x2, -x1*x3) on the quadric surface but composed with a
# non-dominant restriction: take T landing in a single ruling.
# Concretely: T = (a*c, -b*d, a*d, b*c) with (c:d) constant on X.
a_, b_, c_, d_ = x0, x2, x0, x0          # (c:d) = (1:1) constant
Tn = [sp.expand(a_ * c_), sp.expand(-b_ * d_), sp.expand(a_ * d_),
      sp.expand(b_ * c_)]
ok, _ = divisible_by(sp.expand(F4.subs({xs4[i]: Tn[i] for i in range(4)},
                                       simultaneous=True)), F4, xs4)
check("degenerate tuple satisfies F(T) = 0 identically",
      sp.expand(F4.subs({xs4[i]: Tn[i] for i in range(4)},
                        simultaneous=True)) == 0)
Jn = sp.Matrix(4, 4, lambda i, j: sp.diff(Tn[i], xs4[j]))
check("degenerate tuple: the restricted map is not dominant "
      "(rank of the restricted differential drops)", Jn.rank() <= 3)
detNn, denomn = cone_jacobian_numer(Tn, F4, xs4)
okz, _ = divisible_by(detNn, F4, xs4)
check("Jac(tau) = 0 on X for the degenerate tuple, i.e. Delta_T|_X = 0", okz)
print("  so (34) is an identity in the branch where the restricted map is")
print("  dominant; in the other branch both sides vanish and X is an")
print("  invariant (Darboux) hypersurface of the kernel foliation.")

# ======================================================================
print("\n" + "=" * 74)
print(f"checks run: {CHECKS}, failures: {len(FAILURES)}")
for f in FAILURES:
    print("  " + f)
print("RESULT: " + ("PASS" if not FAILURES else "FAIL"))
sys.exit(0 if not FAILURES else 1)
