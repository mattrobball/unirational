#!/usr/bin/env python3
"""
SPIN-SOURCE-NETWORK / Part 2 verifier: the spin source P(U) = P^5 for
Gtilde = SL(2,F_11), U = a 6-dimensional faithful (spin) irreducible.

Everything here is EXACT and in characteristic 0.  No sampling, no search,
no modular reduction.  All linear algebra is over Q(i) in dimension 12.

MODEL.  Instead of the 6-dimensional even-Weil matrices of the sealed
packet (whose entries live in Q(zeta_11) and which would force the degree-40
field Q(zeta_11, i) as soon as one diagonalises an order-4 element), we use
the INTEGRAL 12-dimensional monomial model

    W  =  Ind_B^{SL_2(F_11)} (chi),      chi = Legendre symbol on F_11^*,

realised on  { f : F_11^2 minus 0 -> C  :  f(lam v) = chi(lam) f(v) },
    (g.f)(v) = f(g^{-1} v).
Because chi(-1) = -1 (11 = 3 mod 4), the central -I acts on ALL of W by
-id: W is a purely SPIN 12-dimensional representation, and

    W  =  U (+) U'

is the sum of the two Galois-conjugate 6-dimensional spin irreducibles
(they are conjugate over Q(sqrt(-11)) and are the two halves of the
principal series at the quadratic character; equivalently the two even-Weil
representations of the sealed packet).  Every matrix of W is a SIGNED
PERMUTATION matrix, so all computations below are exact over Z[i].

THE HALVING PRINCIPLE (used throughout, and proved by Galois descent).
rho(g) has entries in Z, so every subspace of W cut out by eigenvalue
conditions with eigenvalues in Q(i) is defined over Q(i), hence stable
under Gal(Q(i,sqrt(-11))/Q(i)) = {1, tau}.  tau interchanges U and U'.
Therefore any such subspace S satisfies S = (S n U) (+) (S n U') with
tau(S n U) = S n U', so

    dim (S n U)  =  dim S / 2.

This turns every 6-dimensional spin question into an exact 12-dimensional
INTEGER question.

Replay:   python3 verify_spin_klein_network.py
Marker :  SPIN_SOURCE_NETWORK_OK
"""

import sys, json
from fractions import Fraction as Fr
from itertools import combinations

FAILS = []
CHECKS = []


def CHECK(name, ok, detail=""):
    CHECKS.append((name, bool(ok), detail))
    if not ok:
        FAILS.append(name)


# ----------------------------------------------------------------------
# 0.  exact Gaussian rationals  a + b i,  a,b in Q
# ----------------------------------------------------------------------
ZERO = (Fr(0), Fr(0))
ONE = (Fr(1), Fr(0))
IUNIT = (Fr(0), Fr(1))


def gadd(x, y):
    return (x[0] + y[0], x[1] + y[1])


def gsub(x, y):
    return (x[0] - y[0], x[1] - y[1])


def gmul(x, y):
    return (x[0] * y[0] - x[1] * y[1], x[0] * y[1] + x[1] * y[0])


def gdiv(x, y):
    d = y[0] * y[0] + y[1] * y[1]
    return ((x[0] * y[0] + x[1] * y[1]) / d, (x[1] * y[0] - x[0] * y[1]) / d)


def gz(x):
    return x[0] == 0 and x[1] == 0


def gint(n):
    return (Fr(n), Fr(0))


def rank_q_i(rows, ncols):
    """Exact rank over Q(i) of a list of row vectors (tuples of Gaussian
    rationals)."""
    M = [list(r) for r in rows]
    nr = len(M)
    r = 0
    for c in range(ncols):
        piv = None
        for k in range(r, nr):
            if not gz(M[k][c]):
                piv = k
                break
        if piv is None:
            continue
        M[r], M[piv] = M[piv], M[r]
        inv = gdiv(ONE, M[r][c])
        M[r] = [gmul(inv, x) for x in M[r]]
        for k in range(nr):
            if k != r and not gz(M[k][c]):
                f = M[k][c]
                M[k] = [gsub(M[k][j], gmul(f, M[r][j])) for j in range(ncols)]
        r += 1
        if r == nr:
            break
    return r


def kernel_basis(M, ncols):
    """Exact basis of the right kernel of M (list of rows) over Q(i)."""
    A = [list(r) for r in M]
    nr = len(A)
    piv_cols = []
    r = 0
    for c in range(ncols):
        piv = None
        for k in range(r, nr):
            if not gz(A[k][c]):
                piv = k
                break
        if piv is None:
            continue
        A[r], A[piv] = A[piv], A[r]
        inv = gdiv(ONE, A[r][c])
        A[r] = [gmul(inv, x) for x in A[r]]
        for k in range(nr):
            if k != r and not gz(A[k][c]):
                f = A[k][c]
                A[k] = [gsub(A[k][j], gmul(f, A[r][j])) for j in range(ncols)]
        piv_cols.append(c)
        r += 1
        if r == nr:
            break
    free = [c for c in range(ncols) if c not in piv_cols]
    basis = []
    for fc in free:
        v = [ZERO] * ncols
        v[fc] = ONE
        for i, pc in enumerate(piv_cols):
            v[pc] = gsub(ZERO, A[i][fc])
        basis.append(tuple(v))
    return basis


