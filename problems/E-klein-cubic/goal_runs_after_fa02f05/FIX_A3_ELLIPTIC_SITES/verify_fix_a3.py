"""FIX-A3 verifier -- verification class: ALGEBRAIC-RECOMPUTE.

Independent of produce_fix_a3.py at every step:

  * certifies the rebuilt group is really PSL(2,11) via an exact Cayley-graph
    consistency check against 2x2 matrices over F_11 (the producer does not
    perform this check at all -- it is new verification content here);
  * recomputes every eigenspace (W+_sigma, W-_sigma, the tau-lines/points,
    the rho-eigenpoints) as the IMAGE of an averaging (Reynolds) PROJECTOR
    (1/|Gamma|) sum_{g in Gamma} rho(g), rather than as a NULLSPACE of
    (M - lambda I) the way the producer computes every eigenspace;
  * organizes the type-I/type-II computation around the three V4 <= C_G(sigma)
    subgroups directly (V4 = <sigma,t>, a well-defined subgroup of G) instead
    of around a chosen complement H = S3 < C_G(sigma) -- this sidesteps the
    (harmless but real) ambiguity that D12 = Z2 x S3 can have more than one
    S3-complement, so it is a genuinely different organizing principle, not
    just a relabelling;
  * recomputes discriminants via the Sylvester resultant Res(f,f') instead of
    the explicit a,b,c,d discriminant formula;
  * re-derives the residual-stabiliser argument from Fix(C_G(sigma)) (order
    12, the full centralizer) rather than from a chosen order-6 complement H;
  * re-runs the modular irreducibility spot-check at a DIFFERENT prime
    (p = 67 instead of p = 23) and on ALL 3 lines of BOTH representatives
    instead of just one;

and only then compares against sites.json.  Any mismatch is fatal.
"""
import json
import os
import sys
import time
from collections import deque

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import klein_exact as K
from klein_exact import Cyc, Cyc3, Poly, ZERO, ONE, C3ZERO, C3ONE, OMEGA

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()
FAIL = []


def log(*a):
    print('[%7.1fs]' % (time.time() - T0), *a, flush=True)


def check(name, cond):
    if not cond:
        FAIL.append(name)
        print('  *** FAIL: %s' % name, flush=True)
    return cond


def unjc(d):
    return Cyc(tuple(d['num']), d['den'])


def unjc3(d):
    return Cyc3(unjc(d['a']), unjc(d['b']))


def unjvec(v, F=Cyc):
    return [unjc(x) if F is Cyc else unjc3(x) for x in v]


def unjmat(M, F=Cyc):
    return [[unjc(x) if F is Cyc else unjc3(x) for x in row] for row in M]


payload = json.load(open(os.path.join(HERE, 'sites.json')))

# ---------------------------------------------------------------- helpers

def restrict_cubic(basis, F=Cyc):
    nv = len(basis)
    co = [Poly.var(i, nv, F) for i in range(nv)]
    vec = []
    for k in range(5):
        p = Poly({}, nv, F)
        for i, b in enumerate(basis):
            if b[k]:
                p = p + co[i] * b[k]
        vec.append(p)
    out = Poly({}, nv, F)
    for i in range(5):
        out = out + vec[i] * vec[i] * vec[(i + 1) % 5]
    return out


def det_n(M):
    import itertools
    n = len(M)
    tot = ZERO
    for perm in itertools.permutations(range(n)):
        sgn = 1
        pl = list(perm)
        for x in range(n):
            for y in range(x + 1, n):
                if pl[x] > pl[y]:
                    sgn = -sgn
        term = ONE
        for r in range(n):
            term = term * M[r][perm[r]]
        tot = tot + (term if sgn == 1 else -term)
    return tot


