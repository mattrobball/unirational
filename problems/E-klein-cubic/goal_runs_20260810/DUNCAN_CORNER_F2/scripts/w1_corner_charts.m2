-- W1 (chart part) -- explicit T1,T2,T3 blowup charts and the fabulous corner.
--
-- Local model at a general point of ell_V:  A^4 = Spec QQ[u1,u2,u3,u4] with V4
-- acting diagonally with characters (triv, chi_z, chi_s, chi_r) on
-- (u1,u2,u3,u4).  This is EXACT, not merely formal: a neighbourhood of a
-- general point of ell_V = P(A) in P(W) is V-equivariantly the total space of
-- N_{ell_V} = O(1) tensor (B+C+D), which is trivial over an affine chart of
-- ell_V and splits into the three character lines (verified in
-- w1_corner_global.py).
--
--   T1: blow up ell_V = V(u2,u3,u4)   [chart u2 leading]
--   T2: blow up P~_z  = V(a3,a4)      [chart m4 leading]  (P~_z = Fix(z))
--   T3: blow up M~_s  = V(b2,b3)      [chart k  leading]  (M~_s = Fix(s) in E_V)
--
-- Ring variables are given distinct names per chart to avoid M2 shadowing:
--   R0 : u1 u2 u3 u4
--   R1 : a1 a2 a3 a4      = ( u1 , U2 , m3 , m4 )
--   R2 : b1 b2 b3 b4      = ( u1 , U2 , k  , m4 )
--   R3 : c1 c2 c3 c4      = ( u1 , k  , v  , m4 )
--
-- Everything below is computed, not asserted: strict transforms by saturation,
-- fixed loci from the induced ring automorphisms, primality by isPrime.

errCount = 0;
chk = (name, b) -> (
    if b then (<< "OK   " << name << endl)
    else (<< "FAIL " << name << endl; errCount = errCount + 1));

R0 = QQ[u1,u2,u3,u4];
R1 = QQ[a1,a2,a3,a4];
R2 = QQ[b1,b2,b3,b4];
R3 = QQ[c1,c2,c3,c4];

psi1 = map(R1, R0, {a1, a2, a2*a3, a2*a4});
psi2 = map(R2, R1, {b1, b2, b4*b3, b4});
psi3 = map(R3, R2, {c1, c2*c3, c2, c4});
phi  = psi3 * psi2 * psi1;
<< "composite phi(u1,u2,u3,u4) = " << {phi u1, phi u2, phi u3, phi u4} << endl;
<< "  [ u1 , k*v , k^2*v*m4 , k*v*m4 ]" << endl;

-- ---------------- V4-action, transported chart by chart -------------------
-- On R0 the characters are (0,a,b,c) with a=chi_z, b=chi_s, c=chi_r, so
--   a(z)=+1, b(z)=-1, c(z)=-1    and    a(s)=-1, b(s)=+1, c(s)=-1.
z0 = map(R0,R0,{u1, u2,-u3,-u4});   s0 = map(R0,R0,{u1,-u2, u3,-u4});
z1 = map(R1,R1,{a1, a2,-a3,-a4});   s1 = map(R1,R1,{a1,-a2,-a3, a4});
z2 = map(R2,R2,{b1, b2, b3,-b4});   s2 = map(R2,R2,{b1,-b2,-b3, b4});
z3 = map(R3,R3,{c1, c2, c3,-c4});   s3 = map(R3,R3,{c1,-c2, c3, c4});
r0 = s0*z0;  r1 = s1*z1;  r2 = s2*z2;  r3 = s3*z3;

chk("z transported correctly through the T1 chart",
    (psi1*z0) u2 == (z1*psi1) u2 and (psi1*z0) u3 == (z1*psi1) u3
    and (psi1*z0) u4 == (z1*psi1) u4);
chk("s transported correctly through the T1 chart",
    (psi1*s0) u2 == (s1*psi1) u2 and (psi1*s0) u3 == (s1*psi1) u3
    and (psi1*s0) u4 == (s1*psi1) u4);
chk("z transported correctly through the T2 chart",
    (psi2*z1) a3 == (z2*psi2) a3 and (psi2*z1) a4 == (z2*psi2) a4);
chk("s transported correctly through the T2 chart",
    (psi2*s1) a3 == (s2*psi2) a3 and (psi2*s1) a4 == (s2*psi2) a4);
