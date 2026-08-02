#!/usr/bin/env python3
"""Generate exact Singular module jobs for normalized Stage C on closed L8.

At a nonzero q in L8, normalized Stage C has a solution b precisely when the
114 by 7 matrix [P4(q) | P3(q)] has column rank at most six.  If the cokernel
of the row-generated module is zero dimensional, its support is confined to
the cone vertex, so the augmented matrix has rank seven at every projective
point of L8.  We generate two term-order variants for independent replay.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
SOURCE = P25 / "syzygy_r256_q0_contracted.npz"
METADATA = HERE / "closed_L8_augmented_module_jobs.json"
P = 89
L8 = tuple(range(4, 12))
ORDERS = (("degrevlex", "dp"), ("deglex", "Dp"))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def array_sha256(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def restriction_indices(
    degree: int, global_index: dict[tuple[int, ...], int]
) -> np.ndarray:
    answer: list[int] = []
    for local in weak_compositions(degree, len(L8)):
        exponent = [0] * 37
        for variable, power in zip(L8, local):
            exponent[variable] = power
        answer.append(global_index[tuple(exponent)])
    return np.asarray(answer, dtype=np.int32)


def monomial_text(exponent: tuple[int, ...]) -> str:
    factors: list[str] = []
    for variable, power in zip(L8, exponent):
        if power == 1:
            factors.append(f"q{variable}")
        elif power > 1:
            factors.append(f"q{variable}^{power}")
    return "*".join(factors) or "1"


def polynomial_text(coefficients: np.ndarray, monomials: list[tuple[int, ...]]) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients.tolist(), monomials):
        coefficient = int(raw) % P
        if coefficient == 0:
            continue
        # Signed representatives make the generated scripts materially smaller.
        if coefficient > P // 2:
            coefficient -= P
        monomial = monomial_text(exponent)
        if monomial == "1":
            term = str(abs(coefficient))
        elif abs(coefficient) == 1:
            term = monomial
        else:
            term = f"{abs(coefficient)}*{monomial}"
        if not terms:
            terms.append(term if coefficient > 0 else f"-{term}")
        else:
            terms.append(("+" if coefficient > 0 else "-") + term)
    return "".join(terms) or "0"


def singular_script(
    label: str,
    order: str,
    restricted3: np.ndarray,
    restricted4: np.ndarray,
    monomials3: list[tuple[int, ...]],
    monomials4: list[tuple[int, ...]],
) -> str:
    vectors: list[str] = []
    for row in range(len(restricted3)):
        entries = [polynomial_text(restricted4[row], monomials4)]
        entries.extend(
            polynomial_text(restricted3[row, component], monomials3)
            for component in range(6)
        )
        vectors.append("[" + ",".join(entries) + "]")
    result = HERE / f"closed_L8_augmented_module_{label}.result"
    variables = ",".join(f"q{i}" for i in L8)
    module_body = ",\n".join(vectors)
    return f'''// Exact augmented-module support test on L8 over GF(89).
// Component 1 has degree 4 and components 2..7 have degree 3;
// the module is homogeneous for the corresponding shifted grading.
ring R={P},({variables}),{order};
option(prot);
module N=
{module_body};
print("AUGMENTED_MODULE_INPUT_GENERATORS="+string(size(N)));
module G=std(N);
int quotient_dimension=dim(G);
int quotient_vector_dimension=-1;
if (quotient_dimension==0)
{{
  quotient_vector_dimension=vdim(G);
}}
print("AUGMENTED_MODULE_GB_GENERATORS="+string(size(G)));
print("AUGMENTED_MODULE_QUOTIENT_DIMENSION="+string(quotient_dimension));
print("AUGMENTED_MODULE_QUOTIENT_VECTOR_DIMENSION="+string(quotient_vector_dimension));
link result_link="{result}";
write(result_link,"status=COMPLETE");
write(result_link,"order_label={label}");
write(result_link,"singular_order={order}");
write(result_link,"input_generators="+string(size(N)));
write(result_link,"gb_generators="+string(size(G)));
write(result_link,"quotient_dimension="+string(quotient_dimension));
write(result_link,"quotient_vector_dimension="+string(quotient_vector_dimension));
close(result_link);
quit;
'''


def main() -> None:
    if not SOURCE.is_file():
        raise FileNotFoundError(SOURCE)
    monomials3_global = weak_compositions(3, 37)
    monomials4_global = weak_compositions(4, 37)
    monomials3 = weak_compositions(3, 8)
    monomials4 = weak_compositions(4, 8)
    indices3 = restriction_indices(
        3, {monomial: i for i, monomial in enumerate(monomials3_global)}
    )
    indices4 = restriction_indices(
        4, {monomial: i for i, monomial in enumerate(monomials4_global)}
    )
    with np.load(SOURCE, allow_pickle=False) as frozen:
        if int(frozen["prime"]) != P:
            raise AssertionError("r256 packet prime mismatch")
        restricted3_all = frozen["p3"][:, :, indices3].astype(np.uint8)
        restricted4_all = frozen["p4"][:, indices4].astype(np.uint8)
    rows3 = np.flatnonzero(np.any(restricted3_all != 0, axis=(1, 2)))
    rows4 = np.flatnonzero(np.any(restricted4_all != 0, axis=1))
    expected_rows = np.arange(142, 256)
    if not np.array_equal(rows3, expected_rows) or not np.array_equal(rows4, expected_rows):
        raise AssertionError("closed-L8 restricted row support changed")
    restricted3 = restricted3_all[rows3]
    restricted4 = restricted4_all[rows4]

    jobs = []
    for label, order in ORDERS:
        path = HERE / f"closed_L8_augmented_module_{label}.sing"
        path.write_text(
            singular_script(
                label, order, restricted3, restricted4, monomials3, monomials4
            )
        )
        jobs.append(
            {
                "order_label": label,
                "singular_order": order,
                "script": path.name,
                "script_sha256": sha256(path),
                "result": f"closed_L8_augmented_module_{label}.result",
            }
        )

    payload = {
        "status": "PREPARED_OPTIONAL_FALLBACK",
        "prime": P,
        "source": {
            "path": str(SOURCE.relative_to(P25)),
            "sha256": sha256(SOURCE),
        },
        "closed_stratum": "L8=P<span(q4,...,q11)>",
        "restricted_rows": rows3.astype(int).tolist(),
        "restricted_p3_shape": list(restricted3.shape),
        "restricted_p4_shape": list(restricted4.shape),
        "restricted_p3_sha256": array_sha256(restricted3),
        "restricted_p4_sha256": array_sha256(restricted4),
        "restricted_p3_nnz": int(np.count_nonzero(restricted3)),
        "restricted_p4_nnz": int(np.count_nonzero(restricted4)),
        "module": {
            "free_rank": 7,
            "generator_count": len(restricted3),
            "entry_degrees": [4, 3, 3, 3, 3, 3, 3],
            "criterion": (
                "dim(S_L8^7/N)=0 implies the homogeneous rank-drop support is "
                "only the affine cone vertex; hence [P4|P3] has rank 7 at every "
                "projective point of L8 and normalized Stage C is empty there."
            ),
        },
        "jobs": jobs,
    }
    METADATA.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {len(jobs)} exact augmented-module jobs")
    for job in jobs:
        print(job["order_label"], job["script"], job["script_sha256"])


if __name__ == "__main__":
    main()