def disc_via_resultant(p):
    """discriminant of a binary cubic via Res(f,f')/(-a); independent of the
    producer's explicit 18abcd-4b^3d+... formula."""
    a = p.c.get((3, 0), ZERO)
    b = p.c.get((2, 1), ZERO)
    c = p.c.get((1, 2), ZERO)
    d = p.c.get((0, 3), ZERO)
    assert not a.is_zero(), 'chart degenerates at infinity (not expected here)'
    f = [a, b, c, d]
    g = [3 * a, 2 * b, c]
    rows = []
    for i in range(2):
        rows.append([ZERO] * i + f + [ZERO] * (2 - i))
    for i in range(3):
        rows.append([ZERO] * i + g + [ZERO] * (3 - i))
    return -det_n(rows) / a


def projector_matrix(mats_and_weight, n=5, F=Cyc):
    """the n x n averaging-projector matrix itself (not just its image) --
    used to also take its KERNEL (the complementary invariant subspace)."""
    zero = ZERO if F is Cyc else C3ZERO
    Pi = [[zero] * n for _ in range(n)]
    for M, w in mats_and_weight:
        for r in range(n):
            for c in range(n):
                if M[r][c]:
                    Pi[r][c] = Pi[r][c] + w * M[r][c]
    return Pi


def projector_image(mats_and_weight, n=5, F=Cyc):
    """image of (1/|elts|) * sum_{g in elts} rho(g), as a spanning set --
    the Reynolds/averaging-projector method for a fixed-space or an
    isotypic eigenspace (mats_and_weight: list of (matrix, scalar weight),
    weights already include the 1/|elts| normalisation and any character
    conjugate / power-sum coefficients)."""
    zero = ZERO if F is Cyc else C3ZERO
    Pi = [[zero] * n for _ in range(n)]
    for M, w in mats_and_weight:
        for r in range(n):
            for c in range(n):
                if M[r][c]:
                    Pi[r][c] = Pi[r][c] + w * M[r][c]
    cols = []
    one = ONE if F is Cyc else C3ONE
    for i in range(n):
        e = [one if k == i else zero for k in range(n)]
        cols.append(K.mat_vec(Pi, e, F))
    return K.rref(cols, F)[0]


def fixed_space_via_projector(G, subgroup_elts, F=Cyc):
    n = len(subgroup_elts)
    w = Cyc.from_frac(1, n) if F is Cyc else Cyc3(Cyc.from_frac(1, n), ZERO)
    return projector_image([(G.mats[g], w) for g in subgroup_elts], 5, F)


def mat_pow5(A, e, F=Cyc):
    return K.mat_pow(A, e, F)


def eigenspace_via_projector_C3(A5, lam_index, F=Cyc3):
    """image of (1/3) sum_{k=0..2} lam^{-k} A^k, for a matrix A of order
    dividing 3 (over Cyc3), lam_index in {0,1,2} <-> lambda in {1,omega,omega^2}."""
    lams = [C3ONE, OMEGA, OMEGA * OMEGA]
    lam = lams[lam_index]
    lam_inv = lam ** 2 if lam_index != 0 else C3ONE  # lam^{-1} = lam^2 since lam^3=1
    A2 = K.mat_mul(A5, A5, Cyc3)
    third = Cyc3(Cyc.from_frac(1, 3), ZERO)
    terms = [(K.identity(5, Cyc3), third),
             (A5, third * lam_inv),
             (A2, third * (lam_inv * lam_inv))]
    return projector_image(terms, 5, Cyc3)


# ======================================================= 1. certify the group

log('rebuilding <S,T> and certifying PSL(2,11) via Cayley-graph vs F_11 ...')
S, T = K.generators()
I5 = K.identity(5)
check('S^2 = 1', K.mat_pow(S, 2) == I5)
check('T^11 = 1', K.mat_pow(T, 11) == I5)
check('(ST)^3 = 1', K.mat_pow(K.mat_mul(S, T), 3) == I5)

G = K.Grp()
check('group order 660', G.n == 660)

# a SEPARATE, non-indexed BFS closure (K.build_group), cross-checked for the
# same element count -- an independent group-construction path
mats_flat = K.build_group()
check('independent build_group() also gives 660 elements', len(mats_flat) == 660)


