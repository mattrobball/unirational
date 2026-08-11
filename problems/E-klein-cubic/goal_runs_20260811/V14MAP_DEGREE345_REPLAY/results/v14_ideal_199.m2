R = ZZ/199[y_0..y_9];
I = ideal(2*y_0*y_7+197*y_1*y_5+198*y_2*y_3,
198*y_0*y_2+197*y_1*y_6+198*y_3*y_3,
2*y_0*y_8+198*y_1*y_1+198*y_3*y_4,
1*y_0*y_4+197*y_2*y_6+2*y_3*y_5,
198*y_0*y_0+198*y_1*y_2+2*y_4*y_5,
2*y_0*y_9+198*y_1*y_3+2*y_4*y_6,
1*y_1*y_4+1*y_2*y_2+2*y_3*y_7,
198*y_0*y_1+197*y_2*y_8+2*y_4*y_7,
2*y_1*y_9+198*y_2*y_4+197*y_3*y_8,
1*y_0*y_3+2*y_2*y_9+1*y_4*y_4,
1*y_2*y_5+99*y_3*y_4+2*y_6*y_7,
100*y_0*y_3+1*y_1*y_7+197*y_5*y_8,
99*y_1*y_2+198*y_3*y_9+197*y_6*y_8,
1*y_0*y_6+100*y_1*y_4+2*y_5*y_9,
99*y_0*y_2+1*y_4*y_8+2*y_7*y_9);
<< "codim " << codim I << endl;
<< "dim " << dim I << endl;
<< "degree " << degree I << endl;
<< "mingens " << numgens trim I << endl;
<< "hf " << toString apply(toList(0..6), d -> hilbertFunction(d, R/I)) << endl;
exit 0
