kk = ZZ/397;
R = kk[x0,x1,x2];
I = saturate ideal(137*x0*x0+268*x0*x1+126*x0*x2+107*x1*x1+117*x1*x2+276*x2*x2, 101*x0*x0+125*x0*x1+344*x0*x2+278*x1*x1+101*x1*x2+96*x2*x2, 112*x0*x0+200*x0*x1+314*x0*x2+178*x1*x1+387*x1*x2+21*x2*x2, 293*x0*x0+45*x0*x1+15*x0*x2+209*x1*x1+117*x1*x2+79*x2*x2, 342*x0*x0+88*x0*x1+343*x0*x2+191*x1*x1+233*x1*x2+247*x2*x2, 173*x0*x0+361*x0*x1+259*x0*x2+271*x1*x1+125*x1*x2+136*x2*x2, 357*x0*x0+388*x0*x1+213*x0*x2+318*x1*x1+100*x1*x2+49*x2*x2, 280*x0*x0+316*x0*x1+334*x0*x2+108*x1*x1+63*x1*x2+39*x2*x2, 271*x0*x0+396*x0*x1+96*x0*x2+371*x1*x1+380*x1*x2+368*x2*x2, 151*x0*x0+83*x0*x1+106*x0*x2+326*x1*x1+275*x1*x2+40*x2*x2, 121*x0*x0+102*x0*x1+342*x0*x2+277*x1*x1+316*x1*x2+106*x2*x2, 108*x0*x0+146*x0*x1+214*x0*x2+79*x1*x1+262*x1*x2+14*x2*x2, 356*x0*x0+346*x0*x1+238*x0*x2+351*x1*x1+162*x1*x2+321*x2*x2, 27*x0*x0+77*x0*x1+367*x0*x2+205*x1*x1+12*x1*x2+93*x2*x2, 348*x0*x0+323*x0*x1+77*x0*x2+376*x1*x1+13*x1*x2+141*x2*x2);
if I == ideal(1_R) then print("C3:34 EMPTY") else (
  cs = minimalPrimes I;
  print("C3:34 dim " | toString(dim I - 1) | " degree " | toString degree I | " ncomp " | toString(#cs));
  for c in cs do print("C3:34   comp dim " | toString(dim c - 1) | " degree " | toString degree c | " genus " | toString(if dim c == 2 then genus c else -999));
);