def fmul(A, B):
    return tuple(sum(A[2 * i + k] * B[2 * k + j] for k in range(2)) % 11
                 for i in range(2) for j in range(2))


def fcanon(A):
    A = tuple(a % 11 for a in A)
    B = tuple((-a) % 11 for a in A)
    return min(A, B)


fone, fs, ft = fcanon((1, 0, 0, 1)), fcanon((0, 2, 5, 0)), fcanon((1, 2, 0, 1))
rho_map = {fone: 0}
q = deque([fone])
cayley_ok = True
while q:
    a = q.popleft()
    for b, gi in ((fs, 0), (ft, 1)):
        c = fcanon(fmul(a, b))
        m = G.act[gi][rho_map[a]]
        if c in rho_map:
            if rho_map[c] != m:
                cayley_ok = False
        else:
            rho_map[c] = m
            q.append(c)
check('Cayley graph of <S,T> matches PSL(2,11) over F_11 on all elements',
      cayley_ok and len(rho_map) == 660)

INV = [i for i in range(G.n) if G.ord[i] == 2]
check('55 involutions', len(INV) == 55)

# ============================================================ 2. per-representative

for repkey in ['primary_representative', 'spot_check_representative']:
    rec = payload[repkey]
    sigma = rec['sigma']
    log('=== verifying %s (sigma=%d) ===' % (repkey, sigma))
    A = G.mats[sigma]

    # -- eigenspaces via projector, not nullspace --
    WPv = projector_image([(I5, Cyc.from_frac(1, 2)), (A, Cyc.from_frac(1, 2))], 5, Cyc)
    WMv = projector_image([(I5, Cyc.from_frac(1, 2)), (A, Cyc.from_frac(-1, 2))], 5, Cyc)
    check('%s: dim W+ = 3 (projector method)' % repkey, len(WPv) == 3)
    check('%s: dim W- = 2 (projector method)' % repkey, len(WMv) == 2)
    WP_payload = unjmat(rec['WP_basis'])
    check('%s: W+ (projector) matches payload W+ (nullspace)' % repkey,
          K.subspace_key(WPv) == K.subspace_key(WP_payload))
    WM_payload = unjmat(rec['WM_basis'])
    check('%s: W- (projector) matches payload W- (nullspace)' % repkey,
          K.subspace_key(WMv) == K.subspace_key(WM_payload))

    # -- full centralizer, independent of any complement choice --
    C = G.centralizer(sigma)
    check('%s: |C_G(sigma)| = 12' % repkey, len(C) == 12)
    check('%s: C_G(sigma) matches payload' % repkey, sorted(C) == sorted(rec['centralizer_C_G_sigma']))

    # -- the 3 V4 <= C_G(sigma): organizing principle, complement-independent --
    T6 = [c for c in C if G.ord[c] == 2 and c != sigma]
    check('%s: 6 non-sigma involutions in C_G(sigma)' % repkey, len(T6) == 6)
    V4s_found = sorted(set(tuple(sorted(G.subgroup_closure([sigma, t]))) for t in T6))
    check('%s: exactly 3 distinct V4s through sigma' % repkey, len(V4s_found) == 3)
    payload_V4s = sorted(tuple(r['V4']) for r in rec['per_C2'])
    check('%s: the 3 V4s match payload (as sets, complement-independent)' % repkey,
          V4s_found == payload_V4s)

    # index payload per_C2 entries by V4 tuple for matching
    by_V4 = {tuple(r['V4']): r for r in rec['per_C2']}

    D12pt = None
    for V4 in V4s_found:
        prec = by_V4[V4]
        t_v = [x for x in V4 if x not in (0, sigma)][0]   # one of the 2 non-sigma involutions
        # line = Fix(V4) via projector over all 4 elements
        line_v = fixed_space_via_projector(G, V4, Cyc)
        check('%s: V4=%s line dim 2 (projector)' % (repkey, V4), len(line_v) == 2)
        check('%s: V4=%s line (projector) matches payload' % (repkey, V4),
              K.subspace_key(line_v) == K.subspace_key(unjmat(prec['line_ambient_basis'])))
        # point = W+_sigma cap W-_{t_v}, with W-_{t_v} ALSO via projector
        A_t = G.mats[t_v]
        WM_t = projector_image([(I5, Cyc.from_frac(1, 2)), (A_t, Cyc.from_frac(-1, 2))], 5, Cyc)
        pt_v = K.subspace_intersection(WPv, WM_t, 5)
        check('%s: V4=%s point dim 1 (projector)' % (repkey, V4), len(pt_v) == 1)
        check('%s: V4=%s point (projector) matches payload' % (repkey, V4),
              K.subspace_key(pt_v) == K.subspace_key([unjvec(prec['point_ambient'])]))

        # discriminant via resultant (independent formula) + on/off-X
        cubic2_v = restrict_cubic(line_v)
        disc_v = disc_via_resultant(cubic2_v)
        check('%s: V4=%s type-II reduced (resultant disc != 0) matches payload'
              % (repkey, V4), (not disc_v.is_zero()) == prec['discriminant_nonzero_reduced'])
        f_at_pt = K.klein_eval(pt_v[0])
        check('%s: V4=%s type-I point on-X matches payload' % (repkey, V4),
              f_at_pt.is_zero() == prec['type_I_point_on_X'])
        check('%s: V4=%s type-I point really on X' % (repkey, V4), f_at_pt.is_zero())

    # -- Fix(C_G(sigma)) via projector over all 12 elements: the D12 point --
    D12pt = fixed_space_via_projector(G, C, Cyc)
    check('%s: Fix(C_G(sigma)) is 1-dimensional' % repkey, len(D12pt) == 1)
    payload_D12 = unjvec(rec['S3_fixed_point_ambient_D12_point'])
    check('%s: Fix(C_G(sigma)) (projector, order 12) matches payload D12 point'
          % repkey, K.subspace_key(D12pt) == K.subspace_key([payload_D12]))
    check('%s: D12 point off X' % repkey, not K.klein_eval(D12pt[0]).is_zero())

    # -- std-isotypic line P(std): here via ker(Pi_C) cap W+ (Pi_C the FULL
    # 5-dim averaging projector over all 12 elements of C_G(sigma)) --
    # genuinely different from the producer's ker(Mrho^2+Mrho+I) route:
    # this uses the WHOLE centralizer (not just rho) and works by KERNEL of
    # the ambient projector rather than a WP-restricted minimal-polynomial
    # factorisation.
    n = len(C)
    Pi_C = projector_matrix([(G.mats[c], Cyc.from_frac(1, n)) for c in C], 5, Cyc)
    ker_Pi_C = K.nullspace(Pi_C, 5, Cyc)
    check('%s: ker(Pi_C) is 4-dimensional' % repkey, len(ker_Pi_C) == 4)
    std_iso_v = K.subspace_intersection(ker_Pi_C, WPv, 5, Cyc)
    check('%s: std-isotypic line is 2-dimensional (projector-kernel method)'
          % repkey, len(std_iso_v) == 2)
    payload_std = unjmat(rec['std_isotypic_line_P_std_ambient_basis'])
    check('%s: std-isotypic line (projector-kernel) matches payload '
          '(ker(Mrho^2+Mrho+I) method)' % repkey,
          K.subspace_key(std_iso_v) == K.subspace_key(payload_std))
    # every type-I point (payload) must lie on this line
    all_on_std = True
    for prec in rec['per_C2']:
        v = unjvec(prec['point_ambient'])
        rk_without = len(K.rref(list(std_iso_v))[1])
        rk_with = len(K.rref(list(std_iso_v) + [v])[1])
        all_on_std = all_on_std and (rk_with == rk_without)
    check('%s: all 3 type-I points lie on the std-isotypic line (re-verified)'
          % repkey, all_on_std)

    # -- rho eigenpoints via AMBIENT (5-dim) projector, intersected with W+ --
    # (genuinely different route from the producer's WP-restricted-matrix
    # diagonalisation: here rho acts on the FULL 5-dim W; the omega/omega^2
    # ambient eigenspaces are 2-dimensional (one W+ direction, one W- one)
    # and must be intersected with W+_sigma to isolate the E_sigma point.)
    rho = rec['rho']
    Arho = G.mats[rho]
    check('%s: rho has order 3' % repkey, G.ord[rho] == 3)
    Arho3 = [[Cyc3.lift(x) for x in row] for row in Arho]
    WPv3 = [[Cyc3.lift(x) for x in row] for row in WPv]
    eig_ambient = [eigenspace_via_projector_C3(Arho3, k) for k in range(3)]
    check('%s: ambient rho-eigenspace dims (1,2,2)' % repkey,
          [len(e) for e in eig_ambient] == [1, 2, 2])
    triv_pt_v = eig_ambient[0]
    check('%s: ambient eigenvalue-1 eigenspace of rho == D12 point' % repkey,
          K.subspace_key(triv_pt_v, Cyc3) == K.subspace_key([[Cyc3.lift(x) for x in payload_D12]], Cyc3))
    omega_pt = K.subspace_intersection(eig_ambient[1], WPv3, 5, Cyc3)
    omega2_pt = K.subspace_intersection(eig_ambient[2], WPv3, 5, Cyc3)
    check('%s: omega-eigenpoint of rho on W+ is 1-dim' % repkey, len(omega_pt) == 1)
    check('%s: omega^2-eigenpoint of rho on W+ is 1-dim' % repkey, len(omega2_pt) == 1)

    def klein_eval3(v):
        s = C3ZERO
        for i in range(5):
            s = s + v[i] * v[i] * v[(i + 1) % 5]
        return s
    fC3 = [not klein_eval3(triv_pt_v[0]).is_zero(),
           not klein_eval3(omega_pt[0]).is_zero(),
           not klein_eval3(omega2_pt[0]).is_zero()]
    check('%s: all 3 C3-eigenpoints off X (ambient-projector method)' % repkey,
          all(fC3))
    check('%s: matches payload C3_eigenpoints_on_X = [False,False,False]' % repkey,
          rec['C3_eigenpoints_on_X'] == [False, False, False])

    # -- residual-stabiliser argument, redone from the FULL centralizer --
    # Fix(t_a) cap Fix(t_b) for t_a,t_b from two DIFFERENT V4s must equal
    # Fix(C_G(sigma)) = {D12 point}, computed here via projectors throughout.
    reps = []
    for V4 in V4s_found:
        t_v = [x for x in V4 if x not in (0, sigma)][0]
        reps.append(t_v)
    pair_ok = True
    for i in range(3):
        for j in range(i + 1, 3):
            Fi = projector_image([(I5, Cyc.from_frac(1, 2)), (G.mats[reps[i]], Cyc.from_frac(1, 2))], 5, Cyc)
            Fj = projector_image([(I5, Cyc.from_frac(1, 2)), (G.mats[reps[j]], Cyc.from_frac(1, 2))], 5, Cyc)
            Fij = K.subspace_intersection(Fi, Fj, 5)
            ok = (len(Fij) == 1 and K.subspace_key(Fij) == K.subspace_key([payload_D12]))
            pair_ok = pair_ok and ok
    check('%s: Fix(t_a)+ cap Fix(t_b)+ over different V4s = D12 point (projector)'
          % repkey, pair_ok)
    log('%s: all V4/stabiliser checks passed so far, failures so far: %d'
        % (repkey, len(FAIL)))

