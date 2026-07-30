# WP-H1 character screen for the Klein cubic Hodge-center necessity theorem.
#
# Absolute-path invocation (bare `gap` is aliased to `git apply` in this environment):
#   /opt/homebrew/Caskroom/miniforge/base/bin/gap -q certificates/hodge_centers/character_screen.g
#
# Reads nothing from the producer of other work packages.  Writes:
#   certificates/hodge_centers/character_screen.json
# (self-hash is filled by the Python sealing step in verify.py / seal helper).
#
# Mathematical content:
#   G = PSL(2,11) acting on the Klein cubic X subset P(W), W 5-dimensional.
#   H^{2,1}(X) ≅ R_1(F) ≅ W^* as G-representations (Griffiths residue; Jacobian
#   ring of the cubic).  Character of W is Irr(G)[2]; of W^* is Irr(G)[3].
#   For every subgroup type H in the exact strata table, decompose
#   H^{2,1}|_H and record Hom_H(H^{2,1}|_H, rho) for every irrep rho of H.
#   For each surviving (H, rho), bound the minimal genus of a curve centre
#   carrying rho in H^{1,0} via Riemann-Hurwitz + holomorphic Lefschetz
#   (Chevalley-Weil character of H^{1,0}).

LoadPackage("CTblLib");;
LoadPackage("AtlasRep");;

Assert(0, TestPackageAvailability("CTblLib", false) <> fail);
Assert(0, TestPackageAvailability("AtlasRep", false) <> fail);

G := PSL(2, 11);;
Assert(0, Size(G) = 660);;
ctG := CharacterTable(G);;
irrG := Irr(ctG);;

# --- Identify the two 5-dimensional irreps ---------------------------------
# Character table class order: 1a, 11a, 11b, 2a, 3a, 6a, 5a, 5b
# Irr[2] values on 11a = A = E(11)+E(11)^3+E(11)^4+E(11)^5+E(11)^9 = b11
# Irr[3] is the Galois conjugate (dual of Irr[2] over C).
#
# From certificates/exact_weil_check.py the ambient W has
#   tr(T) = sum_{j in QR} zeta_11^j = A
# on a fixed order-11 element T, so chi_W = Irr[2] and chi_{W^*} = Irr[3].
# Jacobian ring R_1 = S_1 = W^* as G-modules, so chi_{H^{2,1}} = Irr[3].

chiW := irrG[2];;
chiWstar := irrG[3];;
Assert(0, Degree(chiW) = 5);
Assert(0, Degree(chiWstar) = 5);
Assert(0, chiW[1] = 5);
Assert(0, chiW[4] = 1);   # involution class 2a
Assert(0, chiW[5] = -1);  # order-3 class 3a

chiH21 := chiWstar;;  # H^{2,1}(X) ≅ W^*

# --- Subgroup types from the exact strata table ----------------------------
# Counts: C2=55, V4=55, C3=55, C5=66, C11=12, A4=55 (ONE class),
#         D10=66, D12=55, A5 two classes of 11, 11:5=12.
# Also include S3 and C6 (appear as residual/normalizer quotients and as
# pointwise stabilizers of C6 points / residual actions).

ccs := ConjugacyClassesSubgroups(G);;

# Exact strata table subgroup types (certificates/strata/strata_exact.json),
# plus residual/normalizer types S3, C6, 11:5 that appear in the geometry.
# Multi-class types: S3 (two classes of 55), A5 (two classes of 11).
StratumTypes := [
  rec(label := "C2",  id := [2, 1],  expected_count := 55,  multi := false),
  rec(label := "C3",  id := [3, 1],  expected_count := 55,  multi := false),
  rec(label := "V4",  id := [4, 2],  expected_count := 55,  multi := false),
  rec(label := "C5",  id := [5, 1],  expected_count := 66,  multi := false),
  rec(label := "S3",  id := [6, 1],  expected_count := 110, multi := true),
  rec(label := "C6",  id := [6, 2],  expected_count := 55,  multi := false),
  rec(label := "D10", id := [10, 1], expected_count := 66,  multi := false),
  rec(label := "C11", id := [11, 1], expected_count := 12,  multi := false),
  rec(label := "A4",  id := [12, 3], expected_count := 55,  multi := false),
  rec(label := "D12", id := [12, 4], expected_count := 55,  multi := false),
  rec(label := "11:5", id := [55, 1], expected_count := 12, multi := false),
  rec(label := "A5",  id := [60, 5], expected_count := 22,  multi := true)
];;

