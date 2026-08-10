kk = ZZ/397;
R = kk[x0];
I = saturate ideal(256*x0*x0, 211*x0*x0, 19*x0*x0, 49*x0*x0, 169*x0*x0, 297*x0*x0, 200*x0*x0, 310*x0*x0, 104*x0*x0, 115*x0*x0, 162*x0*x0, 67*x0*x0, 348*x0*x0, 208*x0*x0, 202*x0*x0);
if I == ideal(1_R) then print("D12:1.1.34.34.362.140 EMPTY") else (
  cs = minimalPrimes I;
  print("D12:1.1.34.34.362.140 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("D12:1.1.34.34.362.140   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
