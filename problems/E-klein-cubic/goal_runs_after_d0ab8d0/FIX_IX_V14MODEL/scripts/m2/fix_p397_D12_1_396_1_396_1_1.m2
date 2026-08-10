kk = ZZ/397;
R = kk[x0];
I = saturate ideal(246*x0*x0, 21*x0*x0, 135*x0*x0, 296*x0*x0, 387*x0*x0, 11*x0*x0, 286*x0*x0, 223*x0*x0, 109*x0*x0, 309*x0*x0, 311*x0*x0, 82*x0*x0, 335*x0*x0, 192*x0*x0, 396*x0*x0);
if I == ideal(1_R) then print("D12:1.396.1.396.1.1 EMPTY") else (
  cs = minimalPrimes I;
  print("D12:1.396.1.396.1.1 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("D12:1.396.1.396.1.1   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
