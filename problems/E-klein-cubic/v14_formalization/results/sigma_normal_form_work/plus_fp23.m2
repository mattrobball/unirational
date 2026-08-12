kk=ZZ/23;
R=kk[x0,x1,x2,x3,x4,x5];
I=ideal(1*x0*x0+20*x1*x4+14*x1*x5+22*x2*x2+9*x2*x3+5*x2*x4+9*x2*x5+13*x3*x3+15*x3*x4+13*x3*x5+18*x4*x4+12*x4*x5+11*x5*x5,1*x0*x1+12*x1*x4+2*x1*x5+1*x2*x2+4*x2*x3+18*x2*x4+6*x2*x5+15*x3*x3+19*x3*x4+18*x3*x5+5*x4*x4+16*x4*x5+19*x5*x5,1*x0*x2+4*x1*x4+3*x1*x5+22*x2*x2+18*x2*x3+7*x2*x4+3*x2*x5+11*x3*x3+12*x3*x4+21*x3*x5+4*x4*x4+10*x4*x5+18*x5*x5,1*x0*x3+17*x1*x4+10*x1*x5+2*x2*x2+21*x2*x3+14*x2*x4+6*x3*x3+2*x3*x4+3*x3*x5+1*x4*x4+1*x4*x5+3*x5*x5,1*x0*x4+18*x1*x4+11*x1*x5+6*x2*x2+21*x2*x3+10*x2*x4+12*x2*x5+2*x3*x3+22*x3*x4+16*x3*x5+13*x4*x4+1*x4*x5+10*x5*x5,1*x0*x5+15*x1*x4+6*x1*x5+15*x2*x2+8*x2*x3+14*x2*x4+14*x2*x5+3*x3*x3+13*x3*x4+20*x3*x5+16*x4*x4+4*x4*x5+4*x5*x5,1*x1*x1+13*x1*x4+11*x1*x5+4*x2*x2+8*x2*x4+16*x2*x5+10*x3*x3+5*x3*x4+17*x3*x5+13*x4*x4+7*x4*x5+20*x5*x5,1*x1*x2+3*x1*x4+9*x1*x5+1*x2*x2+14*x2*x3+18*x2*x4+14*x2*x5+10*x3*x3+8*x3*x4+10*x3*x5+5*x4*x4+9*x4*x5+12*x5*x5,1*x1*x3+12*x1*x4+16*x1*x5+11*x2*x2+3*x2*x3+4*x2*x4+20*x3*x3+1*x3*x4+3*x3*x5+20*x4*x4+20*x4*x5+14*x5*x5);
Is=saturate(I, ideal vars R);
<< "dim " << dim Is << " deg " << degree Is << " hp " << toString hilbertPolynomial(Is, Projective=>false) << endl;
-- points via decompose in affine chart x0=1
A=kk[x1,x2,x3,x4,x5];
f = map(A,R,{1_A,x1,x2,x3,x4,x5});
Ia = f Is;
<< "affine dim " << dim Ia << " deg " << degree Ia << endl;
G = gens gb Ia;
<< "gb " << toString G << endl;