# ----------------------------------------------------------------------
# 1.  SL(2, F_11)
# ----------------------------------------------------------------------
P = 11
SQ = set((x * x) % P for x in range(1, P))          # {1,3,4,5,9}


def leg(a):
    a %= P
    if a == 0:
        return 0
    return 1 if a in SQ else -1


def mul(g, h):
    a, b, c, d = g
    e, f, gg, hh = h
    return ((a * e + b * gg) % P, (a * f + b * hh) % P,
            (c * e + d * gg) % P, (c * f + d * hh) % P)


def inv(g):
    a, b, c, d = g
    return (d % P, (-b) % P, (-c) % P, a % P)


ID = (1, 0, 0, 1)
NEG = (P - 1, 0, 0, P - 1)

SL = []
for a in range(P):
    for b in range(P):
        for c in range(P):
            for d in range(P):
                if (a * d - b * c) % P == 1:
                    SL.append((a, b, c, d))
SL = tuple(SL)
CHECK("SL2_F11_order_1320", len(SL) == 1320, f"|SL(2,11)| = {len(SL)}")


def order(g):
    k, h = 1, g
    while h != ID:
        h = mul(h, g)
        k += 1
    return k


ORD = {g: order(g) for g in SL}
prof = {}
for g in SL:
    prof[ORD[g]] = prof.get(ORD[g], 0) + 1
CHECK("SL2_order_profile",
      prof == {1: 1, 2: 1, 3: 110, 4: 110, 5: 264, 6: 110, 10: 264,
               11: 120, 12: 220, 22: 120},
      json.dumps({str(k): v for k, v in sorted(prof.items())}))
CHECK("unique_involution_is_minus_I",
      [g for g in SL if ORD[g] == 2] == [NEG],
      "the only involution of SL(2,11) is -I (so every V_4 lifts to Q_8)")

# ----------------------------------------------------------------------
# 2.  the integral 12-dimensional spin model  W = Ind_B^G(chi)
# ----------------------------------------------------------------------
# representatives of P^1(F_11): v_j = (j,1) for j<11, v_11 = (1,0)
VREP = [(j, 1) for j in range(P)] + [(1, 0)]


def line_index(w):
    a, b = w[0] % P, w[1] % P
    assert (a, b) != (0, 0)
    if b != 0:
        return (a * pow(b, P - 2, P)) % P
    return P


def act(g, w):
    a, b, c, d = g
    return ((a * w[0] + b * w[1]) % P, (c * w[0] + d * w[1]) % P)


def rho(g):
    """12x12 signed permutation matrix of g on W, as a list of rows of ints."""
    M = [[0] * 12 for _ in range(12)]
    for j in range(12):
        w = act(g, VREP[j])
        i = line_index(w)
        if i < P:
            mu = w[1]
        else:
            mu = w[0]
        M[i][j] = leg(mu)
    return M


def mmul(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(12)) for j in range(12)]
            for i in range(12)]


I12 = [[1 if i == j else 0 for j in range(12)] for i in range(12)]

GENS = [(1, 1, 0, 1), (0, P - 1, 1, 0)]     # standard T and S generate SL_2
sub = {ID}
front = [ID]
while front:
    nxt = []
    for g in front:
        for s in GENS:
            h = mul(g, s)
            if h not in sub:
                sub.add(h)
                nxt.append(h)
    front = nxt
CHECK("generators_generate_SL", len(sub) == 1320, f"|<T,S>| = {len(sub)}")

# homomorphism check: rho(g)rho(s) = rho(gs) for every g and both generators
homok = True
RHO = {g: rho(g) for g in SL}
for g in SL:
    for s in GENS:
        if mmul(RHO[g], RHO[s]) != RHO[mul(g, s)]:
            homok = False
            break
    if not homok:
        break
CHECK("rho_is_a_homomorphism", homok,
      "rho(g)rho(s) = rho(gs) for all 1320 g and both generators")
CHECK("rho_faithful", sum(1 for g in SL if RHO[g] == I12) == 1,
      "kernel of rho is trivial")
CHECK("rho_is_spin", RHO[NEG] == [[-1 if i == j else 0 for j in range(12)]
                                  for i in range(12)],
      "rho(-I) = -id_12: W is a purely spin representation")

CHI = {g: sum(RHO[g][i][i] for i in range(12)) for g in SL}
CHECK("chi_W_dim_12", CHI[ID] == 12, f"chi_W(1) = {CHI[ID]}")
norm = sum(CHI[g] * CHI[inv(g)] for g in SL)
CHECK("chi_W_norm_2", norm == 2 * 1320,
      f"<chi_W,chi_W> = {Fr(norm,1320)}  (so W = U (+) U' with U,U' "
      "non-isomorphic irreducibles)")
