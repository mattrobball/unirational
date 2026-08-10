kk = ZZ/397;
R = kk[xx,yy];
I = ideal(xx*yy-1);
G = gb I; g = flatten entries gens G;
isunit = (#g == 1 and (first g) == 1_R);
<< "ctrlNONUNIT M2 unit=" << isunit << endl;