# Collect representatives; split multi-class types into labelled classes.
TypeReps := [];;
for st in StratumTypes do
  matches := Filtered(ccs, c -> IdGroup(Representative(c)) = st.id);
  Assert(0, Length(matches) >= 1);
  total := Sum(matches, Size);
  Assert(0, total = st.expected_count);
  if st.multi then
    for j in [1 .. Length(matches)] do
      Add(TypeReps, rec(
        label := Concatenation(st.label, "_class_", String(j)),
        id := st.id,
        count := Size(matches[j]),
        H := Representative(matches[j]),
        conjugacy_index := j
      ));
    od;
  else
    Assert(0, Length(matches) = 1);
    Add(TypeReps, rec(
      label := st.label,
      id := st.id,
      count := Size(matches[1]),
      H := Representative(matches[1]),
      conjugacy_index := 1
    ));
  fi;
od;

# --- Riemann-Hurwitz genus (exact rationals) -------------------------------
RHGenus := function(n, gamma, mlist)
  local s, m;
  s := 2 * gamma - 2;
  for m in mlist do
    s := s + (1 - 1 / m);
  od;
  return 1 + n * s / 2;
end;;

# --- Fixed-point count and holomorphic Lefschetz trace on H^{1,0} ----------
# For h ≠ 1 and generating vector gens of orders mlist (gamma may be > 0;
# free part contributes no fixed points):
#   fix(h) = |C_H(h)| * sum_{i,k: h ~ gens[i]^k} 1/m_i
#   tr(h | H^{1,0}) = 1 - sum_p 1/(1 - ξ_p)
# with ξ_p = E(m_i)^k when h ~ gens[i]^k.
# Identity: tr = genus.

TraceH10 := function(H, h, gens, mlist, genus)
  local sum_inv, i, k, m, xi, Cord;
  if h = One(H) then
    return genus;
  fi;
  Cord := Size(Centralizer(H, h));
  sum_inv := 0;
  for i in [1 .. Length(gens)] do
    m := mlist[i];
    for k in [1 .. m - 1] do
      if IsConjugate(H, h, gens[i]^k) then
        xi := E(m)^k;
        # contribution of Cord/m fixed points each with this xi
        sum_inv := sum_inv + (Cord / m) / (1 - xi);
      fi;
    od;
  od;
  return 1 - sum_inv;
end;;

# Character of H^{1,0} as class function, then multiplicity of each irrep.
MultiplicitiesH10 := function(H, ctH, gens, mlist, genus)
  local elts, traces, chi, dec, k, sp, vals, ccl, rep, t;
  ccl := ConjugacyClasses(H);
  vals := [];
  for rep in List(ccl, Representative) do
    t := TraceH10(H, rep, gens, mlist, genus);
    # traces are algebraic numbers; force cyclotomic
    Add(vals, t);
  od;
  chi := Character(ctH, vals);
  # Numerical safety: genus check
  if vals[1] <> genus then
    Error("identity trace != genus");
  fi;
  dec := MatScalarProducts(ctH, Irr(ctH), [chi])[1];
  # Round near-integers (floating cyclotomic noise should be zero here;
  # all inputs cyclotomic so ScalarProduct is exact in cyclotomics).
  return dec;
end;;