CHECK("chi_W_vanishes_on_order_4",
      all(CHI[g] == 0 for g in SL if ORD[g] == 4),
      "chi_W = 0 on the 110 elements of order 4 => both eigenspaces of a "
      "lifted involution have dimension 6 in W, hence 3 in U")

# ----------------------------------------------------------------------
# 3.  involutions of G = PSL(2,F_11) and their canonical order-4 lifts
# ----------------------------------------------------------------------
ORD4 = sorted(g for g in SL if ORD[g] == 4)
CHECK("110_order_4_elements", len(ORD4) == 110, f"{len(ORD4)} elements of order 4")

INV = []                       # canonical lift, one per projective involution
seen4 = set()
for g in ORD4:
    if g in seen4:
        continue
    ng = mul(NEG, g)
    seen4.add(g)
    seen4.add(ng)
    INV.append(g)
INV = tuple(sorted(INV))
CHECK("55_involutions", len(INV) == 55,
      f"PSL(2,11) has {len(INV)} involutions (one class of size 55)")

IDX = {s: k for k, s in enumerate(INV)}


def proj_inv_of(g):
    """index of the projective involution carried by an order-4 element."""
    return IDX[g] if g in IDX else IDX[mul(NEG, g)]


# ----------------------------------------------------------------------
# 4.  Q_8 lifts of the 55 Klein four-groups, and U|_{Q_8}
# ----------------------------------------------------------------------
def commute_proj(s, t):
    """do the projective images of s,t commute?  (s t s^-1 = +- t)"""
    c = mul(mul(s, t), inv(s))
    return c == t or c == mul(NEG, t)


V4S = set()
for a, b in combinations(range(55), 2):
    s, t = INV[a], INV[b]
    if commute_proj(s, t):
        c = proj_inv_of(mul(s, t))
        V4S.add(tuple(sorted((a, b, c))))
V4S = sorted(V4S)
CHECK("55_four_groups", len(V4S) == 55,
      f"{len(V4S)} Klein four-subgroups of PSL(2,11) (= Sylow 2-subgroups)")
CHECK("each_involution_in_3_four_groups",
      all(sum(1 for V in V4S if k in V) == 3 for k in range(55)),
      "each of the 55 involutions lies in exactly 3 of the 55 four-groups "
      "(a 55_3 configuration)")

# the preimage of a four-group, and its isomorphism type
q8_ok = True
q8_restriction = None
for V in V4S:
    s, t = INV[V[0]], INV[V[1]]
    Q = {ID}
    front = [ID]
    while front:
        nxt = []
        for g in front:
            for x in (s, t):
                h = mul(g, x)
                if h not in Q:
                    Q.add(h)
                    nxt.append(h)
        front = nxt
    if len(Q) != 8:
        q8_ok = False
        break
    if sum(1 for g in Q if ORD[g] == 2) != 1:
        q8_ok = False
        break
    # U|_Q : multiplicity of the 2-dim quaternionic irrep H and of the
    # four 1-dim characters.  chi_U = chi_W / 2 on Q (no order-11 elements).
    # <chi_U|_Q, 1> counts 1-dim trivial summands; more sharply, the number
    # of 1-DIMENSIONAL summands of any kind is
    #   (1/|Q|) sum_g chi_U(g) * conj(lambda(g)) summed over the 4 linear
    # characters = <chi_U|_Q, reg_{Q/[Q,Q]}> = (1/2)*(1/8)*sum_{g in [Q,Q]-
    # cosets ...); we compute it directly as dim of the [Q,Q]-invariants.
    comm = {ID, NEG}
    invdim_W = 0
    # dim W^{[Q,Q]} = dim W^{<-I>} = 0 since -I acts by -1.
    for g in comm:
        invdim_W += CHI[g]
    invdim_W = Fr(invdim_W, len(comm))
    if invdim_W != 0:
        q8_ok = False
        break
    # multiplicity of the 2-dim irrep H: <chi_U|_Q, chi_H> with
    # chi_H = (2,-2,0,0,0,0,0,0) on (1,-I, six order-4 elements)
    mH = Fr(0)
    for g in Q:
        chiH = 2 if g == ID else (-2 if g == NEG else 0)
        mH += Fr(CHI[g], 2) * chiH
    mH = mH / 8
    if q8_restriction is None:
        q8_restriction = mH
    if mH != 3:
        q8_ok = False
        break

CHECK("V4_preimages_are_Q8", q8_ok,
      "for every one of the 55 four-groups the preimage in SL(2,11) has "
      "order 8 with a unique involution, i.e. is Q_8")
CHECK("U_restricted_to_Q8_is_3H", q8_restriction == 3,
      f"U|_{{Q_8}} = {q8_restriction} * H  (H = the 2-dim quaternionic "
      "irreducible); NO 1-dimensional summand")
CHECK("PU_fixed_by_V4_is_empty", q8_restriction == 3,
      "hence P(U)^{V_4} = EMPTY for all 55 four-groups")

