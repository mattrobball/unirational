"""Klein cubic in campaign coordinates: gradient, Hessian, polar, jets of F.

F = sum_{k in Z/5} y_k^2 y_{k+1}.  All identities are over Z (then reduce).
No cell, no group, no sampling.  This is the [T1] core of C6.
"""
from __future__ import annotations


def F(y):
    return sum(y[k] * y[k] * y[(k + 1) % 5] for k in range(5))


def gradF(y):
    """(∂F/∂y_k) = 2 y_k y_{k+1} + y_{k-1}^2."""
    return [2 * y[k] * y[(k + 1) % 5] + y[(k - 1) % 5] ** 2 for k in range(5)]


def hessF(y):
    """Symmetric Hessian.  Nonzero entries: H_{k,k}=2 y_{k+1}, H_{k,k+1}=2 y_k."""
    H = [[0] * 5 for _ in range(5)]
    for k in range(5):
        H[k][k] = 2 * y[(k + 1) % 5]
        H[k][(k + 1) % 5] = 2 * y[k]
        H[(k + 1) % 5][k] = 2 * y[k]
    return H


def dot(u, v):
    return sum(u[k] * v[k] for k in range(5))


def hess_quad(y, s):
    """s^T H_F(y) s = 2 sum_k y_{k+1} s_k^2 + 4 sum_k y_k s_k s_{k+1}."""
    return sum(
        2 * y[(k + 1) % 5] * s[k] * s[k]
        + 4 * y[k] * s[k] * s[(k + 1) % 5]
        for k in range(5)
    )


def hess_bilin(y, u, v):
    """u^T H_F(y) v = 6 Phi(y,u,v)."""
    acc = 0
    H = hessF(y)
    for i in range(5):
        for j in range(5):
            acc += u[i] * H[i][j] * v[j]
    return acc


def Phi(u, v, w):
    """Symmetric trilinear polarisation with Phi(x,x,x) = F(x).

    3 Phi(u,v,w) = (1) sum_k (
        u_k v_k w_{k+1} + u_k w_k v_{k+1} + v_k w_k u_{k+1}
    )
    so Phi is a third of that sum.  Callers that want to stay in Z use
    `Phi3 = 3 Phi` below.
    """
    s = 0
    for k in range(5):
        kp = (k + 1) % 5
        s += u[k] * v[k] * w[kp] + u[k] * w[k] * v[kp] + v[k] * w[k] * u[kp]
    if s % 3:
        raise ValueError("3 Phi not divisible by 3: %s" % s)
    return s // 3


def Phi3(u, v, w):
    """3 Phi(u,v,w), always an integer."""
    s = 0
    for k in range(5):
        kp = (k + 1) % 5
        s += u[k] * v[k] * w[kp] + u[k] * w[k] * v[kp] + v[k] * w[k] * u[kp]
    return s


def add(*vecs):
    return [sum(v[k] for v in vecs) for k in range(5)]


def scale(lam, v):
    return [lam * v[k] for k in range(5)]


def first_order(T, S):
    """(25.1): sum_i (∂F/∂y_i)(T) S_i  =  3 Phi(T,T,S)  =  ∇F(T)·S."""
    return dot(gradF(T), S)


def second_order(T, S, R):
    """(25.2): sum_{i,j} ∂²F/∂y_i∂y_j (T) S_i S_j  +  2 sum_i (∂F/∂y_i)(T) R_i.

    Equals 6 Phi(T,S,S) + 6 Phi(T,T,R).
    """
    return hess_quad(T, S) + 2 * dot(gradF(T), R)


def expand_deformation(T, S, R, lam):
    """F(T + lam S + lam^2 R) as a python int."""
    return F(add(T, scale(lam, S), scale(lam * lam, R)))


