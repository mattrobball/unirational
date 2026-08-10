kk = ZZ/199;
R = kk[y0,y1,y2,y3,y4,y5,y6,y7,y8,y9];
I = ideal(
  1*y0*y7+198*y1*y5+99*y2*y3,
  99*y0*y2+198*y1*y6+99*y3*y3,
  1*y0*y8+99*y1*y1+99*y3*y4,
  100*y0*y4+198*y2*y6+1*y3*y5,
  99*y0*y0+99*y1*y2+1*y4*y5,
  1*y0*y9+99*y1*y3+1*y4*y6,
  100*y1*y4+100*y2*y2+1*y3*y7,
  99*y0*y1+198*y2*y8+1*y4*y7,
  1*y1*y9+99*y2*y4+198*y3*y8,
  100*y0*y3+1*y2*y9+100*y4*y4,
  100*y2*y5+149*y3*y4+1*y6*y7,
  50*y0*y3+100*y1*y7+198*y5*y8,
  149*y1*y2+99*y3*y9+198*y6*y8,
  100*y0*y6+50*y1*y4+1*y5*y9,
  149*y0*y2+100*y4*y8+1*y7*y9);
print("dim_affine_cone " | toString dim I);
print("codim " | toString codim I);
print("degree " | toString degree I);
print("saturated " | toString (I == saturate I));
print("primdec_count " | toString (# minimalPrimes I));
print("hilbert " | toString ((hilbertPolynomial(I, Projective=>false))));