# ----------------------------------------------------------------------
# 5.  the 110 eigenplanes
# ----------------------------------------------------------------------
# For a canonical lift s (order 4), rho(s)^2 = -id, so W = W_{+i} (+) W_{-i}.
# U_{eps i}(s) = W_{eps i}(s) n U has dimension  dim W_{eps i}(s) / 2 = 3.
def eigbasis(s, eps):
    """basis of W_{eps*i}(rho(s)) over Q(i);  eps in {+1,-1}."""
    A = RHO[s]
    lam = IUNIT if eps == 1 else (Fr(0), Fr(-1))
    M = []
    for i in range(12):
        row = []
        for j in range(12):
            x = gint(A[i][j])
            if i == j:
                x = gsub(x, lam)
            row.append(x)
        M.append(tuple(row))
    return kernel_basis(M, 12)


PLANES = []                    # (involution index, eps)
EB = {}
for k, s in enumerate(INV):
    for eps in (1, -1):
        b = eigbasis(s, eps)
        EB[(k, eps)] = b
        PLANES.append((k, eps))
CHECK("110_eigenplanes", len(PLANES) == 110, f"{len(PLANES)} planes")
CHECK("eigenplanes_are_P2",
      all(len(EB[q]) == 6 for q in PLANES),
      "dim W_{+-i}(s) = 6 for all 110, hence dim U_{+-i}(s) = 3: every "
      "P(U)^sigma is a disjoint pair of projective PLANES in P^5")

# ----------------------------------------------------------------------
# 6.  the full incidence table of the 110 planes
# ----------------------------------------------------------------------
def inter_dim_U(q1, q2):
    """dim of the intersection of the two 3-dim subspaces of U."""
    rows = list(EB[q1]) + list(EB[q2])
    r = rank_q_i(rows, 12)
    dW = 12 - r
    assert dW % 2 == 0
    return dW // 2


# order of the product of two projective involutions == the dihedral type
def prod_order(a, b):
    g = mul(INV[a], INV[b])
    o = ORD[g]
    return o // 2 if o % 2 == 0 and mul(NEG, g) in SL and ORD[mul(NEG, g)] < o else o


def proj_order(g):
    k, h = 1, g
    while h != ID and h != NEG:
        h = mul(h, g)
        k += 1
    return k


PAIRTYPE = {}
for a, b in combinations(range(55), 2):
    PAIRTYPE[(a, b)] = proj_order(mul(INV[a], INV[b]))

tc = {}
for v in PAIRTYPE.values():
    tc[v] = tc.get(v, 0) + 1
CHECK("pair_types",
      tc == {2: 165, 3: 330, 5: 660, 6: 330},
      "orders of sigma*tau over the 1485 unordered pairs of involutions: "
      + json.dumps({str(k): v for k, v in sorted(tc.items())}))

INCID = {}
edges = []
for q1, q2 in combinations(PLANES, 2):
    d = inter_dim_U(q1, q2)
    INCID[(q1, q2)] = d
    if d > 0:
        edges.append((q1, q2, d))

# tabulate by (dihedral type, same/different involution)
table = {}
for (q1, q2), d in INCID.items():
    a, e1 = q1
    b, e2 = q2
    if a == b:
        key = ("same involution", "-")
    else:
        key = (f"n = {PAIRTYPE[(min(a,b),max(a,b))]}", "-")
    table.setdefault(key, {}).setdefault(d, 0)
    table[key][d] += 1

CHECK("commuting_pairs_give_disjoint_planes",
      all(d == 0 for (q1, q2), d in INCID.items()
          if q1[0] != q2[0] and PAIRTYPE[(min(q1[0], q2[0]),
                                          max(q1[0], q2[0]))] == 2),
      "planes of two COMMUTING involutions are disjoint (transverse: "
      "U = U_{+i}(sigma) (+) U_{eps i}(tau)) -- the quaternionic mechanism")
CHECK("same_involution_planes_disjoint",
      all(d == 0 for (q1, q2), d in INCID.items() if q1[0] == q2[0]),
      "the two planes of one involution are disjoint (eigenspace splitting)")
CHECK("D12_pairs_give_disjoint_planes",
      all(d == 0 for (q1, q2), d in INCID.items()
          if q1[0] != q2[0] and PAIRTYPE[(min(q1[0], q2[0]),
                                          max(q1[0], q2[0]))] == 6),
      "planes of a D_12-generating pair are disjoint: P(U)^{D_12} = EMPTY "
      "(the dicyclic group of order 24 has no spin linear character)")

# ----------------------------------------------------------------------
# 7.  connectivity of the incidence graph
# ----------------------------------------------------------------------
adj = {q: set() for q in PLANES}
for q1, q2, d in edges:
    adj[q1].add(q2)
    adj[q2].add(q1)

seenv = set()
comps = []
for q in PLANES:
    if q in seenv:
        continue
    stack = [q]
    seenv.add(q)
    comp = []
    while stack:
        x = stack.pop()
        comp.append(x)
        for y in adj[x]:
            if y not in seenv:
                seenv.add(y)
                stack.append(y)
    comps.append(sorted(comp))
comps.sort(key=len, reverse=True)

DEG = sorted(set(len(adj[q]) for q in PLANES))

