p = 397; kk = ZZ/p
R = kk[x0,x1,x2,x3,x4]
F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
I = saturate(ideal H + ideal jacobian matrix{{H}}, ideal vars R);
<< "F in I_C (C on Klein cubic): " << (F % I == 0) << endl
<< "deg (I_C)_3 kernel: " << (35 - rank map(kk^1, kk^0, 0)) << endl
-- true h0(I_C(3)) via Hilbert function
<< "HF of R/I at 3,4,5,6: " << apply({3,4,5,6}, d -> hilbertFunction(d, I)) << endl
-- h0(O(d)) = binom(d+4,4): 35, 70, 126, 210
