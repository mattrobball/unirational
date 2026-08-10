kk = ZZ/397;
R = kk[y0,y1,y2,y3,y4,y5,y6,y7,y8,y9];
I = ideal(
  1*y0*y7+396*y1*y5+198*y2*y3,
  198*y0*y2+396*y1*y6+198*y3*y3,
  1*y0*y8+198*y1*y1+198*y3*y4,
  199*y0*y4+396*y2*y6+1*y3*y5,
  198*y0*y0+198*y1*y2+1*y4*y5,
  1*y0*y9+198*y1*y3+1*y4*y6,
  199*y1*y4+199*y2*y2+1*y3*y7,
  198*y0*y1+396*y2*y8+1*y4*y7,
  1*y1*y9+198*y2*y4+396*y3*y8,
  199*y0*y3+1*y2*y9+199*y4*y4,
  199*y2*y5+99*y3*y4+1*y6*y7,
  298*y0*y3+199*y1*y7+396*y5*y8,
  99*y1*y2+198*y3*y9+396*y6*y8,
  199*y0*y6+298*y1*y4+1*y5*y9,
  99*y0*y2+199*y4*y8+1*y7*y9);
print("dim_affine_cone " | toString dim I);
print("codim " | toString codim I);
print("degree " | toString degree I);
print("saturated " | toString (I == saturate I));
print("primdec_count " | toString (# minimalPrimes I));
print("hilbert " | toString ((hilbertPolynomial(I, Projective=>false))));