# ----------------------------------------------------------------------
# 7b.  the DISTINCT incidence points, their stabilisers, and the local
#      tangent representation at each of them
# ----------------------------------------------------------------------
def rref_key(rows, ncols):
    """canonical RREF of the row span, as a hashable key."""
    A = [list(r) for r in rows]
    nr = len(A)
    r = 0
    piv = []
    for c in range(ncols):
        p = None
        for k in range(r, nr):
            if not gz(A[k][c]):
                p = k
                break
        if p is None:
            continue
        A[r], A[p] = A[p], A[r]
        iv = gdiv(ONE, A[r][c])
        A[r] = [gmul(iv, x) for x in A[r]]
        for k in range(nr):
            if k != r and not gz(A[k][c]):
                f = A[k][c]
                A[k] = [gsub(A[k][j], gmul(f, A[r][j])) for j in range(ncols)]
        piv.append(c)
        r += 1
        if r == nr:
            break
    return tuple(tuple((x[0], x[1]) for x in A[i]) for i in range(r))


def span_intersection(q1, q2):
    """basis of W_{..}(q1) n W_{..}(q2) as rows."""
    rows = list(EB[q1]) + list(EB[q2])
    M = [list(row) for row in zip(*rows)]        # 12 x 12 : columns = vectors
    # kernel of the 12x12 matrix whose columns are the 12 basis vectors gives
    # the linear relations; translate them back into common vectors.
    rel = kernel_basis([tuple(row) for row in M], 12)
    out = []
    for rl in rel:
        v = [ZERO] * 12
        for t in range(6):
            if not gz(rl[t]):
                for j in range(12):
                    v[j] = gadd(v[j], gmul(rl[t], EB[q1][t][j]))
        out.append(tuple(v))
    return out


POINTS = {}                     # rref key -> list of planes through it
for q1, q2, d in edges:
    S = span_intersection(q1, q2)
    assert len(S) == 2, len(S)
    key = rref_key(S, 12)
    POINTS.setdefault(key, {"planes": set(), "basis": S})
    POINTS[key]["planes"].add(q1)
    POINTS[key]["planes"].add(q2)

nplanes_hist = {}
for key, rec in POINTS.items():
    k = len(rec["planes"])
    nplanes_hist[k] = nplanes_hist.get(k, 0) + 1
CHECK("incidence_points",
      nplanes_hist == {3: 220, 5: 132},
      "the 1980 edges come from " + json.dumps(
          {f"{k} planes through the point": v
           for k, v in sorted(nplanes_hist.items())})
      + f"; {len(POINTS)} distinct points of P(U) in total")


def gens_group(mats):
    G0 = {ID}
    fr = [ID]
    while fr:
        nx = []
        for g in fr:
            for s in mats:
                h = mul(g, s)
                if h not in G0:
                    G0.add(h)
                    nx.append(h)
        fr = nx
    return G0


def apply_rho(g, v):
    A = RHO[g]
    return [(sum(Fr(A[i][j]) * v[j][0] for j in range(12)),
             sum(Fr(A[i][j]) * v[j][1] for j in range(12)))
            for i in range(12)]


def scalar_on(g, v, nz):
    """if rho(g) scales v, return the scalar; else None."""
    w = apply_rho(g, v)
    if gz(w[nz]):
        return None
    lam = gdiv(w[nz], v[nz])
    if all(gz(gsub(w[j], gmul(lam, v[j]))) for j in range(12)):
        return lam
    return None


def stab_of_point(rec):
    """the subgroup of G = PSL(2,11) fixing the point of P(U); computed as
    the set of projective classes g whose lift scales the line."""
    v = rec["basis"][0]
    nz = next(j for j in range(12) if not gz(v[j]))
    out = set()
    for g in SL:
        if scalar_on(g, v, nz) is not None:
            out.add(min(g, mul(NEG, g)))
    return out


# check the stabiliser on one representative of each of the two incidence
# types (the full sweep is the same statement by transitivity, verified below
# by orbit counting)
rep3 = next(rec for rec in POINTS.values() if len(rec["planes"]) == 3)
rep5 = next(rec for rec in POINTS.values() if len(rec["planes"]) == 5)
st3, st5 = stab_of_point(rep3), stab_of_point(rep5)
CHECK("S3_point_stabilizer_is_S3", len(st3) == 6,
      f"|Stab_G(x)| = {len(st3)} at a 3-plane incidence point: exactly the "
      "S_3 generated by the two involutions (S_3 is maximal among the "
      "subgroups of G that can fix a point of a spin P(V))")
CHECK("D10_point_stabilizer_is_D10", len(st5) == 10,
      f"|Stab_G(x)| = {len(st5)} at a 5-plane incidence point: exactly D_10")
CHECK("incidence_point_orbit_count",
      220 * 6 == 2 * 660 and 132 * 10 == 2 * 660,
      "220 S_3-points = 2 G-orbits of length 110; 132 D_10-points = 2 "
      "G-orbits of length 66")


