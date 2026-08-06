R = QQ[a,b,c];
I = ideal(a*b*c);          -- V(I) = union of 3 coordinate planes
stdio << "I:(a,b)^inf   = " << toString saturate(I, {a,b}) << endl;
stdio << "I:(a*b)^inf   = " << toString saturate(I, a*b) << endl;
stdio << "I:a^inf       = " << toString saturate(I, a) << endl;
exit 0
