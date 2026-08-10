R = ZZ/199[s,t,u]
F = 29*s^3+24*s^2*t^1+168*s^1*t^2+149*s^1*u^2+32*t^3+19*t^1*u^2
J = ideal jacobian ideal F
<< "SMOOTH " << (dim J <= 0) << " codimJ " << codim J << endl
exit 0