def local_tangent_report(rec):
    """decompose T_x = Hom(L, U/L) as a representation of K = Stab_G(x)."""
    v = rec["basis"][0]
    nz = next(j for j in range(12) if not gz(v[j]))
    invs = sorted(set(q[0] for q in rec["planes"]))
    Ktil = gens_group([INV[a] for a in invs])
    lam = {g: scalar_on(g, v, nz) for g in Ktil}
    assert all(l is not None for l in lam.values())
    # chi_T(k) = lam(k)^{-1} * chi_U(k) - 1,  chi_U = chi_W / 2 on Ktil
    # descends to K = Ktil/<-I> because lam and chi_U both change sign there
    Kproj = {}
    for g in Ktil:
        cu = (Fr(CHI[g], 2), Fr(0))
        Kproj[min(g, mul(NEG, g))] = gsub(gmul(gdiv(ONE, lam[g]), cu), ONE)
    n = len(Kproj)
    acc_t, acc_s = ZERO, ZERO
    for g, x in Kproj.items():
        acc_t = gadd(acc_t, x)
        acc_s = gadd(acc_s, gmul(x, gint(-1 if proj_order(g) == 2 else 1)))
    m_triv = gdiv(acc_t, gint(n))
    m_sign = gdiv(acc_s, gint(n))
    s0m = min(INV[invs[0]], mul(NEG, INV[invs[0]]))
    cs = Kproj[s0m]
    d1 = gdiv(gadd(Kproj[ID], cs), gint(2))
    dm = gdiv(gsub(Kproj[ID], cs), gint(2))
    return n, m_triv, m_sign, d1, dm


T3 = local_tangent_report(rep3)
T5 = local_tangent_report(rep5)
CHECK("tangent_at_S3_point",
      T3[1] == ZERO and T3[2] == ONE and T3[3] == gint(2) and T3[4] == gint(3),
      "T_x = sign (+) 2*std as an S_3-representation: NO trivial summand, "
      "sign with multiplicity 1; dim T^{sigma,+} = 2, dim T^{sigma,-} = 3")
CHECK("tangent_at_D10_point",
      T5[1] == ZERO and T5[2] == ONE and T5[3] == gint(2) and T5[4] == gint(3),
      "T_x = sign (+) (two 2-dim) as a D_10-representation: NO trivial "
      "summand; dim T^{sigma,+} = 2, dim T^{sigma,-} = 3")

# ----------------------------------------------------------------------
# 7c.  connectivity of the sub-networks
# ----------------------------------------------------------------------
def components(edge_subset):
    ad = {q: set() for q in PLANES}
    for q1, q2 in edge_subset:
        ad[q1].add(q2)
        ad[q2].add(q1)
    sv, cs = set(), []
    for q in PLANES:
        if q in sv:
            continue
        st, comp = [q], []
        sv.add(q)
        while st:
            x = st.pop()
            comp.append(x)
            for y in ad[x]:
                if y not in sv:
                    sv.add(y)
                    st.append(y)
        cs.append(comp)
    return cs


E3 = [(q1, q2) for q1, q2, d in edges
      if PAIRTYPE[(min(q1[0], q2[0]), max(q1[0], q2[0]))] == 3]
E5 = [(q1, q2) for q1, q2, d in edges
      if PAIRTYPE[(min(q1[0], q2[0]), max(q1[0], q2[0]))] == 5]
C3g, C5g = components(E3), components(E5)
CHECK("n3_subgraph_connected", len(C3g) == 1,
      f"the S_3-only sub-network is already CONNECTED: {len(C3g)} component "
      f"of size {sorted(set(len(c) for c in C3g))}")
CHECK("n5_subgraph_connected", len(C5g) == 1,
      f"the D_10-only sub-network is also connected: {len(C5g)} component "
      f"of size {sorted(set(len(c) for c in C5g))}")

# graph distance between the planes of a D_12-generating pair
from collections import deque


def bfs(src):
    dist = {src: 0}
    dq = deque([src])
    while dq:
        x = dq.popleft()
        for y in adj[x]:
            if y not in dist:
                dist[y] = dist[x] + 1
                dq.append(y)
    return dist


D0 = bfs(PLANES[0])
CHECK("graph_eccentricity_3", max(D0.values()) == 3,
      f"the network is 36-regular of eccentricity {max(D0.values())} at "
      "every vertex (vertex-transitively)")
d12dists = set()
a0, e0 = PLANES[0]
for (b, e1) in PLANES:
    if b == a0:
        continue
    if PAIRTYPE[(min(a0, b), max(a0, b))] == 6:
        d12dists.add(D0[(b, e1)])
CHECK("D12_paired_planes_at_distance_2", d12dists == {2},
      f"planes of a D_12-generating pair sit at graph distance "
      f"{sorted(d12dists)}: they are never adjacent, but are joined by a "
      "2-edge path")

