/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.RingTheory.Ideal.Maps
public import Mathlib.RingTheory.Ideal.Maximal

/-!
# Descending a principal prime ideal along a quotient

The complete-intersection calculation used by the residual argument repeatedly has the following
elementary shape.  A surjective coefficient map kills one equation `q`; after applying the map,
the other equation `p` generates a prime ideal.  Then `(p,q)` was already prime.  Keeping this
as a small ring-theoretic lemma avoids rebuilding an isomorphism between two iterated quotients.
-/

@[expose] public section

namespace BConicBundleMultisections

universe u

/-- If a surjective ring map has kernel `(q)` and the image of `p` generates a prime ideal, then
the two-generator ideal `(p,q)` is prime. -/
theorem isPrime_span_pair_of_surjective
    {R S : Type u} [CommRing R] [CommRing S]
    (f : R →+* S) (hf : Function.Surjective f) (p q : R)
    (hker : RingHom.ker f = Ideal.span {q})
    (hp : (Ideal.span {f p}).IsPrime) :
    (Ideal.span {p, q}).IsPrime := by
  have hmap : Ideal.map f (Ideal.span {p}) = Ideal.span {f p} := by
    rw [Ideal.map_span]
    simp
  have hcomap : Ideal.comap f (Ideal.span {f p}) = Ideal.span {p, q} := by
    rw [← hmap, Ideal.comap_map_of_surjective f hf, ← RingHom.ker_eq_comap_bot, hker,
      ← Ideal.span_union]
    congr 1
  rw [← hcomap]
  exact hp.comap f

end BConicBundleMultisections
