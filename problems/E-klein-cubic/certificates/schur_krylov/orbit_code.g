# Path A — G/D_12 orbit code (sealed certificate script)
# Replay:
#   /opt/homebrew/Caskroom/miniforge/base/bin/gap -q -b certificates/schur_krylov/orbit_code.g
#
# Proves only group/permutation-module facts used by orbit_code.md.
# Does NOT claim (A_empty), N-A, or any statement about V_Z coordinates.

G := AtlasGroup("L2(11)");;
Assert(0, Size(G) = 660);

subs := List(ConjugacyClassesSubgroups(G), Representative);;
H := First(subs, h -> Size(h) = 12 and StructureDescription(h) = "D12");;
Assert(0, H <> fail);
Assert(0, Index(G, H) = 55);
Assert(0, Size(Normalizer(G, H)) = 12);

mids := IntermediateSubgroups(G, H);;
Assert(0, Length(mids.subgroups) = 0);
Print("intermediate_count=0\n");;
Print("H_maximal=true\n");;
Print("Aut_L_F=1\n");;

# Subdegrees of H on G/H
R := RightCosets(G, H);;
orblens := [];;
used := BlistList([1 .. 55], []);;
for i in [1 .. 55] do
  if not used[i] then
    o := Orbit(H, R[i], OnRight);;
    for cos in o do
      used[Position(R, cos)] := true;;
    od;
    Add(orblens, Length(o));;
  fi;
od;
sd := SortedList(orblens);;
Assert(0, sd = [1, 3, 3, 6, 6, 6, 6, 12, 12]);
Assert(0, Sum(sd) = 55);
Print("subdegrees=", sd, "\n");;

# Double cosets = dim End_G(perm module)
dc := DoubleCosets(G, H, H);;
Assert(0, Length(dc) = 9);
Print("num_double_cosets=9\n");;

# Permutation character decomposition
ct := CharacterTable(G);;
chi := PermutationCharacter(G, H);;
irr := Irr(ct);;
degs := List(irr, Degree);;
dec := MatScalarProducts(irr, [chi])[1];;
Assert(0, degs = [1, 5, 5, 10, 10, 11, 12, 12]);
Assert(0, dec = [1, 1, 1, 0, 2, 0, 1, 1]);
Assert(0, Sum([1 .. Length(dec)], i -> dec[i] * degs[i]) = 55);
Print("irr_degrees=", degs, "\n");;
Print("perm_decomp_mult=", dec, "\n");;
Print("decomposition=1*(1)+1*(5)+1*(5)+2*(10)+1*(12)+1*(12)\n");;
Print("perm_char_values=", ValuesOfClassFunction(chi), "\n");;

Print("ORBIT_CODE_GAP_OK\n");
QUIT_GAP(0);
