"""Independent Reynolds-sum evaluation engine for ARCJET_AUDIT.

MUST NOT import slicelib.jet_rows. Implements

    R(s)(v) := sum_{g in G}  rho(g)^{-1}  s( rho(g) v )

for monomial seeds s = X^alpha e_{c0}, and the truncated jet of R(s) along
the affine line w + t y:

    R(s)(w + t y) = sum_{k=0}^{J-1}  t^k  * jet_k   (mod t^J).

The factor 1/|G| is dropped (unit when p does not divide 660).
"""
import numpy as np


def eval_jet(frame, A, C, W, Y, J, deg=35):
    """Jet coefficients of Reynolds images of seeds.

    Parameters
    ----------
    frame : dict with keys p, RHO (660,5,5), RHOI (660,5,5)
    A : (ns, 5) monomial exponents
    C : (ns,) component indices in {0..4}
    W : (npair, 5) base points
    Y : (npair, 5) directions
    J : jet order (number of t-powers returned: 0..J-1)
    deg : total degree of the seeds

    Returns
    -------
    res : (ns, npair, 5, J)  array over F_p
    """
    p = frame["p"]
    RHO = frame["RHO"]
    RHOI = frame["RHOI"]
    ns = A.shape[0]
    npair = W.shape[0]
    res = np.zeros((ns, npair, 5, J), dtype=np.int64)

    def tmul(a, b):
        """Truncated polynomial product mod (t^J, p). Broadcast over leading dims."""
        out = np.zeros_like(a)
        for i in range(J):
            if i:
                out[..., i:] = (out[..., i:] +
                                a[..., i][..., None] * b[..., :J - i]) % p
            else:
                out = (out + a[..., 0][..., None] * b) % p
        return out % p

    for q in range(npair):
        u = (RHO @ W[q]) % p                 # (660, 5)
        up = (RHO @ Y[q]) % p
        POW = []
        for j in range(5):
            base = np.zeros((660, J), dtype=np.int64)
            base[:, 0] = u[:, j]
            if J > 1:
                base[:, 1] = up[:, j]
            cur = np.zeros((660, J), dtype=np.int64)
            cur[:, 0] = 1
            lst = [cur]
            for m in range(1, deg + 1):
                cur = tmul(cur, base)
                lst.append(cur)
            POW.append(np.stack(lst))        # (deg+1, 660, J)
        P = POW[0][A[:, 0]]
        for j in range(1, 5):
            P = tmul(P, POW[j][A[:, j]])
        for c0 in range(5):
            idx = np.nonzero(C == c0)[0]
            if idx.size == 0:
                continue
            Mg = RHOI[:, :, c0] % p          # (660, 5)
            res[idx, q] = np.einsum('sgj,gc->scj', P[idx], Mg) % p
    return res % p


def eval_at_points(frame, A, C, pts, deg=35):
    """R(s)(pt) for each seed and each point. Shape (ns, npts, 5)."""
    Y = np.zeros_like(pts)
    J = eval_jet(frame, A, C, pts, Y, 1, deg=deg)
    return J[:, :, :, 0]


def directional_deriv(frame, A, C, pts, dirs, deg=35):
    """d/dt R(s)(pt + t*dir)|_{t=0}. Shape (ns, npts, 5)."""
    J = eval_jet(frame, A, C, pts, dirs, 2, deg=deg)
    return J[:, :, :, 1]