# Search generating vectors of a given order list (gamma = 0 case).
FindGeneratingVector := function(H, mlist)
  local r, elts_by_ord, tries, vec, prod, i;
  r := Length(mlist);
  if r = 0 then
    return fail;  # free actions handled separately
  fi;
  elts_by_ord := List(mlist, m -> Filtered(Elements(H), g -> Order(g) = m));
  if ForAny(elts_by_ord, x -> Length(x) = 0) then
    return fail;
  fi;
  for tries in [1 .. 40000] do
    vec := List([1 .. r], i -> Random(elts_by_ord[i]));
    prod := Product(vec);
    if prod = One(H) and Size(Group(vec)) = Size(H) then
      return vec;
    fi;
  od;
  return fail;
end;;

# For gamma >= 1 free (or lightly ramified) actions: H^{1,0} contains the
# pullback of H^{1,0}(quotient) as the trivial isotypic component, and more.
# Free gamma = 1: only abelian H can act freely on an elliptic curve
# (by translations); then g = 1 and H^{1,0} = triv.
# Free gamma = 2: 2g-2 = |H|*2 => g = |H|+1; H^{1,0} contains at least
# the regular representation minus adjustments — use Lefschetz with no
# ramification: Fix(h)=0 for h≠1, so tr(h)=1 for h≠1, tr(1)=g.
# Then m_ρ = (1/|H|)(g d_ρ + 1*sum_{h≠1} conj(χ(h)))
#          = (1/|H|)(g d_ρ + |H|⟨1,ρ⟩ - d_ρ)
#          = d_ρ (g/|H| - 1/|H|) + ⟨1,ρ⟩
# with g = |H|+1: m_ρ = d_ρ (1 + 1/|H| - 1/|H|) + ⟨1,ρ⟩? 
# g/|H| = 1 + 1/|H|; m_ρ = d_ρ(1 + 1/|H| - 1/|H|) + ⟨1,ρ⟩ wait:
# m_ρ = d_ρ (g - 1)/|H| + ⟨1,ρ⟩ = d_ρ (|H|)/|H| + ⟨1,ρ⟩ = d_ρ + ⟨1,ρ⟩.
# So free gamma=2: every irrep appears with mult = deg(rho) + delta(triv).
# In particular every rho appears for free genus-|H|+1 actions when such exist.
# Existence of free action: H embeds into a surface group mapping class /
# for gamma=2 the fundamental group is generated by 4 elements with one
# relation; every finite group is a quotient of some surface group of
# sufficiently large gamma.  For gamma=2, not every group works, but every
# finite group acts freely on some surface of genus g = 1 + |H|(γ-1) for
# large enough γ (residual finiteness / high genus).  Conservative:
# use gamma_free such that 2g-2 = |H|(2 gamma_free - 2) with gamma_free
# large enough that every finite group is a quotient of Pi_1 of a genus-
# gamma_free surface.  Practical bound used below: gamma = 1 + d(H) where
# d = minimal number of generators, which always works for free actions
# of sufficiently high genus (we take g = 1 + |H| * d(H) as a safe free
# upper envelope and also search ramified signatures for tighter bounds).

SafeFreeGenus := function(H)
  local d, n, gamma;
  n := Size(H);
  d := Maximum(2, Length(MinimalGeneratingSet(H)));  # at least 2
  # free action with gamma = d is always possible for large enough models;
  # RH: 2g-2 = n(2d-2) => g = 1 + n(d-1)
  return 1 + n * (d - 1);
end;;

# Multiplicities for free action of genus g (Fix=0 for h≠1, tr=1).
MultiplicitiesFree := function(H, ctH, genus)
  local ccl, vals, rep, chi, dec;
  ccl := ConjugacyClasses(H);
  vals := [];
  for rep in List(ccl, Representative) do
    if rep = One(H) then
      Add(vals, genus);
    else
      Add(vals, 1);  # Fix=0 => tr = 1 - 0 = 1
    fi;
  od;
  chi := Character(ctH, vals);
  dec := MatScalarProducts(ctH, Irr(ctH), [chi])[1];
  return dec;
