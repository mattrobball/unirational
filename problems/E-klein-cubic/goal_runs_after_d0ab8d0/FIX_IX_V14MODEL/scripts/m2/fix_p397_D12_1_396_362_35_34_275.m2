kk = ZZ/397;
R = kk[x0];
I = saturate ideal(361*x0*x0, 106*x0*x0, 274*x0*x0, 135*x0*x0, 307*x0*x0, 300*x0*x0, 119*x0*x0, 351*x0*x0, 181*x0*x0, 272*x0*x0, 207*x0*x0, 176*x0*x0, 153*x0*x0, 212*x0*x0, 58*x0*x0);
if I == ideal(1_R) then print("D12:1.396.362.35.34.275 EMPTY") else (
  cs = minimalPrimes I;
  print("D12:1.396.362.35.34.275 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("D12:1.396.362.35.34.275   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
