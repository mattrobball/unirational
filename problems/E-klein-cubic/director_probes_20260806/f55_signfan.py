#!/usr/bin/env python3
# T3 test case: the SIGN-FAN -- arrangement fan of the five hyperplanes
# {H_k = 0}, H_k(n) = <sig^k n, G9>.  This is an aligned fan (wall normals
# mu_k = (sigma^T)^k G9 == 5^k G9 mod 11) NOT refined by the G9-fan: the
# first genuinely new combinatorial type for the general aligned case.
#
# Level-1 (Lemma T): U_s == tau_s * G9 (mod 11).  Level-2 shadow: the pair
# field (tau, Psi), Psi in Q = (Lambda/11)/(G9, diag) (3-dim), with:
#   - wall jumps: Delta(tau,Psi) in F11*(1, Theta_k) across every wall piece
#     of hyperplane k, Theta_k = rho_k / 5^k in Q, rho_k = (mu_k - 5^k G9)/11;
#   - (tau,Psi) = 0 on zero cells;
#   - sum tau over each sigma-orbit == 7 (mod 11).
# Cells: mixed sign vectors s (30).  Adjacency: s ~ flip_k(s) iff s minus
# coordinate k is mixed.  sigma: (sigma_hat s)_k = s_{k+1}; orbits: 6.
#
# Plan: solve the jump system once (kernel K), impose orbit-sums (affine
# subspace), then per-pattern feasibility = common zero of the pattern's
# evaluation functionals; sweep all minimal patterns if cheap, else
# structured + random.  Also run the analogous check WITHOUT Psi (level-1
# only) to confirm level 1 is solvable (the aligned signature).
from itertools import combinations, product
import random

G9 = (1, 5, 3, 4, 9)

# ---- lattice bookkeeping: Lambda/11 = F11^5 / diag; Q = further mod G9 ----
# basis reduction: represent an element of F11^5/diag by normal form with
# last coord 0 (subtract v4*(1,..,1)); then mod G9: G9 normal form
# (1,5,3,4,9)-(9,..,9) = (-8,-4,-6,-5,0) == (3,7,5,6,0).  Reduce by G9-multiples:
# kill coordinate 0 (coefficient 3 invertible).  Q-coords: coords 1,2,3 after.
def nf_diag(v):
    return tuple((v[j] - v[4]) % 11 for j in range(5))
G9n = nf_diag(G9)          # (3,7,5,6,0)
assert G9n[0] % 11 and G9n[4] == 0
inv_g0 = pow(G9n[0], 9, 11)
def nf_Q(v):
    w = nf_diag(v)
    c = (w[0] * inv_g0) % 11
    w = tuple((w[j] - c * G9n[j]) % 11 for j in range(5))
    assert w[0] == 0 and w[4] == 0
    return (w[1], w[2], w[3])

def sigT(m):  # (sigma^T m)_j = m_{j+1}
    return tuple(m[(j + 1) % 5] for j in range(5))

MU = []
m = G9
for k in range(5):
    MU.append(m)
    m = sigT(m)