chk("z transported correctly through the T3 chart",
    (psi3*z2) b2 == (z3*psi3) b2 and (psi3*z2) b3 == (z3*psi3) b3);
chk("s transported correctly through the T3 chart",
    (psi3*s2) b2 == (s3*psi3) b2 and (psi3*s2) b3 == (s3*psi3) b3);
chk("V4 relations hold in the final chart",
    all(gens R3, x -> (z3*z3) x == x) and all(gens R3, x -> (s3*s3) x == x)
    and all(gens R3, x -> (z3*s3) x == (s3*z3) x));

fixIdeal = (f, R) -> trim ideal apply(gens R, x -> f x - x);

<< endl << "--- level 0 : A^4, the local model at a general point of ell_V ---" << endl;
chk("Fix(z) = V(u3,u4) = plus-plane P_z (codim 2)", fixIdeal(z0,R0) == ideal(u3,u4));
chk("Fix(s) = V(u2,u4) = plus-plane P_s (codim 2)", fixIdeal(s0,R0) == ideal(u2,u4));
chk("Fix(r) = V(u2,u3) = plus-plane P_r (codim 2)", fixIdeal(r0,R0) == ideal(u2,u3));
chk("Fix(V4) = V(u2,u3,u4) = ell_V has codim 3 (NO fabulous corner on P(W))",
    (fixIdeal(z0,R0)+fixIdeal(s0,R0)) == ideal(u2,u3,u4)
    and codim (fixIdeal(z0,R0)+fixIdeal(s0,R0)) == 3);
chk("no divisor is fixed pointwise on P(W): every Fix has codim >= 2",
    codim fixIdeal(z0,R0) >= 2 and codim fixIdeal(s0,R0) >= 2
    and codim fixIdeal(r0,R0) >= 2);

<< endl << "--- after T1 (blow up ell_V), chart u2 ---" << endl;
EV1 = ideal(a2);
chk("Fix(z) = V(a3,a4) = P~_z (strict transform of the plus-plane)",
    fixIdeal(z1,R1) == ideal(a3,a4));
chk("Fix(s) = V(a2,a3) = M_s, a NEW codim-2 component inside E_V",
    fixIdeal(s1,R1) == ideal(a2,a3) and isSubset(EV1, ideal(a2,a3)));
chk("Fix(r) = V(a2,a4) = M_r, a NEW codim-2 component inside E_V",
    fixIdeal(r1,R1) == ideal(a2,a4) and isSubset(EV1, ideal(a2,a4)));
chk("Fix(V4) = V(a2,a3,a4) = the section S_z = P~_z n E_V, still codim 3",
    (fixIdeal(z1,R1)+fixIdeal(s1,R1)) == ideal(a2,a3,a4));
chk("G_{E_V} = 1 : neither z nor s acts trivially on R1/(a2), so E_V is DISCARDED",
    (z1 a3) + a3 == 0 and (s1 a3) + a3 == 0);
chk("M_s n P~_z = S_z, and S_z is a Cartier divisor on the smooth surface M_s",
    (ideal(a2,a3) + ideal(a3,a4)) == ideal(a2,a3,a4));
chk("M_s n M_r = S_z as well (so blowing up P~_z separates them)",
    (ideal(a2,a3) + ideal(a2,a4)) == ideal(a2,a3,a4));

<< endl << "--- after T2 (blow up P~_z), chart m4 ---" << endl;
Ez  = ideal(b4);
EV2 = saturate(ideal psi2 gens EV1, Ez);
Ms2 = saturate(ideal psi2 gens ideal(a2,a3), Ez);
chk("strict transform of E_V is V(b2)", EV2 == ideal(b2));
chk("strict transform of M_s is V(b2,b3) =: M~_s", Ms2 == ideal(b2,b3));
chk("M~_s is smooth irreducible of codim 2", codim Ms2 == 2 and isPrime Ms2);
chk("Fix(z) = V(b4) = E_z is now a DIVISOR, so G_{E_z} is nontrivial",
    fixIdeal(z2,R2) == Ez and codim Ez == 1);
chk("G_{E_z} = <z> : z acts trivially on R2/(b4), s does not",
    (z2 b2) - b2 == 0 and (z2 b3) - b3 == 0 and (s2 b3) + b3 == 0);