end;;

# Candidate ramified signatures (gamma = 0, small period lists).
CandidateMlists := function(H)
  local oset, out, m1, m2, m3, m4, n, g, r, mlist, i;
  n := Size(H);
  oset := Filtered(Set(List(Elements(H), Order)), x -> x > 1);
  out := [];
  for m1 in oset do for m2 in oset do for m3 in oset do
    g := RHGenus(n, 0, [m1, m2, m3]);
    if IsInt(g) and g >= 0 and g <= 120 then
      Add(out, [0, [m1, m2, m3], Int(g)]);
    fi;
  od; od; od;
  for m1 in oset do for m2 in oset do for m3 in oset do for m4 in oset do
    g := RHGenus(n, 0, [m1, m2, m3, m4]);
    if IsInt(g) and g >= 1 and g <= 80 then
      Add(out, [0, [m1, m2, m3, m4], Int(g)]);
    fi;
  od; od; od; od;
  # Hyperelliptic-type: r copies of order 2 (only for small H; search cost).
  if 2 in oset and n <= 12 then
    for r in [5 .. 12] do
      mlist := List([1 .. r], i -> 2);
      g := RHGenus(n, 0, mlist);
      if IsInt(g) and g >= 1 and g <= 40 then
        Add(out, [0, mlist, Int(g)]);
      fi;
    od;
  fi;
  # Pure cyclic covers: r copies of order n for cyclic H = C_n.
  if IsCyclic(H) and n > 1 then
    for r in [3 .. 8] do
      mlist := List([1 .. r], i -> n);
      g := RHGenus(n, 0, mlist);
      if IsInt(g) and g >= 1 and g <= 100 then
        Add(out, [0, mlist, Int(g)]);
      fi;
    od;
  fi;
  # gamma = 1 with 0,1,2 periods
  g := RHGenus(n, 1, []);
  if IsInt(g) and g >= 0 then Add(out, [1, [], Int(g)]); fi;
  for m1 in oset do
    g := RHGenus(n, 1, [m1]);
    if IsInt(g) and g >= 0 and g <= 80 then Add(out, [1, [m1], Int(g)]); fi;
    for m2 in oset do
      g := RHGenus(n, 1, [m1, m2]);
      if IsInt(g) and g >= 0 and g <= 80 then
        Add(out, [1, [m1, m2], Int(g)]);
      fi;
    od;
  od;
  return Set(out);
end;;

# For abelian H, free gamma=1 action on an elliptic curve (translations):
# g=1, H^{1,0} = triv only.
EllipticTranslationMults := function(H, ctH)
  local dec, k;
  dec := List([1 .. NrConjugacyClasses(ctH)], k -> 0);
  # triv is always Irr[1] for character tables of abelian groups in GAP
  # but find by degree 1 and all values 1
  for k in [1 .. NrConjugacyClasses(ctH)] do
    if ForAll(ValuesOfClassFunction(Irr(ctH)[k]), x -> x = 1) then
      dec[k] := 1;
    fi;
  od;
  return dec;
end;;