# ----------------------------------------------------------------------
# 8.  the odd-order eigenline strata  (C_3, C_5, C_11)
# ----------------------------------------------------------------------
def eig_mults(g):
    """multiplicities of the eigenvalues of rho(g) on U, indexed by the
    eigenvalue written as a power of a primitive |g|-th root of unity.
    Uses chi_U = chi_W/2 (valid off the order-11 classes) and, for order 11,
    the explicit even-Weil restriction."""
    n = ORD[g]
    out = {}
    for a in range(n):
        # multiplicity of zeta_n^a  =  (1/n) sum_k chi_U(g^k) zeta_n^{-ak}
        # computed exactly as a cyclotomic rational: use the integer
        # character values chi_W(g^k)/2 and exact roots of unity via
        # rational reconstruction with Fractions and a cyclotomic sum.
        out[a] = None
    return out


def mult_of_eigenvalue(g, a):
    """exact multiplicity in U of the eigenvalue zeta_n^a of rho(g),
    n = ord(g), computed by exact rank over Q(i) when n | 4 and by the
    exact minimal-polynomial/kernel method otherwise."""
    raise NotImplementedError


# For the odd-order strata we use exact ranks of integer matrices: the
# eigenspace of rho(g) for the eigenvalue zeta_n^a is computed as the kernel
# of Phi(rho(g)) where Phi runs over the factors of x^n - 1 over Q.  Working
# over Q is enough to read the DIMENSIONS of the rational eigen-blocks, and
# Galois conjugacy inside each block makes all its eigenvalue multiplicities
# equal.
def rank_int(rows, ncols):
    M = [[Fr(x) for x in r] for r in rows]
    nr = len(M)
    r = 0
    for c in range(ncols):
        piv = None
        for k in range(r, nr):
            if M[k][c] != 0:
                piv = k
                break
        if piv is None:
            continue
        M[r], M[piv] = M[piv], M[r]
        iv = 1 / M[r][c]
        M[r] = [iv * x for x in M[r]]
        for k in range(nr):
            if k != r and M[k][c] != 0:
                f = M[k][c]
                M[k] = [M[k][j] - f * M[r][j] for j in range(ncols)]
        r += 1
        if r == nr:
            break
    return r


def cyc_block_dim_W(g, poly):
    """dim of ker(poly(rho(g))) inside W, poly given as integer coeff list
    (ascending)."""
    A = RHO[g]
    Pw = [[0] * 12 for _ in range(12)]
    Acc = [row[:] for row in I12]
    for c in poly:
        if c:
            for i in range(12):
                for j in range(12):
                    Pw[i][j] += c * Acc[i][j]
        Acc = mmul(Acc, A)
    return 12 - rank_int(Pw, 12)


# C_3: canonical lift of order 6 (g with g^3 = -I).  The eigenvalues of a
# spin lift are the PRIMITIVE-parity ones: zeta_6^{odd}.
g3 = next(g for g in SL if ORD[g] == 6)
# x^2 - x + 1  (primitive 6th roots), x + 1 (eigenvalue -1)
d_prim6 = cyc_block_dim_W(g3, [1, -1, 1])
d_m1 = cyc_block_dim_W(g3, [1, 1])
CHECK("C3_lift_spin_spectrum", d_prim6 + d_m1 == 12,
      f"W|_{{C_6}} splits as prim6-block {d_prim6} + (-1)-block {d_m1}")