chk("Fix(s) = V(b2,b3) = M~_s, still codim 2", fixIdeal(s2,R2) == Ms2);
chk("C' := M~_s n E_z is irreducible of codim 3 (a curve =~ ell_V)",
    isPrime(Ms2+Ez) and codim(Ms2+Ez) == 3);
chk("Fix(V4) = C', still codim 3 -- no corner yet",
    (fixIdeal(z2,R2)+fixIdeal(s2,R2)) == (Ms2+Ez));

<< endl << "--- after T3 (blow up M~_s), chart k ---" << endl;
Es  = ideal(c2);
Ez3 = saturate(ideal psi3 gens Ez,  Es);
EV3 = saturate(ideal psi3 gens EV2, Es);
chk("strict transform of E_z is V(c4) =: E~_z", Ez3 == ideal(c4));
chk("strict transform of E_V is V(c3)", EV3 == ideal(c3));
chk("Fix(s) = V(c2) = E_s is now a DIVISOR", fixIdeal(s3,R3) == Es);
chk("Fix(z) = V(c4) = E~_z is a DIVISOR", fixIdeal(z3,R3) == Ez3);
chk("Fix(r) = V(c2,c4) has codim 2", fixIdeal(r3,R3) == ideal(c2,c4));

corner = Es + Ez3;
<< endl << "--- THE CORNER ---" << endl;
chk("D_ij = E_s n E~_z = V(c2,c4)", corner == ideal(c2,c4));
chk("codim D_ij = 2", codim corner == 2);
chk("ideal of D_ij is PRIME", isPrime corner);
chk("Fix(V4) = D_ij : a CODIM-2 V4-FIXED LOCUS has appeared",
    (fixIdeal(z3,R3)+fixIdeal(s3,R3)) == corner and codim corner == 2);

trivOn = (f, I) -> all(gens R3, x -> (f x - x) % I == 0);
chk("G_{E_s}  = <s>", trivOn(s3,Es) and not trivOn(z3,Es) and not trivOn(r3,Es));
chk("G_{E~_z} = <z>", trivOn(z3,Ez3) and not trivOn(s3,Ez3) and not trivOn(r3,Ez3));
chk("G_{D_ij} = V4 -- NON-CYCLIC -- so D_ij is FABULOUS by Duncan thm:pairs",
    trivOn(z3,corner) and trivOn(s3,corner) and trivOn(r3,corner));
chk("G_{E_V} = 1 (E_V stays discarded after T3)",
    not trivOn(z3,EV3) and not trivOn(s3,EV3) and not trivOn(r3,EV3));

<< endl << "--- Duncan def:toroidal, checked locally at the corner ---" << endl;
nt = intersect(fixIdeal(z3,R3), fixIdeal(s3,R3), fixIdeal(r3,R3));
chk("(b) local X_nt = V(c2*c4) is exactly the boundary divisor E_s u E~_z",
    nt == ideal(c2*c4));
chk("(c) V4 acts faithfully on the conormal (c2,c4)/(c2,c4)^2: "
    | "z fixes c2 and negates c4, s negates c2 and fixes c4, r negates both",
    (z3 c2) - c2 == 0 and (z3 c4) + c4 == 0 and
    (s3 c2) + c2 == 0 and (s3 c4) - c4 == 0 and
    (r3 c2) + c2 == 0 and (r3 c4) + c4 == 0);
chk("the two normal characters are DISTINCT and NONTRIVIAL (they generate V4^)",
    (z3 c2) - c2 == 0 and (s3 c2) + c2 == 0 and
    (z3 c4) + c4 == 0 and (s3 c4) - c4 == 0);

<< endl << "--- fibration of the corner over ell_V ---" << endl;
fibre = corner + ideal(c1);
chk("the fibre of D_ij over a point of ell_V (c1 = const) is an irreducible line",
    isPrime fibre and codim fibre == 3);
Rc = R3/corner;
chk("coordinate ring of D_ij is QQ[c1,c3] : dim 2 (D_ij -> ell_V has 1-dim fibres)",
    dim Rc == 2);

<< endl;
if errCount == 0 then (<< "W1_CORNER_CHARTS_OK" << endl) else (<< "W1_CORNER_CHARTS_FAIL (" << errCount << " failures)" << endl);
