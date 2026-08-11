"""CHECK 1 -- the single fact that carries prop:noncyclic_fabulous (Duncan 4.3):

    "Since H is not cyclic, no character of H is injective."   (tex line 802-803)
    "a non-cyclic abelian group has no faithful character"      (tex line 909-910)

Exhaustive verification over every finite abelian group of order <= 100 with at
most 3 cyclic factors: H admits an injective character  <=>  H is cyclic.

The proof in the tex is one line (the image of a character is a finite subgroup
of C^*, hence cyclic), so this is a sanity check of the statement, not a
substitute for the argument.  It also checks the derived statement actually used
in the tex: the subgroup ker(psi_B) of H acting trivially on a component B is
non-trivial whenever H is non-cyclic, for EVERY character psi_B.
"""

import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from abelian import all_groups, elements, is_injective, is_cyclic, kernel, order

def main():
    bad = []
    tested = 0
    for n in all_groups(100, max_factors=3):
        chars = elements(n)
        has_inj = any(is_injective(c, n) for c in chars)
        cyc = is_cyclic(n)
        tested += 1
        if has_inj != cyc:
            bad.append((n, has_inj, cyc))
        # the form actually used: non-cyclic => EVERY character has non-trivial kernel
        if not cyc:
            for c in chars:
                if len(kernel(c, n)) == 1:
                    bad.append(("witness", n, c))
    print(f"groups tested (order <= 100, <= 3 cyclic factors): {tested}")
    print(f"failures of  [exists injective character  <=>  cyclic]: {len(bad)}")
    for b in bad:
        print("  FAIL", b)

    # the two groups the tex names explicitly
    for n, label in [((6,), "Z/6  (ex:not_a_complex, G_{D_12})"),
                     ((6, 2), "Z/6 x Z/2  (ex:not_a_complex, G_{D_123})"),
                     ((2, 2), "V4  (the PSL(2,11) corner group)"),
                     ((6,), "Z/6  (ex:no_converse, G_{D_12})"),
                     ((2, 3, 3), "Z/2 x (Z/3)^2  (ex:no_converse, G_{D_13})"),
                     ((2, 2, 3), "(Z/2)^2 x Z/3  (ex:no_converse, G_{D_23})")]:
        inj = [c for c in elements(n) if is_injective(c, n)]
        print(f"  {label:44s} order {order(n):3d}  cyclic={is_cyclic(n)!s:5s} "
              f"#injective characters = {len(inj)}")

    print("RESULT:", "PASS" if not bad else "FAIL")
    return 0 if not bad else 1


if __name__ == "__main__":
    sys.exit(main())