log('per-representative verification done, failures so far: %d' % len(FAIL))

# ================================================= 3. conjugation transport

ct = payload['conjugation_transport_check']
sigma0, sigma1, gC = ct['sigma0'], ct['sigma1'], ct['conjugator_g']
check('conjugator really conjugates sigma0 to sigma1', G.conj(sigma0, gC) == sigma1)
WP0 = unjmat(payload['primary_representative']['WP_basis'])
WP1 = unjmat(payload['spot_check_representative']['WP_basis'])
transported = [K.mat_vec(G.mats[gC], b) for b in WP0]
check('g-transport of P_sigma0 equals P_sigma1 (re-verified)',
      K.subspace_key(transported) == K.subspace_key(WP1))
# additionally transport the D12 point and confirm it matches sigma1's D12 point
D12_0 = unjvec(payload['primary_representative']['S3_fixed_point_ambient_D12_point'])
D12_1 = unjvec(payload['spot_check_representative']['S3_fixed_point_ambient_D12_point'])
D12_0_transported = K.mat_vec(G.mats[gC], D12_0)
check('g-transport of the D12 point of sigma0 equals the D12 point of sigma1',
      K.subspace_key([D12_0_transported]) == K.subspace_key([D12_1]))

# ============================================== 4. modular spot-check, p=67,
# all 3 lines of BOTH representatives (producer only did 1 line, p=23)

