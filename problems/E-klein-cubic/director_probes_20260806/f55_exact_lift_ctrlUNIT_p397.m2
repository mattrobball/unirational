kk = ZZ/397;
R = kk[xx,yy];
I = ideal(xx-1,xx);
G = gb I; g = flatten entries gens G;
isunit = (#g == 1 and (first g) == 1_R);
<< "ctrlUNIT M2 unit=" << isunit << endl;