# rho_k = (mu_k - 5^k G9)/11 as integer vector, then Theta_k = rho_k/5^k in Q
THETA = []
for k in range(5):
    p5 = pow(5, k)  # integer power fine
    diff = tuple(MU[k][j] - p5 * G9[j] for j in range(5))
    assert all(d % 11 == 0 for d in diff), (k, diff)
    rho = tuple(d // 11 for d in diff)
    inv5k = pow(pow(5, k, 11), 9, 11)
    THETA.append(nf_Q(tuple((x * inv5k) % 11 for x in rho)))
print("Theta_k in Q:", THETA)

# ---- cells, orbits, adjacency ----
CELLS = [s for s in product((1, -1), repeat=5) if len(set(s)) == 2]
CIDX = {s: i for i, s in enumerate(CELLS)}
def sig_cell(s):  # signs of H(sigma n): s'_k = s_{k+1}
    return tuple(s[(k + 1) % 5] for k in range(5))
ORBITS = []
seen = set()
for s in CELLS:
    if s in seen: continue
    orb = []
    q = s
    for _ in range(5):
        orb.append(q); q = sig_cell(q)
    assert len(set(orb)) == 5
    seen.update(orb)
    ORBITS.append(orb)
assert len(ORBITS) == 6
EDGES = []  # (cell index a, cell index b, hyperplane k)
for s in CELLS:
    for k in range(5):
        rest = [s[j] for j in range(5) if j != k]
        if len(set(rest)) < 2: continue  # not adjacent through k
        s2 = tuple((-s[j] if j == k else s[j]) for j in range(5))
        if CIDX[s] < CIDX[s2]:
            EDGES.append((CIDX[s], CIDX[s2], k))
print(f"cells {len(CELLS)}, orbits {len(ORBITS)}, walls {len(EDGES)}")

# ---- unknowns x = (tau_s, Psi_s[0..2]) per cell: 30*4 = 120 over F11 ----
NV = 120
def var_tau(i): return 4 * i
def var_psi(i, a): return 4 * i + 1 + a

# jump conditions: for edge (a,b,k): Psi_a - Psi_b - (tau_a - tau_b)*Theta_k = 0
rows = []
for a, b, k in EDGES:
    for c in range(3):
        r = [0] * NV
        r[var_psi(a, c)] = 1
        r[var_psi(b, c)] = (r[var_psi(b, c)] - 1) % 11
        r[var_tau(a)] = (r[var_tau(a)] - THETA[k][c]) % 11
        r[var_tau(b)] = (r[var_tau(b)] + THETA[k][c]) % 11
        rows.append((r, 0))
# orbit sums == 7
for orb in ORBITS:
    r = [0] * NV
    for s in orb:
        r[var_tau(CIDX[s])] = (r[var_tau(CIDX[s])] + 1) % 11
    rows.append((r, 7))

def solve_affine(rows, nv):
    # returns (particular, basis) or None over F11
    A = [list(r) + [rhs % 11] for r, rhs in rows]
    m = len(A); piv = []
    r0 = 0
    for col in range(nv):
        pr = next((i for i in range(r0, m) if A[i][col] % 11), None)
        if pr is None: continue
        A[r0], A[pr] = A[pr], A[r0]
        inv = pow(A[r0][col], 9, 11)
        A[r0] = [(x * inv) % 11 for x in A[r0]]
        for i in range(m):
            if i != r0 and A[i][col] % 11:
                f = A[i][col]
                A[i] = [(x - f * y) % 11 for x, y in zip(A[i], A[r0])]
        piv.append(col); r0 += 1
    for i in range(r0, m):
        if A[i][nv] % 11: return None
    part = [0] * nv
    for i, col in enumerate(piv): part[col] = A[i][nv]
    freec = [c for c in range(nv) if c not in piv]
    basis = []
    for fc in freec:
        v = [0] * nv; v[fc] = 1
        for i, col in enumerate(piv):
            v[col] = (-A[i][fc]) % 11
        basis.append(v)
    return part, basis

sol = solve_affine(rows, NV)
if sol is None:
    print("jump+sum system ALREADY infeasible with no zeros (unexpected)")
    raise SystemExit
part, basis = sol
print(f"jump+orbit-sum system solvable; solution space dim = {len(basis)}")

# per-pattern feasibility: zeros z (cells): require x = 0 at 4 coords each
def feasible(zeros):
    conds = []
    for i in zeros:
        for c in range(4):
            row = [b[4 * i + c] for b in basis]
            rhs = (-part[4 * i + c]) % 11
            conds.append((row, rhs))
    A = [list(r) + [rhs] for r, rhs in conds]
    m2 = len(A); nb = len(basis); r0 = 0
    for col in range(nb):
        pr = next((i for i in range(r0, m2) if A[i][col] % 11), None)
        if pr is None: continue
        A[r0], A[pr] = A[pr], A[r0]
        inv = pow(A[r0][col], 9, 11)
        A[r0] = [(x * inv) % 11 for x in A[r0]]
        for i in range(m2):
            if i != r0 and A[i][col] % 11:
                f = A[i][col]
                A[i] = [(x - f * y) % 11 for x, y in zip(A[i], A[r0])]
        r0 += 1
    return all(A[i][nb] % 11 == 0 for i in range(r0, m2))

# minimal patterns: choose 2 zero cells per orbit: 10^6 total.  First sample.
random.seed(20260807)
pairs = list(combinations(range(5), 2))
feas_found = []
Ntr = 3000
for t in range(Ntr):
    zeros = []
    for orb in ORBITS:
        i, j = random.choice(pairs)
        zeros.append(CIDX[orb[i]]); zeros.append(CIDX[orb[j]])
    if feasible(zeros):
        feas_found.append(zeros)
        print(f"trial {t}: FEASIBLE pattern on the sign-fan!")
        print("  zeros:", [CELLS[i] for i in zeros])
        break
print(f"sign-fan random minimal patterns: {t + 1 if feas_found else Ntr} tried, "
      f"{len(feas_found)} feasible")