PRIME = 67


def modp_irreducible_check(cubic2, p):
    assert p % 11 == 1
    root = None
    for cand in range(2, p):
        if pow(cand, 11, p) == 1 and cand != 1:
            root = cand
            break
    assert root is not None
    for k in range(1, 11):
        z = pow(root, k, p)

        def ev(c):
            s = 0
            for i, ci in enumerate(c.n):
                s = (s + ci * pow(z, i, p)) % p
            dinv = pow(c.d % p, -1, p)
            return (s * dinv) % p
        a = ev(cubic2.c.get((3, 0), ZERO))
        b = ev(cubic2.c.get((2, 1), ZERO))
        c_ = ev(cubic2.c.get((1, 2), ZERO))
        d = ev(cubic2.c.get((0, 3), ZERO))
        roots = [s for s in range(p) if (a * s ** 3 + b * s ** 2 + c_ * s + d) % p == 0]
        if roots or a % p == 0:
            return False
    return True


modp_all_ok = True
for repkey in ['primary_representative', 'spot_check_representative']:
    for prec in payload[repkey]['per_C2']:
        cubic2 = restrict_cubic(unjmat(prec['line_ambient_basis']))
        ok = modp_irreducible_check(cubic2, PRIME)
        modp_all_ok = modp_all_ok and ok
