import mpmath as mp
mp.mp.dps = 60
I = mp.mpc(0,1); pi = mp.pi
z = lambda n, k: mp.e**(2*pi*I*mp.mpf(k)/n)   # e^(2 pi i k/n)
w = z(3,1); zeta = lambda k: z(11, k % 11)
lam, lamb = (-1 + I*mp.sqrt(11))/2, (-1 - I*mp.sqrt(11))/2
mu_p, mu_m = (-1 + mp.sqrt(5))/2, (-1 - mp.sqrt(5))/2
CL = ['1','2','3','5A','5B','6','11A','11B']
SZ = dict(zip(CL, [1,55,110,132,132,110,60,60]))
# character table (rows: irreps)
CT = {
 'triv': dict(zip(CL,[1,1,1,1,1,1,1,1])),
 'W':    dict(zip(CL,[5,1,-1,0,0,1,lam,lamb])),
 'Wb':   dict(zip(CL,[5,1,-1,0,0,1,lamb,lam])),
 'X10':  dict(zip(CL,[10,-2,1,0,0,1,-1,-1])),
 'X10p': dict(zip(CL,[10,2,1,0,0,-1,-1,-1])),
 'X11':  dict(zip(CL,[11,-1,-1,1,1,-1,0,0])),
 'X12':  dict(zip(CL,[12,0,0,mu_p,mu_m,0,1,1])),
 'X12p': dict(zip(CL,[12,0,0,mu_m,mu_p,0,1,1])),
}
# orthogonality self-test
for V in CT:
    for U in CT:
        s = sum(SZ[c]*CT[V][c]*mp.conj(CT[U][c]) for c in CL)/660
        assert abs(s - (1 if U==V else 0)) < 1e-40, (V,U,s)
# eigenvalues of class reps on W
QR = [1,3,4,5,9]; QNR = [2,6,7,8,10]
EIG = {'1':[1]*5, '2':[1,1,1,-1,-1], '3':[1,w,w,w**2,w**2],
 '5A':[z(5,k) for k in range(5)], '5B':[z(5,2*k) for k in range(5)],
 '6':[1,w,w**2,-w,-w**2], '11A':[zeta(k) for k in QR], '11B':[zeta(k) for k in QNR]}
for c in CL:
    assert abs(sum(EIG[c]) - CT['W'][c]) < 1e-40, c
# Molien: chi_{S^d W*}(c) via h_d of conjugate eigenvalues
DMAX = 64
molien = {}
for c in CL:
    ev = [mp.conj(e) for e in EIG[c]]
    p = [None]+[sum(e**k for e in ev) for k in range(1, DMAX+1)]
    h = [mp.mpf(1)]
    for d in range(1, DMAX+1):
        h.append(sum(p[k]*h[d-k] for k in range(1,d+1))/d)
    molien[c] = h
# AB: chi_d on H0(L^d), d >= 3
a11 = [1,9,4,3,5]
def chiL(d, c):
    if c == '1': return mp.mpf(20*d - 25)
    if c == '2': return mp.mpf(3)
    if c == '3':
        return 2*w**(2*d)/(1-w**2) + 2*w**d/(1-w)
    if c in ('5A','5B','6'): return mp.mpf(0)
    t = 1 if c == '11A' else 2  # 11B = Galois twist zeta -> zeta^2 (2 is a QNR)
    s = mp.mpf(0)
    for i in range(5):
        ai, an = a11[i], a11[(i+1) % 5]
        s += zeta(-d*ai*t)/(1 - zeta((ai-an)*t))
    return s
def mult(V, vals):
    s = sum(SZ[c]*vals[c]*mp.conj(CT[V][c]) for c in CL)/660
    r = int(mp.nint(mp.re(s)))
    assert abs(s - r) < 1e-35, (V, s)
    return r
print("d | mult_Wb(S^d) | mult_Wb(H0(L^d)) | ideal-part (window when >0)")
first = None
for d in range(3, DMAX+1):
    mS = mult('Wb', {c: molien[c][d] for c in CL})
    vals = {c: chiL(d, c) for c in CL}
    # full consistency: all irrep mults of H0(L^d) nonneg integers, dims sum to 20d-25
    tot = 0
    for V in CT:
        m = mult(V, vals); assert m >= 0, (d, V, m); tot += m*int(mp.re(CT[V]['1']))
    assert tot == 20*d - 25, (d, tot)
    mL = mult('Wb', vals)
    win = mS - mL
    if d <= 30 or win != 0 or d in (34, 36, 43):
        print(f"{d:3d} | {mS:4d} | {mL:4d} | {win:4d}")
    if win > 0 and first is None: first = d
print("FIRST d with covariant tuples vanishing on Hessian curve:", first)