def collect_lambda_coeffs(T, S, R):
    """Exact coefficients of F(T + λS + λ²R) in λ, by finite differences at
    six integer values (degree ≤ 6 because F is cubic and the argument is
    quadratic in λ).  Returns dict keyed by degree 0..6.
    """
    # F(T + λS + λ²R) is a polynomial in λ of degree 6.  Sample λ = 0..6
    # and invert the Vandermonde over Z (it is unit-triangular after
    # binomial transform).  Use successive differences for monomials.
    vals = [expand_deformation(T, S, R, lam) for lam in range(7)]
    # Newton divided differences at 0,1,...,6 then convert to monomials.
    newton = list(vals)
    for i in range(1, 7):
        for j in range(6, i - 1, -1):
            newton[j] = newton[j] - newton[j - 1]
    # newton[k] = k! [Δ^k] = k! * (coeff in Newton basis)
    # convert Newton basis nCk * c_k to monomials
    # p(λ) = sum_k binom(λ,k) * newton[k]
    # binom(λ,k) = λ(λ-1)...(λ-k+1)/k!
    # so the integer polynomial is sum_k newton[k] * λ(λ-1)...(λ-k+1) / k!
    # and newton[k] is already k! times the divided difference, so
    # p = sum_k newton[k] * (λ(λ-1)...(λ-k+1))/k!
    # Here newton[k] after the loop IS the forward difference Δ^k p(0),
    # which equals k! * (Newton coeff), and p(λ) = sum Δ^k p(0) * C(λ,k).
    fact = [1]
    for i in range(1, 7):
        fact.append(fact[-1] * i)
    # Convert sum_k Δ^k * C(λ,k) to monomials by expanding falling factorials.
    mono = [0] * 7
    for k in range(7):
        # C(λ,k) = (1/k!) * sum_{j=0}^k s(k,j) λ^j  (signed Stirling 1st kind)
        # We expand falling factorial (λ)_k = λ(λ-1)...(λ-k+1) recursively.
        # falling coeffs of (λ)_k:
        fall = [0] * (k + 1)
        fall[0] = 1
        for m in range(k):
            nxt = [0] * (k + 1)
            for j in range(m + 1):
                nxt[j + 1] += fall[j]
                nxt[j] -= m * fall[j]
            fall = nxt
        for j in range(k + 1):
            term = newton[k] * fall[j]
            if term % fact[k]:
                raise ValueError("falling factorial not divisible")
            mono[j] += term // fact[k]
    return mono


def predicted_lambda_coeffs(T, S, R):
    """Taylor prediction from the polar calculus (char 0).

    F(T+λS+λ²R) = F(T)
        + λ     ∇F(T)·S
        + λ²    [ ∇F(T)·R + (1/2) S^T H(T) S ]
        + λ³    [ (1/2) (2 S^T H(T) R)  wait — expand fully via polarisation ]

    Full polarisation (F cubic):
      F(a+b+c) = F(a)+F(b)+F(c)
               + 3Phi(a,a,b)+3Phi(a,a,c)+3Phi(b,b,a)+3Phi(b,b,c)
               + 3Phi(c,c,a)+3Phi(c,c,b)
               + 6Phi(a,b,c)
    with a=T, b=λS, c=λ²R.
    """
    a, b1, c1 = T, S, R  # b = λ S, c = λ² R; collect afterwards
    c0 = F(a)
    # λ^1: 3 Phi(a,a,S)
    c1c = Phi3(a, a, b1)
    # λ^2: 3 Phi(a,a,R) + 3 Phi(S,S,a)
    c2 = Phi3(a, a, c1) + Phi3(b1, b1, a)
    # λ^3: 3 Phi(S,S,S) + 6 Phi(a,S,R)   [F(S) = Phi(S,S,S); 6Phi(a,S,R)]
    # 3 Phi(b,b,c) contributes 3 Phi(S,S,R) λ^4 — not here
    # 3 Phi(c,c,a) is λ^4; 3 Phi(c,c,b) is λ^5; F(c) is λ^6
    # 6 Phi(a,b,c) = 6 Phi(T,S,R) λ^3
    # 3 Phi(b,b,a) already in λ^2; 3 Phi(b,b,b)=3 F(S) wait F(b)=λ³ F(S)
    c3 = F(b1) + 2 * Phi3(a, b1, c1)  # F(S) + 6 Phi(T,S,R)  since 2*Phi3=6 Phi
    # λ^4: 3 Phi(S,S,R) + 3 Phi(R,R,T)
    c4 = Phi3(b1, b1, c1) + Phi3(c1, c1, a)
    # λ^5: 3 Phi(R,R,S)
    c5 = Phi3(c1, c1, b1)
    # λ^6: F(R)
    c6 = F(c1)
    return [c0, c1c, c2, c3, c4, c5, c6]