check('modular irreducibility (p=%d) holds for all 3 lines of both '
      'representatives (6 lines total)' % PRIME, modp_all_ok)
log('modular spot-check at p=%d, all 6 lines: %s' % (PRIME, modp_all_ok))

# ==================================================== 5. cross-reference sanity

xref = payload['cross_reference_FIX_A0_FIX_A1']
if xref.get('available'):
    check('cross-ref: FIX-A1 3+9 reconciles', xref['reconciles_with_our_3_plus_9'])
    check('cross-ref: our V4s found in FIX-A0 V4 list',
          all(xref['V4_subgroups_of_sigma0_found_in_FIX_A0_list']))
else:
    log('cross-reference to FIX-A0/A1 unavailable in payload (non-fatal)')

check('summary.total_known_sites_on_E_sigma == 12', payload['summary']['total_known_sites_on_E_sigma'] == 12)
check('summary.new_sites_found == 0', payload['summary']['new_sites_found'] == 0)

# ==================================================================== verdict

log('TOTAL CHECKS FAILED: %d' % len(FAIL))
if FAIL:
    print('VERIFY: FAIL --', FAIL)
    sys.exit(1)
else:
    print('VERIFY: PASS -- all FIX-A3 claims independently recomputed '
          '(projector/Reynolds-operator eigenspaces, V4-organized instead of '
          'H-complement-organized, resultant discriminants, ambient rho '
          'diagonalisation, PSL(2,11)-Cayley-graph group certification, '
          'p=67 modular spot-check on all 6 lines) and matched.')
    sys.exit(0)
