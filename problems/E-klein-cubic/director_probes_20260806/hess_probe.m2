kk = ZZ/32003
R = kk[x0,x1,x2,x3,x4]
F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
<< "deg Hess poly: " << first degree H << endl
I = ideal H + ideal jacobian matrix{{H}};
<< "codim: " << codim I << "  dim(proj): " << dim I - 1 << endl
<< "degree of scheme: " << degree I << endl
Isat = saturate(I, ideal vars R);
<< "degree after saturation: " << degree Isat << endl
hp = hilbertPolynomial(Isat, Projective=>false);
<< "Hilbert poly: " << hp << endl
