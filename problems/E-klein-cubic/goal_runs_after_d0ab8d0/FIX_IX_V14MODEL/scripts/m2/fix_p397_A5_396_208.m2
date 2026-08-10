kk = ZZ/397;
R = kk[x0];
I = saturate ideal(305*x0*x0, 121*x0*x0, 122*x0*x0, 350*x0*x0, 341*x0*x0, 89*x0*x0, 395*x0*x0, 199*x0*x0, 42*x0*x0, 392*x0*x0, 331*x0*x0, 345*x0*x0, 188*x0*x0, 238*x0*x0, 279*x0*x0);
if I == ideal(1_R) then print("A5:396.208 EMPTY") else (
  cs = minimalPrimes I;
  print("A5:396.208 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("A5:396.208   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
