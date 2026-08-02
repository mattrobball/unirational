#!/usr/bin/env python3
"""Build bounded/local-reduction variants of the existing exact p=13 probe.

The large polynomial payload stays byte-for-byte inherited from the pinned
probe.  Only the three terminal normal-form calls are changed, so each
variant tests a documented Singular local-reduction mode independently.
"""

from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = (
    HERE.parents[1]
    / "goals_2026-08-01"
    / "Q_SCHUR_DESCENT"
    / "parallel"
    / "selected_local_membership_next"
    / "singular_local_membership_p13.sing"
)


def main() -> None:
    source = SOURCE.read_text()
    for mode in (1, 2, 4, 8, 10):
        changed = source
        for name in ("P0", "Pu0", "PZ0"):
            changed = changed.replace(
                f"reduce({name},G);", f"reduce({name},G,{mode});"
            )
        target = HERE / f"local_reduce_mode_{mode}.sing"
        target.write_text(changed)
        print(target)

    before_reductions = source.split("poly rP=reduce(P0,G);", 1)[0]
    print_basis = before_reductions + 'print("LOCAL_BASIS="); print(G); quit;\n'
    basis_target = HERE / "local_print_basis.sing"
    basis_target.write_text(print_basis)
    print(basis_target)

    facstd_body = before_reductions + r'''
print("START_FACSTD");
list L=facstd(J);
print("FACSTD_DONE"); print(size(L));
int ii;
for (ii=1; ii<=size(L); ii++)
{
  print("FACSTD_COMPONENT"); print(ii); print(size(L[ii])); print(L[ii]);
}
quit;
'''
    facstd_target = HERE / "local_facstd.sing"
    facstd_target.write_text(facstd_body)
    print(facstd_target)


if __name__ == "__main__":
    main()