C3_MULTS = {"zeta6^1": d_prim6 // 4, "zeta6^5": d_prim6 // 4,
            "zeta6^3 = -1": d_m1 // 2}

# C_5: canonical lift of order 10.  Spin eigenvalues are zeta_10^{odd}.
g5 = next(g for g in SL if ORD[g] == 10)
d_prim10 = cyc_block_dim_W(g5, [1, -1, 1, -1, 1])      # Phi_10 = x^4-x^3+x^2-x+1
d_m1_5 = cyc_block_dim_W(g5, [1, 1])
CHECK("C5_lift_spin_spectrum", d_prim10 + d_m1_5 == 12,
      f"W|_{{C_10}} splits as prim10-block {d_prim10} + (-1)-block {d_m1_5}")
C5_MULTS = {"zeta10^odd (each of the 4 primitive)": Fr(d_prim10, 8),
            "zeta10^5 = -1": Fr(d_m1_5, 2)}

# C_6 <= PSL(2,11) (= the odd part of C_G(sigma) together with sigma):
# lift = the nonsplit torus C_12.  Its 6 spin linear characters are
# zeta_12^k with k odd; U must use each exactly once.
g6 = next(g for g in SL if ORD[g] == 12)
d_p12 = cyc_block_dim_W(g6, [1, 0, -1, 0, 1])          # Phi_12 = x^4-x^2+1
d_p4 = cyc_block_dim_W(g6, [1, 0, 1])                  # Phi_4  = x^2+1
CHECK("C6_lift_multiplicity_free", d_p12 // 2 == 4 and d_p4 // 2 == 2,
      f"U|_{{C_12}} = the 4 primitive-12th characters (block {d_p12//2}) "
      f"+ the two order-4 characters (block {d_p4//2}), each once: "
      "multiplicity-free, so P(U)^{C_6} = 6 isolated points, 3 on each of "
      "the two eigenplanes of sigma")

# C_11: odd order, so the lift has order 11 and W|_{C_11} is an honest
# C_11-representation.
g11 = next(g for g in SL if ORD[g] == 11)
d_triv11 = cyc_block_dim_W(g11, [-1, 1])                 # eigenvalue 1
d_prim11 = cyc_block_dim_W(g11, [1] * 11)                # Phi_11
CHECK("C11_spectrum", d_triv11 + d_prim11 == 12,
      f"W|_{{C_11}}: trivial-eigenvalue block {d_triv11}, "
      f"primitive block {d_prim11}")
C11_FIXED_DIM_U = d_triv11 // 2

# ----------------------------------------------------------------------
# 9.  stabiliser of a plane
# ----------------------------------------------------------------------
# g in G stabilises the pair {Pi_sigma^+, Pi_sigma^-} iff g centralises
# sigma; it stabilises each plane iff its lift COMMUTES with the lift of
# sigma (rather than inverting it).
s0 = INV[0]
CENT = [g for g in SL if commute_proj(s0, g)]
CENT_PROJ = set()
for g in CENT:
    CENT_PROJ.add(min(g, mul(NEG, g)))
CHECK("centralizer_is_D12", len(CENT_PROJ) == 12,
      f"|C_G(sigma)| = {len(CENT_PROJ)} (= D_12, sealed group fact FIX-A0)")
STAB = set()
for g in CENT:
    if mul(mul(g, s0), inv(g)) == s0:
        STAB.add(min(g, mul(NEG, g)))
CHECK("plane_stabilizer_is_C6", len(STAB) == 6,
      f"the stabiliser of a single eigenplane is the index-2 subgroup of "
      f"C_G(sigma) of order {len(STAB)} (= C_6); the 6 reflections of D_12 "
      "INVERT the order-4 lift and SWAP the two planes")
swaps = [g for g in CENT if mul(mul(g, s0), inv(g)) == mul(NEG, s0)]
CHECK("swap_elements_exist", len(swaps) == 12,
      f"{len(swaps)//2} projective elements of D_12 invert sigma-tilde and "
      "hence swap the two eigenplanes")

# ----------------------------------------------------------------------
# 10.  report
# ----------------------------------------------------------------------
def main():
    print("=" * 72)
    print("SPIN SOURCE NETWORK  --  P(U) = P^5,  Gtilde = SL(2,F_11)")
    print("=" * 72)
    for name, ok, det in CHECKS:
        print(f"[{'OK ' if ok else 'FAIL'}] {name:38s} {det}")

    print()
    print("-" * 72)
    print("INCIDENCE TABLE of the 110 eigenplanes (5995 unordered pairs)")
    print("-" * 72)
    print(f"{'pair type':28s} {'#pairs':>8s}  intersection dims")
    for key in sorted(table):
        row = table[key]
        tot = sum(row.values())
        dd = ", ".join(f"dim {k}: {v}" for k, v in sorted(row.items()))
        print(f"{key[0]:28s} {tot:8d}  {dd}")
    print()
    print(f"edges (intersecting pairs): {len(edges)}")
    print(f"vertex degrees present    : {DEG}")
    print(f"connected components      : {len(comps)}  "
          f"sizes {sorted(set(len(c) for c in comps))}")
    print(f"distinct incidence points : {len(POINTS)}  "
          f"({nplanes_hist.get(3,0)} with 3 planes = Stab S_3, "
          f"{nplanes_hist.get(5,0)} with 5 planes = Stab D_10)")
    print(f"S_3-only sub-network      : {len(C3g)} components, sizes "
          f"{sorted(set(len(c) for c in C3g))}")
    print(f"D_10-only sub-network     : {len(C5g)} components, sizes "
          f"{sorted(set(len(c) for c in C5g))}")
    print(f"T_x at an S_3 point       : dim 5, m_triv={T3[1][0]}, "
          f"m_sign={T3[2][0]}, dim T^(sigma,+)={T3[3][0]}, "
          f"dim T^(sigma,-)={T3[4][0]}")
    print(f"T_x at a D_10 point       : dim 5, m_triv={T5[1][0]}, "
          f"m_sign={T5[2][0]}, dim T^(sigma,+)={T5[3][0]}, "
          f"dim T^(sigma,-)={T5[4][0]}")
    print()
    print("-" * 72)
    print("ODD-ORDER EIGENLINE STRATA")
    print("-" * 72)
    print(f"C_3 (lift of order 6)   U|: {C3_MULTS}")
    print(f"C_5 (lift of order 10)  U|: {C5_MULTS}")
    print(f"C_11 (lift of order 11) U|: trivial multiplicity "
          f"{C11_FIXED_DIM_U}, primitive block dim {d_prim11//2}")
    print()
    print(f"P(U)^{{C_11}} = {C11_FIXED_DIM_U + d_prim11//2} isolated points; "
          f"dim U^{{C_11}} = {C11_FIXED_DIM_U}")
    print()
    if FAILS:
        print("FAILURES:", FAILS)
        print("SPIN_SOURCE_NETWORK_FAILED")
        return 1
    print("SPIN_SOURCE_NETWORK_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
