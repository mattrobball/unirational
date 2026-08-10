R = ZZ/67[s,t,u]
F = 32*s^3+41*s^2*t^1+60*s^1*t^2+57*s^1*u^2+38*t^3+22*t^1*u^2
J = ideal jacobian ideal F
<< "SMOOTH " << (dim J <= 0) << " codimJ " << codim J << endl
exit 0
