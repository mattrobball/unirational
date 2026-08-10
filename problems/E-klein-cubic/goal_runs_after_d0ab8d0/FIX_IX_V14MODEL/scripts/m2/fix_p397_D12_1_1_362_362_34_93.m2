kk = ZZ/397;
R = kk[x0];
I = saturate ideal(18*x0*x0, 238*x0*x0, 348*x0*x0, 341*x0*x0, 330*x0*x0, 43*x0*x0, 340*x0*x0, 78*x0*x0, 185*x0*x0, 323*x0*x0, 356*x0*x0, 133*x0*x0, 141*x0*x0, 3*x0*x0, 143*x0*x0);
if I == ideal(1_R) then print("D12:1.1.362.362.34.93 EMPTY") else (
  cs = minimalPrimes I;
  print("D12:1.1.362.362.34.93 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("D12:1.1.362.362.34.93   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
