-- Independent machine check (Macaulay2, exact over QQ) that the Klein cubic
-- threefold X = V(F) in P^4 is smooth, i.e. the Jacobian ideal of F is
-- supported at the origin only.  Used by FIX-A0 claims 3 and 4.
R = QQ[x0,x1,x2,x3,x4];
F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0;
J = ideal jacobian ideal F;
<< "partials: " << toString gens J << endl;
<< "dim R/J  = " << dim J << "   (0 means V(J) = {origin}, so Sing(X) is empty)" << endl;
<< "radical  = " << toString radical J << endl;
assert(dim J == 0);
-- the 55 lines/planes live over Q(zeta_11); here we only certify smoothness of X.
<< "M2-KLEIN-SMOOTH-PASS" << endl;
