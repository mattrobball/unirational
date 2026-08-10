kk = ZZ/397;
R = kk[x0,x1];
I = saturate ideal(259*x0*x0+151*x0*x1+286*x1*x1, 297*x0*x0+106*x0*x1+69*x1*x1, 128*x0*x0+241*x0*x1+100*x1*x1, 45*x0*x0+231*x0*x1+365*x1*x1, 23*x0*x0+194*x0*x1+162*x1*x1, 208*x0*x0+278*x0*x1+339*x1*x1, 264*x0*x0+158*x0*x1+71*x1*x1, 155*x0*x0+138*x0*x1+152*x1*x1, 58*x0*x0+255*x0*x1+134*x1*x1, 261*x0*x0+229*x0*x1+337*x1*x1, 147*x0*x0+203*x0*x1+157*x1*x1, 388*x0*x0+161*x0*x1+132*x1*x1, 9*x0*x0+285*x0*x1+88*x1*x1, 131*x0*x0+122*x0*x1+235*x1*x1, 260*x0*x0+77*x0*x1+338*x1*x1);
if I == ideal(1_R) then print("V4:396.1 EMPTY") else (
  cs = minimalPrimes I;
  print("V4:396.1 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("V4:396.1   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