# Search min genus for each irrep of H.
MinGenusPerIrrep := function(H)
  local ctH, nirr, min_g, min_sig, k, cands, cand, gamma, mlist, genus,
        gens, mults, n, safe, mults_safe, ab, irr;
  ctH := CharacterTable(H);
  nirr := NrConjugacyClasses(ctH);
  min_g := List([1 .. nirr], k -> infinity);
  min_sig := List([1 .. nirr], k -> rec());
  n := Size(H);
  ab := IsAbelian(H);

  # (1) elliptic translations for abelian groups (triv in H^{1,0})
  if ab then
    mults := EllipticTranslationMults(H, ctH);
    for k in [1 .. nirr] do
      if mults[k] > 0 and 1 < min_g[k] then
        min_g[k] := 1;
        min_sig[k] := rec(gamma := 1, periods := [], genus := 1,
                          model := "elliptic_translation");
      fi;
    od;
  fi;

  # (1b) elliptic curves with extra automorphisms: Aut(E,0) in {C2,C4,C6}.
  # Order-2 [-1] acts as sign = -1 on H^{1,0}.
  # Order-3/4/6 (j=0 or j=1728) act by primitive roots on H^{1,0}.
  if IsCyclic(H) and n in [2, 3, 4, 6] then
    for k in [1 .. nirr] do
      irr := Irr(ctH)[k];
      # nontrivial linear character that can arise as the action on dz
      if Degree(irr) = 1 and not ForAll(ValuesOfClassFunction(irr), x -> x = 1) then
        # For C2: the sign character; for C3: either primitive; for C6: faithful chars
        if 1 < min_g[k] then
          min_g[k] := 1;
          min_sig[k] := rec(gamma := 0, periods := [], genus := 1,
                            model := "elliptic_extra_automorphism");
        fi;
      fi;
    od;
  fi;

  # (2) ramified / low-gamma signatures with generating vectors
  cands := CandidateMlists(H);
  for cand in cands do
    gamma := cand[1];
    mlist := cand[2];
    genus := cand[3];
    if genus < 0 then continue; fi;
    if gamma = 0 or Length(mlist) > 0 then
      if Length(mlist) = 0 then
        # free gamma=1: only abelian (already handled); skip nonabelian free γ=1
        if gamma = 1 and ab then
          mults := EllipticTranslationMults(H, ctH);
        else
          continue;
        fi;
      else
        gens := FindGeneratingVector(H, mlist);
        if gens = fail then continue; fi;
        mults := MultiplicitiesH10(H, ctH, gens, mlist, genus);
      fi;
    else
      continue;
    fi;
    for k in [1 .. nirr] do
      # multiplicities are cyclotomic integers; compare to 0 exactly
      if mults[k] <> 0 and genus < min_g[k] then
        min_g[k] := genus;
        min_sig[k] := rec(gamma := gamma, periods := mlist, genus := genus,
                          model := "rh_signature");
      fi;
    od;
  od;

  # (3) safe free high-genus envelope: every irrep appears
  safe := SafeFreeGenus(H);
  mults_safe := MultiplicitiesFree(H, ctH, safe);
  for k in [1 .. nirr] do
    if mults_safe[k] <> 0 and safe < min_g[k] then
      min_g[k] := safe;
      min_sig[k] := rec(gamma := Maximum(2, Length(MinimalGeneratingSet(H))),
                        periods := [], genus := safe,
                        model := "safe_free_surface");
    fi;
  od;

  # Absolute floor: g >= deg(rho)
  for k in [1 .. nirr] do
    if min_g[k] < Degree(Irr(ctH)[k]) then
      min_g[k] := Degree(Irr(ctH)[k]);
    fi;
    if min_g[k] = infinity then
      # should not happen after safe free
      min_g[k] := safe;
      min_sig[k] := rec(model := "fallback_safe_free", genus := safe);
    fi;
  od;

  return rec(min_g := min_g, min_sig := min_sig, ctH := ctH);
end;;

# --- Main screen -----------------------------------------------------------
ScreenRows := [];;
SurvivingPairs := [];;

