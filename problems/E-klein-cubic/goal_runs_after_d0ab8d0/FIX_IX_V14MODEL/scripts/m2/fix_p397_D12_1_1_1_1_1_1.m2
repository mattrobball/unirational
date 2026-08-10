kk = ZZ/397;
R = kk[x0,x1];
I = saturate ideal(122*x0*x0+156*x0*x1+253*x1*x1, 69*x0*x0+300*x0*x1+225*x1*x1, 388*x0*x0+346*x0*x1+285*x1*x1, 279*x0*x0+47*x0*x1+118*x1*x1, 261*x0*x0+299*x0*x1+271*x1*x1, 262*x0*x0+30*x0*x1+265*x1*x1, 81*x0*x0+6*x0*x1+158*x1*x1, 152*x0*x0+243*x0*x1+202*x1*x1, 336*x0*x0+73*x0*x1+307*x1*x1, 51*x0*x0+51*x0*x1+86*x1*x1, 72*x0*x0+103*x0*x1+333*x1*x1, 233*x0*x0+299*x0*x1+385*x1*x1, 210*x0*x0+55*x0*x1+329*x1*x1, 340*x0*x0+23*x0*x1+385*x1*x1, 307*x0*x0+380*x0*x1+219*x1*x1);
if I == ideal(1_R) then print("D12:1.1.1.1.1.1 EMPTY") else (
  cs = minimalPrimes I;
  print("D12:1.1.1.1.1.1 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("D12:1.1.1.1.1.1   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
