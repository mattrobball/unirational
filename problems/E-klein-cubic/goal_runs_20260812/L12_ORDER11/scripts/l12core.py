"""L12 order-11 core: geometry, Atiyah-Bott sums, blowup towers.

CONVENTION (pinned here, calibrated by the anchors in anchors.py):

  g has order 11, acting on W with eigenbasis e_0..e_4, g e_i = zeta^{a_i}.
  a = (1, 9, 4, 3, 5) = the QR set {1,3,4,5,9} ORDERED so that
  a_{i+1} = -2 a_i (mod 11); this is exactly the ordering that makes
  F = sum_i x_i^2 x_{i+1} a g-INVARIANT cubic (weight 0), and it reproduces
  s2pin's `forbidden_relative_weight(11,a) = -3a` as the normal weight of
  X at e_j (since a_{j+1} - a_j = -3 a_j).

  * T_{e_j} P(W) weights:  a_i - a_j   (i != j)                 [4 of them]
  * normal weight of X at e_j: a_{j+1} - a_j = -3 a_j
  * T_{e_j} X weights:  a_i - a_j,  i not in {j, j+1}           [3 of them]
  * O(k) fibre weight at e_j:  zeta^{-k a_j}
  * isolated-fixed-point contribution:  w_k(x) / det(1 - dg^{-1} | T)
        i.e. denominator  prod_t (1 - zeta^{-w_t})  over tangent weights w_t.
    For X this is prod_{k' not in {j,j+1}} (1 - zeta^{a_j - a_{k'}}), the
    ledger's Sec.3 display.  See anchors.py FLAG-A for the Sec.8 wording.
"""
import cyclo as C

N = 11
A = (1, 9, 4, 3, 5)          # a_i on the eigenBASIS, a_{i+1} = -2 a_i
QR = frozenset({1, 3, 4, 5, 9})
WEIGHT_INDEX = {A[i]: i for i in range(5)}


# ------------------------------------------------------------------ geometry
def check_frame():
    """Structural facts the whole packet rests on."""
    out = {}
    out["weights_are_QR"] = set(A) == set(QR)
    out["recursion_-2"] = all(A[(i + 1) % 5] == (-2 * A[i]) % N for i in range(5))
    out["F_invariant"] = all((2 * A[i] + A[(i + 1) % 5]) % N == 0 for i in range(5))
    out["sum_zero"] = sum(A) % N == 0
    out["normal_is_-3a"] = all(
        (A[(i + 1) % 5] - A[i]) % N == (-3 * A[i]) % N for i in range(5)
    )
    out["tangent_nonzero"] = all(
        (A[i] - A[j]) % N != 0 for i in range(5) for j in range(5) if i != j
    )
    return out


def tangent_P4(j):
    return tuple((A[i] - A[j]) % N for i in range(5) if i != j)


def tangent_X(j):
    bad = {j, (j + 1) % 5}
    return tuple((A[i] - A[j]) % N for i in range(5) if i not in bad)


def det_factor(weights):
    """det(1 - dg^{-1}|T) = prod (1 - zeta^{-w})."""
    return C.prod([C.one_minus_zpow(-w) for w in weights])


def D_P4(j):
    return det_factor(tangent_P4(j))


def D_X(j):
    return det_factor(tangent_X(j))


def wk(k, j):
    """O(k) fibre weight at e_j."""
    return C.zpow(-k * A[j])


def wk_weight(k, w):
    """O(k) fibre weight at the eigenpoint of WEIGHT w."""
    return C.zpow(-k * w)


# ------------------------------------------------------- characters (Molien)
def chi_sym_Wstar(k):
    """chi_{Sym^k W*}(g) = sum_{|alpha|=k} zeta^{-<alpha,a>}, exact."""
    acc = C.zero()
    for alpha in _compositions(k, 5):
        e = -sum(alpha[i] * A[i] for i in range(5))
        acc = C.add(acc, C.zpow(e))
    return acc


def _compositions(total, parts):
    if parts == 1:
        yield (total,)
        return
    for t in range(total + 1):
        for rest in _compositions(total - t, parts - 1):
            yield (t,) + rest


def chi_OX(k):
    """chi_g(X, O_X(k)) from the Koszul sequence (F invariant, weight 0)."""
    r = chi_sym_Wstar(k)
    if k >= 3:
        r = C.sub(r, chi_sym_Wstar(k - 3))
    return r


# ------------------------------------------------------------------- towers
class Node:
    """A g-fixed point of a blowup tower over P(W).

    tw    : tuple of 4 tangent weights (mod 11, all nonzero)
    vw    : accumulated value weight  d*a_k + sum_l mu_l c_l  (mod 11)
    depth : blowup depth
    """

    __slots__ = ("tw", "vw", "depth")

    def __init__(self, tw, vw, depth):
        self.tw = tuple(w % N for w in tw)
        self.vw = vw % N
        self.depth = depth

    def defined(self):
        return self.vw in QR

    def D(self):
        return det_factor(self.tw)

    def children(self, mu):
        """Blow up this point; mu = multiplicity of the current leading form."""
        kids = []
        for t, c in enumerate(self.tw):
            rest = [(self.tw[s] - c) % N for s in range(len(self.tw)) if s != t]
            kids.append(Node((c,) + tuple(rest), self.vw + mu * c, self.depth + 1))
        return kids


def root(j, d):
    """Level-0 node: the point e_j of P(W), value weight d*a_j."""
    return Node(tangent_P4(j), d * A[j], 0)


def mass(nodes):
    return C.total([C.inv(n.D()) for n in nodes])