for tr in TypeReps do
  H := tr.H;
  ctH := CharacterTable(H);
  fus := FusionConjugacyClasses(H, G);
  Assert(0, fus <> fail);
  nH := Size(H);
  index := 660 / nH;
  Assert(0, index * nH = 660);

  # Restrict H^{2,1} = chiH21
  vals := List([1 .. NrConjugacyClasses(ctH)], j -> chiH21[fus[j]]);
  rest := Character(ctH, vals);
  dec := List(MatScalarProducts(ctH, Irr(ctH), [rest])[1], Int);

  # Also record restriction of W for cross-check
  valsW := List([1 .. NrConjugacyClasses(ctH)], j -> chiW[fus[j]]);
  restW := Character(ctH, valsW);
  decW := List(MatScalarProducts(ctH, Irr(ctH), [restW])[1], Int);

  genus_data := MinGenusPerIrrep(H);

  rho_rows := [];
  for k in [1 .. Length(dec)] do
    mult := dec[k];
    if IsCyc(mult) then
      mult := Int(mult);  # exact integer multiplicity
    fi;
    irr := Irr(ctH)[k];
    deg := Degree(irr);
    cv := ValuesOfClassFunction(irr);
    # stringify character values
    cv_str := List(cv, v -> String(v));
    entry := rec(
      rho_index := k,
      degree := deg,
      character_values := cv_str,
      hom_dim := mult,   # dim Hom_H(H^{2,1}|_H, rho) = multiplicity
      appears_in_H21 := (mult <> 0)
    );
    if mult <> 0 then
      mg := genus_data.min_g[k];
      if mg = infinity then
        mg := SafeFreeGenus(H);
      fi;
      ms := genus_data.min_sig[k];
      if not IsBound(ms.model) then
        ms := rec(model := "unspecified", genus := mg, periods := [], gamma := -1);
      fi;
      entry.min_genus := mg;
      entry.min_genus_model := ms;
      # Orbit of centres: [G : H] (H = setwise stabiliser hypothesis)
      entry.orbit_size := index;
      # Minimum base-locus contribution as a 1-cycle degree lower bound:
      # a genus-g curve in P^4 has degree δ >= 1; Castelnuovo / plane model
      # gives δ(δ-1)/2 >= g for plane curves, so δ >= ceil((1+sqrt(1+8g))/2).
      # Use this plane-degree lower bound as a uniform, characteristic-zero
      # lower envelope (non-plane curves can have smaller degree for large g
      # in P^4, so also record the absolute δ >= 1 floor separately).
      # Castelnuovo-type safe lower bound for nondegenerate curves in P^3
      # already allows degree ~ sqrt(g); in P^4 even lower.  Absolute floor:
      # any positive-genus curve has degree >= 1; any genus-1 curve in P^4
      # has degree >= 3 (elliptic normal curves start at deg 3 in P^2).
      # Record both the orbit count and g * orbit as cohomological weight.
      if mg = 0 then
        plane_deg_floor := 0;
      elif mg = 1 then
        plane_deg_floor := 3;  # plane cubic
      else
        # smallest d with (d-1)(d-2)/2 >= mg
        plane_deg_floor := 2;
        while (plane_deg_floor - 1) * (plane_deg_floor - 2) / 2 < mg do
          plane_deg_floor := plane_deg_floor + 1;
        od;
      fi;
      entry.plane_degree_floor := plane_deg_floor;
      entry.min_orbit_degree_plane_model := index * plane_deg_floor;
      entry.min_cohomological_weight := index * mg;  # total g in the orbit
      entry.notes := "surviving: Hom_H(H^{2,1}|_H, rho) > 0";
      Add(SurvivingPairs, rec(
        H_label := tr.label,
        H_order := nH,
        H_id := tr.id,
        H_count := tr.count,
        orbit_size := index,
        rho_index := k,
        rho_degree := deg,
        rho_character_values := cv_str,
        hom_dim := mult,
        min_genus := mg,
        plane_degree_floor := plane_deg_floor,
        min_orbit_degree_plane_model := index * plane_deg_floor,
        min_cohomological_weight := index * mg
      ));
    else
      entry.min_genus := fail;
      entry.notes := "Hom = 0; cannot supply this rho from an H-centre";
    fi;
    Add(rho_rows, entry);
  od;

  Add(ScreenRows, rec(
    H_label := tr.label,
    H_id := tr.id,
    H_order := nH,
    H_count := tr.count,
    orbit_size_if_setwise_stab := index,
    conjugacy_index := tr.conjugacy_index,
    restriction_H21_multiplicities := dec,
    restriction_W_multiplicities := decW,
    irreps := rho_rows
  ));
