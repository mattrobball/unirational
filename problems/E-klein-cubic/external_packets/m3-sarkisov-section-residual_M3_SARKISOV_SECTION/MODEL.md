# Canonical M3 model

The canonical graph, divisor, and section conventions are in
[`FIBRATION_MODEL.md`](FIBRATION_MODEL.md).  The executable coefficient model
is reconstructed by [`produce_section_search.py`](produce_section_search.py)
from the pinned exact Schur/Weil representation formulas; its two-prime
outputs are serialized in [`section_search_payload.json`](section_search_payload.json).

The load-bearing equations are

\[
Y=\{\Phi(a)=0,\ a_3t-a_4s=0\}
\subset\mathbf P^4_K\times\mathbf P^1_K,
\]

and, for a nonexceptional section of \(H\)-degree \(d\),

\[
a_i=A_i(s,t)\ (i=0,1,2),\qquad a_3=sU,\qquad a_4=tU,
\qquad \Phi(A_0,A_1,A_2,sU,tU)=0.
\]

Exceptional sections are the separate \(H\)-degree-zero component
\(C_{012}\); they are not represented by imposing \(U\ne0\).