def check_identities(vectors):
    """Return a list of (name, ok, detail) on a list of 5-tuples."""
    out = []

    def ck(name, cond, detail=""):
        out.append((name, bool(cond), detail))

    # origin
    z = [0, 0, 0, 0, 0]
    ck("F(0)=0", F(z) == 0)
    ck("gradF(0)=0", gradF(z) == [0, 0, 0, 0, 0])
    ck("hessF(0)=0", all(hessF(z)[i][j] == 0 for i in range(5) for j in range(5)))
    ck("first_order(0,S)=0 all S", all(first_order(z, s) == 0 for s in vectors))
    ck("second_order(0,S,R)=0 all",
       all(second_order(z, s, r) == 0 for s in vectors for r in vectors))

    for i, y in enumerate(vectors):
        g = gradF(y)
        ck("euler %d" % i, dot(g, y) == 3 * F(y),
           "grad·y=%s 3F=%s" % (dot(g, y), 3 * F(y)))
        ck("grad=3Phi(y,y,·) %d" % i,
           all(g[k] == Phi3(y, y, e(k)) for k in range(5)))
        ck("hess=6Phi(y,·,·) %d" % i,
           all(hess_bilin(y, e(a), e(b)) == 2 * Phi3(y, e(a), e(b))
               for a in range(5) for b in range(5)))
        # wait: u^T H v should equal 6 Phi(y,u,v) = 2 * Phi3(y,u,v). Yes.

    # first/second order match polarisation
    for T in vectors[:4]:
        for S in vectors[:4]:
            ck("25.1=3Phi", first_order(T, S) == Phi3(T, T, S))
            for R in vectors[:3]:
                lhs = second_order(T, S, R)
                rhs = 2 * Phi3(T, S, S) + 2 * Phi3(T, T, R)
                # hess_quad = 6 Phi(T,S,S) = 2 Phi3(T,S,S)
                # 2 grad·R = 2 * 3 Phi(T,T,R) = 2 Phi3(T,T,R)
                ck("25.2=polar", lhs == rhs,
                   "lhs=%s rhs=%s" % (lhs, rhs))

    # full λ-expansion vs polar prediction
    for T, S, R in zip(vectors[:3], vectors[1:4], vectors[2:5]):
        got = collect_lambda_coeffs(T, S, R)
        pred = predicted_lambda_coeffs(T, S, R)
        ck("lambda-expansion", got == pred, "got=%s pred=%s" % (got, pred))
        # order-0,1,2 named
        ck("lambda0=F(T)", got[0] == F(T))
        ck("lambda1=25.1", got[1] == first_order(T, S))
        # λ² coefficient is ∇F·R + (1/2) S^T H S = second_order/2
        # second_order = hess_quad + 2 grad·R = 2*( (1/2)hess + grad·R )
        half = second_order(T, S, R)
        ck("lambda2=25.2/2", got[2] * 2 == half,
           "2*c2=%s 25.2=%s" % (got[2] * 2, half))

    # third order at the origin is F(S) — the landing equation itself
    for S in vectors:
        got = collect_lambda_coeffs(z, S, z)
        ck("origin-lambda=F(S) λ^3",
           got == [0, 0, 0, F(S), 0, 0, 0],
           str(got))
    return out


def e(k):
    v = [0] * 5
    v[k] = 1
    return v


def default_vectors():
    return [
        [0, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0],
        [0, 0, 1, 0, 0],
        [1, 1, 1, 1, 1],
        [1, -2, 3, -4, 5],
        [2, 3, 5, 7, 11],
        [1, 0, 1, 0, 1],
        [0, 1, 0, 1, 0],
        [4, -1, 0, 2, -3],
    ]


def run_checks():
    recs = check_identities(default_vectors())
    fails = [n for n, ok, _ in recs if not ok]
    return {
        "n_checks": len(recs),
        "n_fail": len(fails),
        "fails": fails,
        "all_ok": not fails,
        "formulas": {
            "F": "sum_{k in Z/5} y_k^2 y_{k+1}",
            "dF/dy_k": "2 y_k y_{k+1} + y_{k-1}^2",
            "H_kk": "2 y_{k+1}",
            "H_k,k+1": "2 y_k",
            "first_order": "sum_k (2 T_k T_{k+1} + T_{k-1}^2) S_k",
            "second_order": (
                "sum_k (2 T_{k+1} S_k^2 + 4 T_k S_k S_{k+1}) "
                "+ 2 sum_k (2 T_k T_{k+1} + T_{k-1}^2) R_k"
            ),
        },
    }


if __name__ == "__main__":
    rec = run_checks()
    print("polar checks: %d  fails: %d" % (rec["n_checks"], rec["n_fail"]))
    if rec["fails"]:
        print("FAILS", rec["fails"])
        raise SystemExit(1)
    print("POLAR_OK")
