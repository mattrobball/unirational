p = 397; kk = ZZ/p
R = kk[x0,x1,x2,x3,x4]
F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
I = saturate(ideal H + ideal jacobian matrix{{H}}, ideal vars R);
J = radical I;
<< "I == radical: " << (I == J) << endl
<< "degree J: " << degree J << "  HP: " << hilbertPolynomial(J, Projective=>false) << endl
e0 = matrix{{1_kk,0,0,0,0}}
J0 = sub(jacobian gens J, e0);
<< "tangent dim at e_0 (radical): " << rank ker transpose J0 << endl
-- affine multiplicity at e_0 via tangent cone
A = kk[y1,y2,y3,y4]
aff = apply(flatten entries gens J, f -> sub(f, {x0=>1_A, x1=>y1, x2=>y2, x3=>y3, x4=>y4}));
TC = tangentCone ideal aff;
<< "mult at e_0 (deg tangent cone): " << degree TC << "  dim: " << dim TC << endl
