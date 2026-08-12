kk=ZZ/23;
R=kk[x0,x1,x2,x3,x4,x5];
I=ideal(1*x0^2+20*x1*x4+14*x1*x5+22*x2^2+9*x2*x3+5*x2*x4+9*x2*x5+13*x3^2+15*x3*x4+13*x3*x5+18*x4^2+12*x4*x5+11*x5^2,1*x0*x1+12*x1*x4+2*x1*x5+1*x2^2+4*x2*x3+18*x2*x4+6*x2*x5+15*x3^2+19*x3*x4+18*x3*x5+5*x4^2+16*x4*x5+19*x5^2,1*x0*x2+4*x1*x4+3*x1*x5+22*x2^2+18*x2*x3+7*x2*x4+3*x2*x5+11*x3^2+12*x3*x4+21*x3*x5+4*x4^2+10*x4*x5+18*x5^2,1*x0*x3+17*x1*x4+10*x1*x5+2*x2^2+21*x2*x3+14*x2*x4+6*x3^2+2*x3*x4+3*x3*x5+1*x4^2+1*x4*x5+3*x5^2,1*x0*x4+18*x1*x4+11*x1*x5+6*x2^2+21*x2*x3+10*x2*x4+12*x2*x5+2*x3^2+22*x3*x4+16*x3*x5+13*x4^2+1*x4*x5+10*x5^2,1*x0*x5+15*x1*x4+6*x1*x5+15*x2^2+8*x2*x3+14*x2*x4+14*x2*x5+3*x3^2+13*x3*x4+20*x3*x5+16*x4^2+4*x4*x5+4*x5^2,1*x1^2+13*x1*x4+11*x1*x5+4*x2^2+8*x2*x4+16*x2*x5+10*x3^2+5*x3*x4+17*x3*x5+13*x4^2+7*x4*x5+20*x5^2,1*x1*x2+3*x1*x4+9*x1*x5+1*x2^2+14*x2*x3+18*x2*x4+14*x2*x5+10*x3^2+8*x3*x4+10*x3*x5+5*x4^2+9*x4*x5+12*x5^2,1*x1*x3+12*x1*x4+16*x1*x5+11*x2^2+3*x2*x3+4*x2*x4+20*x3^2+1*x3*x4+3*x3*x5+20*x4^2+20*x4*x5+14*x5^2);
Is=saturate(I, ideal vars R);
-- dim of degree 2 part of saturated ideal
B2 = super basis(2, Is);
<< "dim I2 sat " << numgens source B2 << endl;
B2g = super basis(2, I);
<< "dim I2 gen " << numgens source B2g << endl;
-- Are they equal?
<< "I2 equal " << (image B2 == image B2g) << endl;
-- Try to find if Veronese surface contains the curve:
-- search 6-dim subspaces? 
-- Use known structure: elliptic normal curves of deg 6 are 2x2 minors of a 1-generic 3x3 matrix of linear forms (possibly non-symmetric!)
-- Try NON-symmetric 3x3 matrix of linear forms: 9 linear forms = 54 params
