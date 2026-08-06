-- FIX-VII-GATE Stage 4: the Hessian curve C = Sing(det Hess F) of the Klein cubic.
pp = 67;
R = ZZ/pp[x0,x1,x2,x3,x4];
F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0;
Hess = diff(transpose vars R, diff(vars R, F));
H = det Hess;
JH = ideal jacobian ideal H;
IC = saturate(ideal(H) + JH);
out = openOut "/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_ac61998/FIX_VII_GATE/results/IC_p67.txt";
out << "p " << pp << endl;
out << "degH " << (first degree H) << endl;
out << "dimProj " << (dim IC - 1) << endl;
out << "degree " << (degree IC) << endl;
out << "hilbPoly " << toString(hilbertPolynomial(R^1/IC, Projective => false)) << endl;
for d from 0 to 36 do out << "HF " << d << " " << (hilbertFunction(d, R^1/IC)) << endl;
G = flatten entries mingens IC;
out << "ngens " << (#G) << endl;
for g in G do out << "gendeg " << (first degree g) << endl;
for g in G do out << "gen " << toString(g) << endl;
out << "Hpoly " << toString(H) << endl;
out << "END" << endl;
close out;
exit 0
