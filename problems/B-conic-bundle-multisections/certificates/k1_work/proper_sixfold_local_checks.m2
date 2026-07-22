-- Exact local checks supporting proper_sixfold_theorem.md.
-- These are small determinant-contact ideals, not a finite-field witness for A.

kk = ZZ/32003;

convCoeff = (L,M,k) -> sum(
    select(0..k, i -> i < #L and k-i < #M),
    i -> L#i * M#(k-i)
    );

-- Degree pattern (5,4,3), determinant order at least 6.
R543 = kk[a_0..a_5,b_0..b_4,c_0..c_3,MonomialOrder=>GRevLex];
aa = {a_0,a_1,a_2,a_3,a_4,a_5};
bb = {b_0,b_1,b_2,b_3,b_4};
cc = {c_0,c_1,c_2,c_3};
I543 = ideal apply(0..5, j -> convCoeff(aa,cc,j)-convCoeff(bb,bb,j));
assert(codim I543 == 6);
print "V_(5,4,3), order 6: codimension 6";

-- The zero-constant fiber in the same degree pattern.
R543z = kk[az_1..az_5,bz_1..bz_4,cz_1..cz_3,MonomialOrder=>GRevLex];
aaz = {0_R543z,az_1,az_2,az_3,az_4,az_5};
bbz = {0_R543z,bz_1,bz_2,bz_3,bz_4};
ccz = {0_R543z,cz_1,cz_2,cz_3};
I543z = ideal apply(2..5, j -> convCoeff(aaz,ccz,j)-convCoeff(bbz,bbz,j));
assert(codim I543z == 4);
print "V_(5,4,3), order 6 over q(0)=0: tail codimension 4";

-- Three cubic entries, determinant order at least 6.
R333 = kk[d_0..d_3,e_0..e_3,f_0..f_3,MonomialOrder=>GRevLex];
dlist = {d_0,d_1,d_2,d_3};
elist = {e_0,e_1,e_2,e_3};
flist = {f_0,f_1,f_2,f_3};
I333 = ideal apply(0..5, j -> convCoeff(dlist,flist,j)-convCoeff(elist,elist,j));
assert(codim I333 == 6);
print "V_(3,3,3), order 6: codimension 6";

-- Its zero-constant fiber.
R333z = kk[dz_1..dz_3,ez_1..ez_3,fz_1..fz_3,MonomialOrder=>GRevLex];
dzlist = {0_R333z,dz_1,dz_2,dz_3};
ezlist = {0_R333z,ez_1,ez_2,ez_3};
fzlist = {0_R333z,fz_1,fz_2,fz_3};
I333z = ideal apply(2..5, j -> convCoeff(dzlist,fzlist,j)-convCoeff(ezlist,ezlist,j));
assert(codim I333z == 4);
print "V_(3,3,3), order 6 over q(0)=0: tail codimension 4";

-- Order 4 after fixing one diagonal constant to zero.
R4z = kk[g_0..g_3,h_0..h_3,k_1..k_3,MonomialOrder=>GRevLex];
glist = {g_0,g_1,g_2,g_3};
hlist = {h_0,h_1,h_2,h_3};
klist0 = {0_R4z,k_1,k_2,k_3};
I4z = ideal apply(0..3, j -> convCoeff(glist,klist0,j)-convCoeff(hlist,hlist,j));
assert(codim I4z == 4);
print "V_(3,3,3), order 4 with one diagonal constant zero: codimension 4";

print "all local determinant-contact checks passed";
