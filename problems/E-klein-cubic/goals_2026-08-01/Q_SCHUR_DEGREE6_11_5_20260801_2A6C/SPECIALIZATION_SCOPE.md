# Specialization and theorem scope

Let `L_0` be the character-zero degree-six landing scheme in the projective
space of the 19 coefficient variables.  Its 640 coefficient equations have
integer coefficients.  The 128 equations in each msolve input are an exact
row-space basis of those 640 cubics over the indicated finite field, so they
define the same special fibre.

The prime 23 is prime to 55 and satisfies `23=1 mod 11`.  It therefore splits
the order-eleven eigenbasis used to construct `L_0`; no fifth root is needed
for character zero.  If `L_0(Fbar_23)` is empty, properness of the projective
coefficient scheme implies that its characteristic-zero generic fibre is
empty.  Indeed, the image of a proper morphism is closed, so a nonempty
generic fibre would force every fibre of this integral projective model to be
nonempty.

Over a characteristic-zero field containing a fifth root of unity, the
invertible diagonal change proved in `DEGREE6_CHARACTER_ISOMORPHISM.md`
identifies every character-`k` scheme with `L_0`.  Thus one empty
character-zero fibre at 23 proves the complete all-character degree-six
exclusion.  The independent prime 331 is a split-55 cross-check, not a logical
necessity once the diagonal isomorphism is installed.

The strict theorem boundary is finite degree: even a successful calculation
proves only that all five `11:5` projective-character landing schemes are
empty in degree six (and, combined with the sealed predecessor, in degrees
one through six).  It is not an all-degree theorem, not pointlessness of the
generic `11:5` twist, and not a point or pointlessness decision for the
genuine Schur twist.
