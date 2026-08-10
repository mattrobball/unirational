kk = ZZ/397;
R = kk[x0];
I = saturate ideal(294*x0*x0, 107*x0*x0, 92*x0*x0, 79*x0*x0, 95*x0*x0, 396*x0*x0, 361*x0*x0, 351*x0*x0, 243*x0*x0, 226*x0*x0, 87*x0*x0, 363*x0*x0, 201*x0*x0, 177*x0*x0, 106*x0*x0);
if I == ideal(1_R) then print("A5:1.76 EMPTY") else (
  cs = minimalPrimes I;
  print("A5:1.76 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("A5:1.76   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
