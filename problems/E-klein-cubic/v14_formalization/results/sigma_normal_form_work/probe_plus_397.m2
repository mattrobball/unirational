kk=ZZ/397;
R=kk[x0,x1,x2,x3,x4,x5];
I=ideal(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
Is=saturate(I, ideal vars R);
<< "dim " << dim Is << " deg " << degree Is << endl;
<< "hp " << toString hilbertPolynomial(Is, Projective=>false) << endl;
<< "gens " << toString mingens Is << endl;
-- try to recognize Veronese
S=kk[X,Y,Z];
-- use betti
<< "betti " << betti res Is << endl;