od;

# --- Jacobian ring / Hodge numbers (recorded as certified constants) -------
# dim R_d for Klein cubic Jacobian ring (M2-verified in the markdown):
# R_0=1, R_1=5, R_2=10, R_3=10, R_4=5, R_5=1, R_d=0 for d>5.
# H^{2,1} ≅ R_1 (dim 5), H^{1,2} ≅ R_4 (dim 5).

JacobianRing := rec(
  ambient_equation := "sum_{i in Z/5} x_i^2 x_{i+1} = 0",
  graded_dims := [1, 5, 10, 10, 5, 1],
  H21_iso := "R_1 ≅ W^*",
  H21_dimension := 5,
  H21_character_irr_index := 3,
  H21_character_values := List(ValuesOfClassFunction(chiH21), v -> String(v)),
  W_character_irr_index := 2,
  W_character_values := List(ValuesOfClassFunction(chiW), v -> String(v)),
  conjugacy_class_orders := List(ConjugacyClasses(G),
    c -> Order(Representative(c))),
  note := "chi_W = Irr(G)[2] matched to exact Weil matrices (tr T = A on 11a); H^{2,1} ≅ W^* = Irr(G)[3]"
);;

# --- Intersection budget sketch --------------------------------------------
# A primitive homogeneous landing self-covariant of degree d gives a rational
# map P^4 --> X of degree d.  Base locus of the five degree-d forms must
# accommodate every exceptional centre.  A crude numerical budget used in
# the write-up:
#   - total cohomological weight sum_orbits |O| * g(C) >= 5
#     (to fill dim H^{2,1} = 5), with G-representation matching;
#   - plane-model degree sum |O| * δ_plane(g) is a lower envelope on the
#     degree of the 1-dimensional part of the base locus;
#   - any invariant of degree d vanishing on a curve of degree δ needs d
#     large enough relative to the ideal of that curve.
# No numerical contradiction is claimed here without a complete centre
# inventory; the screen only forces nonlinear positive-genus centres.

IntersectionBudget := rec(
  H21_dimension := 5,
  min_total_cohomological_weight := 5,
  statement := Concatenation(
    "Any equivariant resolution must realise H^{2,1}(X) inside the sum of ",
    "H^{1,0}(centres)(-1). Linear strata and points contribute 0. ",
    "Surviving (H,rho) pairs below are the only curve-centre channels ",
    "compatible with the character of H^{2,1}."
  ),
  numerical_contradiction_found := false,
  numerical_contradiction_note :=
    "No budget violation certified: high-genus / large-orbit centres can in principle supply the five-dimensional representation. Necessary condition only."
);;

# --- Emit a line-oriented dump; Python assembles sealed JSON ----------------
# Format (ASCII, one record per block):
#   META key=value
#   H21 key=value
#   SUBGROUP begin label=... order=... count=... index=...
#   RHO index=... deg=... mult=... char=v1|v2|...
#   SURVIVE ... (only when mult>0) min_genus=... plane_deg=... ...
#   SUBGROUP end
#   PAIR ... (flat surviving pairs)
#   END

dumpfile := "tmp/wp_h1_hodge/character_screen.dump";;
Exec("mkdir -p tmp/wp_h1_hodge");;
stream := OutputTextFile(dumpfile, false);;
SetPrintFormattingStatus(stream, false);;

AppendTo(stream, "META work_package=WP-H1\n");
AppendTo(stream, "META headline=OPEN\n");
AppendTo(stream, "META gap_version=", GAPInfo.Version, "\n");
AppendTo(stream, "META ctbllib=", InstalledPackageVersion("ctbllib"), "\n");
AppendTo(stream, "META atlasrep=", InstalledPackageVersion("atlasrep"), "\n");
AppendTo(stream, "META group_order=660\n");
AppendTo(stream, "META num_element_classes=8\n");

