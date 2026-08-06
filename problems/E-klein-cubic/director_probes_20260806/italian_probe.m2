p = 397; kk = ZZ/p
R = kk[x0,x1,x2,x3,x4]
F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0
H = det matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)))
gF = flatten entries jacobian matrix{{F}};   -- degree 2, polar to dual
gH = flatten entries jacobian matrix{{H}};   -- degree 4, polar to dual
-- dual-side invariant cubic: same pentagonal shape (XRING-verified)
phi4 = apply(5, i -> (
  -- dFc/dy_i at y = gF : Fc = y0^2 y1 + y1^2 y2 + ... => dFc/dy_i = 2 y_i y_{i+1} + y_{i-1}^2
  2*gF#i*gF#((i+1)%5) + (gF#((i+4)%5))^2 ));
phi8 = apply(5, i -> 2*gH#i*gH#((i+1)%5) + (gH#((i+4)%5))^2 );  -- gradFc o gradH
sub5 = T -> map(R, R, matrix{{T#0, T#1, T#2, T#3, T#4}})
FT = T -> (sub5 T) F
HT = T -> (sub5 T) H
<< "F(phi4) == 0 identically: " << (FT phi4 == 0) << "   mod (F): " << (FT phi4 % ideal F == 0) << "   mod (H): " << (FT phi4 % ideal H == 0) << endl
<< "H(phi4) mod (H): " << (HT phi4 % ideal H == 0) << "   mod (F): " << (HT phi4 % ideal F == 0) << endl
<< "F(phi8) mod (F): " << (FT phi8 % ideal F == 0) << "   H(phi8) mod (H): " << (HT phi8 % ideal H == 0) << endl
-- Steinerian involution: st(x) = kernel vector of Hess at x, via 4x4 cofactors of the Hessian matrix
Hm = matrix table(5,5,(i,j) -> diff(R_i, diff(R_j, F)));
st = apply(5, j -> (-1)^j * det submatrix(Hm, {0,1,2,3}, sort toList(set{0,1,2,3,4} - set{j})));
-- st has degree 4 entries (4x4 minors of linear matrix); it is the adjugate row: Hm . st = H * e_row?
chk = (Hm * transpose matrix{st}) % ideal H;
<< "Hess * st == 0 mod (H)  (st is the kernel on V(H)): " << (chk == 0) << endl
<< "F(st) mod (H): " << (FT st % ideal H == 0) << "   H(st) mod (H): " << (HT st % ideal H == 0) << endl
<< "F(st) mod (F): " << (FT st % ideal F == 0) << endl
