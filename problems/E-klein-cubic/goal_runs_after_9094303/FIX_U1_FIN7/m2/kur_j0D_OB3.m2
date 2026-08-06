R = ZZ/100057[c0,c1,c2,c3,c4];
I = ideal(
);
print("dim (affine cone) = "|toString dim I);
print("proj dim = "|toString(dim I - 1));
print("degree = "|toString degree I);
print("minimal primes:");
scan(minimalPrimes I, P -> print(toString(dim P)|"  "|toString P));
exit 0
