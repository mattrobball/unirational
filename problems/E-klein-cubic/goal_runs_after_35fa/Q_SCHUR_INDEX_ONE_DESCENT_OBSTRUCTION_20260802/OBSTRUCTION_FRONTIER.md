# Exact obstruction frontier after the Q2.1 close-out

## 1. Terminal mechanism ledger

| mechanism | exact status | reason |
|---|---|---|
| index / degree gcd | exhausted | effective zero-cycles of degrees `3` and `55` give index one |
| elementary obstruction | zero | degree-one zero-cycle and descended hyperplane class |
| Picard torsor | zero | `Pic(X_bar)=Z[H]`, `H` descends, `Pic^0=0` |
| Albanese torsor | zero | `Alb(X)=0` |
| relative Brauer | zero | installed Hochschild--Serre computation |
| higher Amitsur base kernels | zero | installed computation; also transfer-annihilated |
| fixed abelian cohomology class | impossible | Theorem 2.1 |
| torus / semiabelian / abelian recipient | neutral | Theorem 2.1 plus the point-trivializing bridge |
| constant finite nonabelian recipient | neutral | Theorem 3.1 |
| geometric finite étale/fppf descent | tautological | `pi_1^et(X_bar)=1`; every finite cover is arithmetic pullback |
| covered semisimple recipient torsor | neutral | Jodi Black's degree-one zero-cycle theorem |
| ten coordinate genus-one fibrations | nondecisive | no section does not exclude points over special base points |
| universal `CH_0` failure | not a point obstruction | varieties with points may fail universal `CH_0`-triviality |
| nontrivial `R`-equivalence | not an existence obstruction | it compares existing rational points |
| bounded covariant emptiness | scoped only | does not cover arbitrary rational functions or all degrees |

## 2. Intermediate Jacobian and cycle-moduli discipline

The phrase “intermediate-Jacobian torsor obstruction” splits into two
mathematically different claims.

1. If a fixed torsor `P` under a commutative Jacobian-type group is
   neutralized over every field `L` with `X(L)` nonempty, then Theorem 2.1
   forces `P` to be neutral already over `K`.
2. A torsor parameterizing lines, conics, twisted cubics, or a prescribed
   codimension-two cycle class need not be neutralized by an arbitrary point
   of `X`.  Such a torsor can remain nontrivial, but its nontriviality alone
   is not a point obstruction until a theorem proves

   ```text
   X(L) nonempty  =>  P(L) nonempty.
   ```

Thus intermediate-Jacobian geometry remains available as a *constructive
cycle route*, but the simple claim “nontrivial commutative torsor implies
`X(K)` empty” is retired.

## 3. Exact surviving negative interfaces

A genuine negative theorem must now use at least one feature outside the
terminal ledger.

### A. Valuation/residue obstruction

The current exact local frontier is

```text
inertia = 1
residue transcendence degree >= 2
rational rank <= 3
decomposition group in {PSL(2,11), 11:5}
```

A certificate must install a named valuation of `K_Schur`, the full smooth
five-coordinate residue cubic, and a proof that this residue cubic has no
point despite index one and trivial relative Brauer group.  No such residue
nonpoint is installed.

### B. Point-dependent nonconstant evaluation

A class varying with a hypothetical point is not a fixed base-field class and
therefore is not automatically killed by Theorem 2.1.  To work, it must be
constructed on the proper genuine twist, have a proved evaluation law over
`K_Schur`, and exclude every possible rational point.  The relative Brauer
group is zero, so ordinary Brauer evaluation cannot supply it.

### C. Non-transfer or genuinely higher/nonabelian obstruction

A surviving gerbe, nonconstant-coefficient unramified class, or torsor outside
Theorems 3.1 and 5.1 must come with all of:

1. an exact class on the genuine twist;
2. a proof that every rational point neutralizes it;
3. a proof that the degree-3/55 point fields do not force neutralization by a
   valid transfer or zero-cycle theorem;
4. a computation proving the class is nontrivial.

No current repository class meets these four requirements.

## 4. Exact surviving positive interfaces

The standard obstruction package being empty increases the relative value of
constructive geometry.  The shortest exact positive gates remain:

1. solve the full five-coordinate `11:5` trace equation;
2. descend the primitive `A4/S4` quartic to degree one or two;
3. construct an actual odd-degree genus-zero stable map or a generalized
   twisted-cubic Hilbert point;
4. solve the full-Schur Palatini quartic identity;
5. produce a new exhaustive birational fibration with a section.

None is supplied by this packet.

## 5. Final verdict

The standard obstruction theory does not merely fail to find a class: broad
families of possible classes are now formally impossible.  The remaining
negative problem is therefore sharply nonstandard and is concentrated in the
valuation/residue or non-transfer interfaces above.  The binary point problem
remains open.
