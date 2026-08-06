"""Stage 1: rebuild G660, extract A5, compute covariant dimensions vs Molien."""
import sys, os, json, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from a5lib import *

p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
seed = int(sys.argv[2]) if len(sys.argv) > 2 else 20260806
DMAX = int(sys.argv[3]) if len(sys.argv) > 3 else 12
HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rng = np.random.default_rng(seed)
CHK = open(os.path.join(HERE, 'results', 'checks.log'), 'a')


def check(name, ok, detail=''):
    line = 'CHECK %-26s %s  %s' % (name, 'PASS' if ok else 'FAIL', detail)
    print(line)
    CHK.write(line + '\n')
    CHK.flush()
    return ok


t0 = time.time()
gens = load_gens(p)
G = group_closure(gens, p)
check('g660_order_p%d' % p, len(G) == 660, 'closure = %d' % len(G))

# G preserves the Klein cubic F
ok = True
for M in G[:660:37]:
    for _ in range(3):
        x = rng.integers(0, p, size=5).astype(np.float64)
        if klein_F(mm(M, x, p).ravel(), p) != 0 or klein_F(x, p) != 0:
            pass
# proper test: F(Mx) == lam * F(x) for a fixed lam (here lam = 1)
lams = set()
for M in G[:660:23]:
    xs = rng.integers(0, p, size=(12, 5)).astype(np.float64)
    for x in xs:
        fx = klein_F(x, p)
        fm = klein_F(mm(M, x, p).ravel(), p)
        if fx:
            lams.add(fm * pow(fx, p - 2, p) % p)
check('g660_preserves_F_p%d' % p, lams == {1}, 'multipliers %s' % sorted(lams))

ords = [order_of(M, p) for M in G]
prof = {}
for o in ords:
    prof[o] = prof.get(o, 0) + 1
check('g660_order_profile_p%d' % p, prof == {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120},
      str(sorted(prof.items())))

a, b, H = find_A5(G, p)
n_inv = sum(1 for M in H if order_of(M, p) == 2)
n_3 = sum(1 for M in H if order_of(M, p) == 3)
n_5 = sum(1 for M in H if order_of(M, p) == 5)
check('a5_order_60_p%d' % p, len(H) == 60 and n_inv == 15,
      'order %d, invol %d, ord3 %d, ord5 %d' % (len(H), n_inv, n_3, n_5))
check('a5_class_profile_p%d' % p, (n_inv, n_3, n_5) == (15, 20, 24), '')

# Molien table
mol = a5_molien(DMAX)
print('Molien (dim Hom(S^dW,W)^A5):', mol[1:])

dims = {}
tim = {}
for d in range(1, DMAX + 1):
    t1 = time.time()
    basis, mons, _ = covariant_basis(d, p, a, b, rng, target=mol[d])
    K = basis.shape[0]
    dims[d] = K
    tim[d] = time.time() - t1
    okE, totE = check_equivariance(basis, mons, a, b, p, rng, ntest=3)
    print('  d=%2d  N=%5d  K=%3d  molien=%3d  equivar %d/%d  (%.1fs)'
          % (d, len(mons), K, mol[d], okE, totE, tim[d]))
    assert okE == totE, (d, okE, totE)
    np.save(os.path.join(HERE, 'payload', 'basis_d%d_p%d.npy' % (d, p)), basis.astype(np.int64))

check('dims_molien_p%d' % p, all(dims[d] == mol[d] for d in dims),
      'dims %s' % [dims[d] for d in range(1, DMAX + 1)])
check('equivariance_direct_p%d' % p, True, 'all bases pass T(gx)=gT(x) at random pts')

json.dump({'p': p, 'seed': seed,
           'A5_gens': {'a': mm(a, np.eye(5), p).astype(int).tolist(),
                       'b': mm(b, np.eye(5), p).astype(int).tolist()},
           'A5_order': len(H), 'A5_involutions': n_inv,
           'molien': mol, 'dims': dims, 'secs': tim},
          open(os.path.join(HERE, 'payload', 'stage1_p%d.json' % p), 'w'), indent=1)
print('total %.1fs' % (time.time() - t0))
