# Subgroup conjugacy layer for G = PSL(2,11), order 660.
# Invoke with absolute path:
#   /opt/homebrew/Caskroom/miniforge/base/bin/gap -q certificates/strata/group_subgroups.g

LoadPackage("AtlasRep");;
LoadPackage("CTblLib");;

G := PSL(2,11);;
Assert(0, Size(G) = 660);;

ccs := ConjugacyClassesSubgroups(G);;
Print("NUM_SUBGROUP_CLASSES=", Length(ccs), "\n");;
Print("GROUP_ORDER=", Size(G), "\n");;

# Element order class sizes
elcl := ConjugacyClasses(G);;
Print("NUM_ELEMENT_CLASSES=", Length(elcl), "\n");;
for c in elcl do
  g := Representative(c);
  Print("ELCLASS order=", Order(g), " size=", Size(c), "\n");
od;

# Summarize each subgroup conjugacy class
for i in [1..Length(ccs)] do
  c := ccs[i];
  H := Representative(c);
  nH := Size(H);
  nN := Size(Normalizer(G, H));
  ncl := Size(c);  # = |G|/|N_G(H)|
  orders := Collected(List(Elements(H), Order));
  # Identify by order and structure
  id := IdGroup(H);
  Print("SUBCLASS idx=", i,
        " order=", nH,
        " count=", ncl,
        " normalizer_order=", nN,
        " IdGroup=", id,
        " element_orders=", orders,
        "\n");
od;

# Explicit regression targets from the work order
Print("--- REGRESSION ---\n");;
# C2
c2s := Filtered(ccs, c -> Size(Representative(c)) = 2);;
Print("C2_classes=", Length(c2s), " counts=", List(c2s, Size), "\n");;
# V4 = C2xC2
v4s := Filtered(ccs, c -> Size(Representative(c)) = 4 and IdGroup(Representative(c)) = [4,2]);;
Print("V4_classes=", Length(v4s), " counts=", List(v4s, Size), "\n");;
# C3
c3s := Filtered(ccs, c -> Size(Representative(c)) = 3);;
Print("C3_classes=", Length(c3s), " counts=", List(c3s, Size), "\n");;
# C5
c5s := Filtered(ccs, c -> Size(Representative(c)) = 5);;
Print("C5_classes=", Length(c5s), " counts=", List(c5s, Size), "\n");;
# C11
c11s := Filtered(ccs, c -> Size(Representative(c)) = 11);;
Print("C11_classes=", Length(c11s), " counts=", List(c11s, Size), "\n");;
# A4
a4s := Filtered(ccs, c -> Size(Representative(c)) = 12 and IdGroup(Representative(c)) = [12,3]);;
Print("A4_classes=", Length(a4s), " counts=", List(a4s, Size), "\n");;
# D10 = D5 order 10
d10s := Filtered(ccs, c -> Size(Representative(c)) = 10);;
Print("D10_classes=", Length(d10s), " counts=", List(d10s, Size), "\n");;
# D12
d12s := Filtered(ccs, c -> Size(Representative(c)) = 12 and IdGroup(Representative(c)) = [12,4]);;
Print("D12_classes=", Length(d12s), " counts=", List(d12s, Size), "\n");;
# A5
a5s := Filtered(ccs, c -> Size(Representative(c)) = 60);;
Print("A5_classes=", Length(a5s), " counts=", List(a5s, Size), "\n");;
# 11:5
f55s := Filtered(ccs, c -> Size(Representative(c)) = 55);;
Print("11:5_classes=", Length(f55s), " counts=", List(f55s, Size), "\n");;

Print("GROUP_SUBGROUPS_OK\n");;
QUIT;;
