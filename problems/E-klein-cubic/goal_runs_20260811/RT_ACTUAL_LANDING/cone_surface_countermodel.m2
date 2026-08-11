-- Countermodel to "S normal => IH^1(S,Q)=0".
-- X' : x0^3+x1^3+x2^3+x3^2*x4+x4^3 = 0  in P^4.
S = QQ[x_0..x_4];
Fp = x_0^3 + x_1^3 + x_2^3 + x_3^2*x_4 + x_4^3;
irr = ideal(x_0,x_1,x_2,x_3,x_4);
jac = ideal jacobian ideal Fp;
sing = saturate(jac + ideal Fp, irr);
print "singular locus of X' (should be unit ideal => X' smooth):";
print sing;
print("X' is smooth: " | toString(sing == ideal(1_S)));
print("X' is irreducible cubic: " | toString(isPrime ideal Fp));
-- the hyperplane section x_4 = 0
T = QQ[y_0..y_3];
psi = map(T, S, {y_0,y_1,y_2,y_3,0});
Fs = psi Fp;
print("hyperplane section x_4=0 of X' :  " | toString Fs);
irrT = ideal(y_0,y_1,y_2,y_3);
singS = saturate(ideal jacobian ideal Fs + ideal Fs, irrT);
print "singular locus of the surface S = {x_4=0} cap X' in P^3:";
print singS;
print("dim (affine cone) of Sing(S) = " | toString dim singS);
print("degree of Sing(S) = " | toString degree singS);
print("S is irreducible and reduced: " | toString(isPrime ideal Fs));
-- the plane cubic that S is a cone over
U = QQ[z_0..z_2];
Fc = z_0^3 + z_1^3 + z_2^3;
singC = saturate(ideal jacobian ideal Fc + ideal Fc, ideal(z_0,z_1,z_2));
print("the base plane cubic z0^3+z1^3+z2^3 is smooth: " | toString(singC == ideal(1_U)));
