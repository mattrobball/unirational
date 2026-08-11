R = ZZ/661[y_0..y_9];
I = ideal(2*y_0*y_7+659*y_1*y_5+660*y_2*y_3,
660*y_0*y_2+659*y_1*y_6+660*y_3*y_3,
2*y_0*y_8+660*y_1*y_1+660*y_3*y_4,
1*y_0*y_4+659*y_2*y_6+2*y_3*y_5,
660*y_0*y_0+660*y_1*y_2+2*y_4*y_5,
2*y_0*y_9+660*y_1*y_3+2*y_4*y_6,
1*y_1*y_4+1*y_2*y_2+2*y_3*y_7,
660*y_0*y_1+659*y_2*y_8+2*y_4*y_7,
2*y_1*y_9+660*y_2*y_4+659*y_3*y_8,
1*y_0*y_3+2*y_2*y_9+1*y_4*y_4,
1*y_2*y_5+330*y_3*y_4+2*y_6*y_7,
331*y_0*y_3+1*y_1*y_7+659*y_5*y_8,
330*y_1*y_2+660*y_3*y_9+659*y_6*y_8,
1*y_0*y_6+331*y_1*y_4+2*y_5*y_9,
330*y_0*y_2+1*y_4*y_8+2*y_7*y_9);
<< "codim " << codim I << endl;
<< "dim " << dim I << endl;
<< "degree " << degree I << endl;
<< "mingens " << numgens trim I << endl;
<< "hf " << toString apply(toList(0..6), d -> hilbertFunction(d, R/I)) << endl;
exit 0