AppendTo(stream, "H21 dim=5\n");
AppendTo(stream, "H21 iso=R_1=W_dual\n");
AppendTo(stream, "H21 irr_index=3\n");
AppendTo(stream, "H21 char=",
  JoinStringsWithSeparator(List(ValuesOfClassFunction(chiH21), String), "|"),
  "\n");
AppendTo(stream, "W irr_index=2\n");
AppendTo(stream, "W char=",
  JoinStringsWithSeparator(List(ValuesOfClassFunction(chiW), String), "|"),
  "\n");
AppendTo(stream, "W class_orders=",
  JoinStringsWithSeparator(List(ConjugacyClasses(G),
    c -> String(Order(Representative(c)))), "|"),
  "\n");
AppendTo(stream, "JACOBIAN dims=1|5|10|10|5|1\n");

for row in ScreenRows do
  AppendTo(stream, "SUBGROUP begin label=", row.H_label,
    " id=", JoinStringsWithSeparator(List(row.H_id, String), ","),
    " order=", row.H_order,
    " count=", row.H_count,
    " orbit=", row.orbit_size_if_setwise_stab,
    " conj_index=", row.conjugacy_index, "\n");
  AppendTo(stream, "SUBGROUP H21_mult=",
    JoinStringsWithSeparator(List(row.restriction_H21_multiplicities, String), "|"),
    "\n");
  AppendTo(stream, "SUBGROUP W_mult=",
    JoinStringsWithSeparator(List(row.restriction_W_multiplicities, String), "|"),
    "\n");
  for e in row.irreps do
    AppendTo(stream, "RHO index=", e.rho_index,
      " deg=", e.degree,
      " mult=", e.hom_dim,
      " char=", JoinStringsWithSeparator(e.character_values, "|"));
    if e.appears_in_H21 then
      AppendTo(stream,
        " min_genus=", e.min_genus,
        " plane_deg=", e.plane_degree_floor,
        " orbit_deg=", e.min_orbit_degree_plane_model,
        " coh_weight=", e.min_cohomological_weight,
        " model=", e.min_genus_model.model);
      if IsBound(e.min_genus_model.periods) then
        AppendTo(stream, " periods=",
          JoinStringsWithSeparator(List(e.min_genus_model.periods, String), ","));
      fi;
      if IsBound(e.min_genus_model.gamma) then
        AppendTo(stream, " gamma=", e.min_genus_model.gamma);
      fi;
    fi;
    AppendTo(stream, "\n");
  od;
  AppendTo(stream, "SUBGROUP end\n");
od;

for p in SurvivingPairs do
  AppendTo(stream, "PAIR label=", p.H_label,
    " order=", p.H_order,
    " id=", JoinStringsWithSeparator(List(p.H_id, String), ","),
    " count=", p.H_count,
    " orbit=", p.orbit_size,
    " rho=", p.rho_index,
    " rho_deg=", p.rho_degree,
    " mult=", p.hom_dim,
    " char=", JoinStringsWithSeparator(p.rho_character_values, "|"),
    " min_genus=", p.min_genus,
    " plane_deg=", p.plane_degree_floor,
    " orbit_deg=", p.min_orbit_degree_plane_model,
    " coh_weight=", p.min_cohomological_weight, "\n");
od;

AppendTo(stream, "BUDGET H21_dim=5 min_coh_weight=5 contradiction=false\n");
AppendTo(stream, "END\n");
CloseStream(stream);;

Print("WROTE ", dumpfile, "\n");;
Print("SURVIVING_PAIRS=", Length(SurvivingPairs), "\n");;
Print("WP_H1_CHARACTER_SCREEN_OK\n");;
QUIT;;
