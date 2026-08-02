#!/usr/bin/env python3
"""PC.1: exact coupled degree-four closure over F_89.

The pure-q projection of the raw 29,985 candidate relation rows

    37*690 q-multiples of the cubic seeds,
    6*690 first transition rows T_i(s_a), and
    15*21 quadratic-basis commutator defects

has rank 27,583.  The 315 raw commutators have 105 universal cycle
syzygies: they are edge differences among the 336 ways to multiply one of the
56 monic K^3 rules by a K-variable, grouped over 126 quartic K-monomials.
After retaining a canonical 210-row commutator basis there are 29,880
candidate rows and a 2,297-dimensional pure-q dependency space.  This
producer constructs that dependency space without a large F_4
echelonization, evaluates it on a deterministic restriction of the other 27
components of F_4, and proves that the residual rank is 2,297.

This closes only the actual degree-four step.  It does not claim T-stability
in degree five or above.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from itertools import combinations_with_replacement
from pathlib import Path
import shlex
import struct
import subprocess
import time

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FM = ROOT / "certificates" / "degree25_finite_module"
RELATION = FM / "relation_matrix.npz"
MULTIPLICATION = FM / "multiplication_matrices.npz"
REWRITE = FM / "rewrite_rules.npz"
MU_KERNEL = HERE / "pc0_multiplication_kernel.npz"
P = 89
NQ, NK, NQUAD, NSEED, NW, NV = 37, 6, 21, 690, 56, 746
NOLD = NQ * NSEED
NTRANS = NK * NSEED
NCOMM_RAW = 15 * NQUAD
NCOMM_BASIS = 210
NCOMM_SYZYGY = NCOMM_RAW - NCOMM_BASIS
NRAW_EXTRA = NTRANS + NCOMM_RAW
NRAW_CANDIDATE = NOLD + NRAW_EXTRA
NEXTRA = NTRANS + NCOMM_BASIS
NCANDIDATE = NOLD + NEXTRA
FORMAL_W = NQ * NW
PURE_Q_RANK = 27583
PURE_Q_NULLITY = NCANDIDATE - PURE_Q_RANK
FORMAL_DEPENDENCIES = NEXTRA - FORMAL_W
MU_NULLITY = 19
DEFAULT_SEED = 2026080126
DEFAULT_SELECTED = 3000


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 22):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, slots: int) -> list[tuple[int, ...]]:
    result: list[tuple[int, ...]] = []

    def visit(prefix: tuple[int, ...], remaining: int, left: int) -> None:
        if left == 1:
            result.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, left - 1)

    visit((), total, slots)
    return result


def rank_and_profile(matrix: np.ndarray) -> tuple[int, np.ndarray]:
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.RowRankProfile_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)),
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    rows, columns = dense.shape
    rank = int(
        function(
            float(P), rows, columns, dense, columns, ctypes.byref(pointer), 1, False
        )
    )
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy().astype(np.int32)
    return rank, profile


def invert_modular(matrix: np.ndarray) -> np.ndarray:
    source = np.ascontiguousarray(matrix, dtype=np.float64)
    if source.shape[0] != source.shape[1]:
        raise AssertionError("inverse requested for nonsquare matrix")
    target = np.empty_like(source)
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.Invert_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int),
        ctypes.c_bool,
    ]
    function.restype = ctypes.POINTER(ctypes.c_double)
    nullity = ctypes.c_int(-1)
    returned = function(
        float(P),
        source.shape[0],
        source,
        source.shape[1],
        target,
        target.shape[1],
        ctypes.byref(nullity),
        False,
    )
    if not returned or nullity.value != 0:
        raise AssertionError(f"basis minor inversion failed: nullity={nullity.value}")
    raw = np.rint(target).astype(np.int64) % P
    # This C interface returns X with X*A equal to the PLUQ pivot
    # permutation.  Undo that explicit permutation to obtain A^{-1}.
    left = np.rint(raw.astype(np.float64) @ matrix.astype(np.float64)).astype(np.int64) % P
    row_counts = np.count_nonzero(left, axis=1)
    column_counts = np.count_nonzero(left, axis=0)
    if not (
        np.all(row_counts == 1)
        and np.all(column_counts == 1)
        and np.all(left[left != 0] == 1)
    ):
        raise AssertionError("FFPACK inverse pivot product is not a permutation")
    permutation = np.argmax(left, axis=1)
    inverse = np.empty_like(raw)
    inverse[permutation] = raw
    identity = np.rint(
        matrix.astype(np.float64) @ inverse.astype(np.float64)
    ).astype(np.int64) % P
    if not np.array_equal(identity, np.eye(matrix.shape[0], dtype=np.int64)):
        raise AssertionError("basis inverse identity failed after pivot correction")
    return inverse.astype(np.uint8)


def compile_ranker(binary: Path) -> None:
    flags = shlex.split(
        subprocess.check_output(
            ["pkg-config", "--cflags", "--libs", "fflas-ffpack"], text=True
        ).strip()
    )
    subprocess.run(
        [
            "clang++",
            "-O3",
            "-std=c++17",
            str(HERE / "rank_u8_float.cpp"),
            "-o",
            str(binary),
            *flags,
            "-framework",
            "Accelerate",
        ],
        check=True,
    )


def write_u8_matrix(path: Path, matrix: np.ndarray) -> None:
    matrix = np.ascontiguousarray(matrix, dtype=np.uint8)
    with path.open("wb") as handle:
        handle.write(struct.pack("<QQQ", matrix.shape[0], matrix.shape[1], P))
        handle.write(matrix.tobytes())


def read_right_kernel(path: Path) -> np.ndarray:
    with path.open("rb") as handle:
        rows, columns, prime = struct.unpack("<QQQ", handle.read(24))
        raw = handle.read()
    if prime != P or len(raw) != rows * columns:
        raise AssertionError("invalid right-kernel artifact")
    return np.frombuffer(raw, dtype=np.uint8).copy().reshape(rows, columns)


def exact_right_kernel(
    matrix: np.ndarray, scratch: Path, binary: Path, stem: str
) -> np.ndarray:
    matrix_path = scratch / f"{stem}.bin"
    kernel_path = scratch / f"{stem}_kernel.bin"
    write_u8_matrix(matrix_path, matrix)
    run = subprocess.run(
        [str(binary), str(matrix_path), "--right-kernel", str(kernel_path)],
        check=True,
        text=True,
        capture_output=True,
    )
    print(run.stdout.strip(), flush=True)
    return read_right_kernel(kernel_path)


def order_basis() -> tuple[list[tuple[int, ...]], list[int]]:
    basis = [tuple([0] * NK)]
    for variable in range(NK):
        exponent = [0] * NK
        exponent[variable] = 1
        basis.append(tuple(exponent))
    for left, right in combinations_with_replacement(range(NK), 2):
        exponent = [0] * NK
        exponent[left] += 1
        exponent[right] += 1
        basis.append(tuple(exponent))
    if len(basis) != 28:
        raise AssertionError("basis order changed")
    return basis, [sum(exponent) for exponent in basis]


def commutator_path_incidence() -> tuple[np.ndarray, np.ndarray]:
    """Universal edge incidence for the 315 quadratic commutators.

    A path is (outer K-variable, cubic K-monomial), so there are 6*56=336.
    Each commutator is the difference of the two paths that reduce the same
    quartic monomial in the two possible displayed orders.
    """
    basis, bdeg = order_basis()
    quadratics = [basis[index] for index, degree in enumerate(bdeg) if degree == 2]
    cubics = weak_compositions(3, NK)
    cubic_index = {monomial: index for index, monomial in enumerate(cubics)}
    incidence = np.zeros((NCOMM_RAW, NK * len(cubics)), dtype=np.uint8)
    labels = []
    row = 0
    for left in range(NK):
        for right in range(left + 1, NK):
            for source, quadratic in enumerate(quadratics):
                right_cubic = list(quadratic)
                right_cubic[right] += 1
                left_cubic = list(quadratic)
                left_cubic[left] += 1
                first = left * len(cubics) + cubic_index[tuple(right_cubic)]
                second = right * len(cubics) + cubic_index[tuple(left_cubic)]
                incidence[row, first] = 1
                incidence[row, second] = P - 1
                labels.append((left, right, source))
                row += 1
    if row != NCOMM_RAW:
        raise AssertionError("commutator incidence row count changed")
    return incidence, np.asarray(labels, dtype=np.int16)


def verify_commutator_path_inputs(
    tquad: np.ndarray, rule_exponents: np.ndarray, rule_tails: np.ndarray
) -> str:
    """Prove the path factorization before applying any T-operator.

    Each of the two F_3 inputs in every commutator is byte-matched to the
    appropriate one of the 56 monic-rule reductions.  Since T_i is S-linear,
    the complete F_4 commutator matrix is therefore the universal 315x336
    incidence matrix times the 336 path images, on every coordinate (not just
    on the selected residual restriction).
    """
    basis, degrees = order_basis()
    quadratics = [basis[index] for index, degree in enumerate(degrees) if degree == 2]
    rules = {
        tuple(map(int, exponent)): np.ascontiguousarray(
            (-tail.astype(np.int16)) % P, dtype=np.uint8
        )
        for exponent, tail in zip(rule_exponents, rule_tails, strict=True)
    }
    if len(rules) != 56:
        raise AssertionError("rewrite-rule exponent index changed")
    matched = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source, quadratic in enumerate(quadratics):
                right_cubic = list(quadratic)
                right_cubic[right] += 1
                left_cubic = list(quadratic)
                left_cubic[left] += 1
                if not np.array_equal(tquad[right, source], rules[tuple(right_cubic)]):
                    raise AssertionError("right commutator path input mismatch")
                if not np.array_equal(tquad[left, source], rules[tuple(left_cubic)]):
                    raise AssertionError("left commutator path input mismatch")
                matched.extend([tquad[right, source], tquad[left, source]])
    return sha256_array(np.ascontiguousarray(np.vstack(matched), dtype=np.uint8))


def formal_rows(
    seeds: np.ndarray, offsets3: np.ndarray, tquad: np.ndarray
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    tq0 = np.ascontiguousarray(
        tquad[:, :, offsets3[0] : offsets3[1]].reshape(NK * NQUAD, -1)
    )
    w = np.unique(tq0, axis=0)
    if w.shape != (NW, 9139):
        raise AssertionError(f"unexpected W shape {w.shape}")
    lookup = {row.tobytes(): index for index, row in enumerate(w)}
    tq_w = np.zeros((NK * NQUAD, NW), dtype=np.uint8)
    for row, vector in enumerate(tq0):
        tq_w[row, lookup[vector.tobytes()]] = 1
    tq_w = tq_w.reshape(NK, NQUAD, NW)
    m2 = np.stack(
        [seeds[:, offsets3[7 + source] : offsets3[8 + source]] for source in range(NQUAD)],
        axis=1,
    ).astype(np.uint8)
    transitions = []
    for operator in range(NK):
        block = m2.transpose(0, 2, 1).astype(np.int64) @ tq_w[operator].astype(np.int64)
        transitions.append(np.ascontiguousarray(block.reshape(NSEED, FORMAL_W) % P, dtype=np.uint8))
    transitions_array = np.ascontiguousarray(np.vstack(transitions), dtype=np.uint8)

    tqq = np.empty((NK, NQUAD, NQUAD, NQ), dtype=np.uint8)
    for operator in range(NK):
        for source in range(NQUAD):
            for target in range(NQUAD):
                tqq[operator, source, target] = tquad[
                    operator, source, offsets3[7 + target] : offsets3[8 + target]
                ]
    commutators = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source in range(NQUAD):
                first = tqq[right, source].T.astype(np.int64) @ tq_w[left]
                second = tqq[left, source].T.astype(np.int64) @ tq_w[right]
                commutators.append(np.ascontiguousarray((first - second) % P).reshape(-1))
    commutator_array = np.ascontiguousarray(np.vstack(commutators), dtype=np.uint8)
    return transitions_array, commutator_array, m2


def selected_coupled_matrix(
    seeds: np.ndarray,
    offsets3: np.ndarray,
    bdeg: np.ndarray,
    low_target: np.ndarray,
    tquad: np.ndarray,
    m2: np.ndarray,
    selected: np.ndarray,
) -> tuple[np.ndarray, np.ndarray, list[tuple[int, int, tuple[int, ...]]]]:
    qmonomials = {degree: weak_compositions(degree, NQ) for degree in range(5)}
    qmonomials[0] = [tuple([0] * NQ)]
    qindex = {
        degree: {monomial: index for index, monomial in enumerate(qmonomials[degree])}
        for degree in range(5)
    }
    offsets4 = [0]
    for degree in bdeg:
        offsets4.append(offsets4[-1] + len(qmonomials[4 - int(degree)]))
    offsets4 = np.asarray(offsets4, dtype=np.int32)
    if int(offsets4[-1]) != 160987 or int(offsets4[1]) != 91390:
        raise AssertionError("F4 layout changed")

    coordinate_labels: list[tuple[int, int, tuple[int, ...]]] = []
    for local in selected:
        absolute = int(offsets4[1]) + int(local)
        component = int(np.searchsorted(offsets4, absolute, side="right") - 1)
        monomial_index = absolute - int(offsets4[component])
        exponent = qmonomials[4 - int(bdeg[component])][monomial_index]
        coordinate_labels.append((component, monomial_index, exponent))

    matrix = np.zeros((NRAW_CANDIDATE, len(selected)), dtype=np.uint8)

    # q_j s_a rows.
    for column, (component, _monomial_index, exponent) in enumerate(coordinate_labels):
        source_degree = 3 - int(bdeg[component])
        for variable, power in enumerate(exponent):
            if not power:
                continue
            predecessor = list(exponent)
            predecessor[variable] -= 1
            source_index = int(offsets3[component]) + qindex[source_degree][tuple(predecessor)]
            start = variable * NSEED
            matrix[start : start + NSEED, column] = seeds[:, source_index]

    # H_i maps the 21*37 quadratic-component linear coefficients of a vector
    # in F_3 to the selected coordinates of T_i(vector) in F_4.
    m2_flat = np.ascontiguousarray(m2.reshape(NSEED, NQUAD * NQ), dtype=np.uint8)
    selected_t_images = []
    q_units = qmonomials[1]
    for operator in range(NK):
        hmap = np.zeros((NQUAD * NQ, len(selected)), dtype=np.uint8)
        direct = np.zeros((NSEED, len(selected)), dtype=np.uint8)
        for column, (target, _monomial_index, exponent) in enumerate(coordinate_labels):
            # Low basis terms map without q-polynomial multiplication.
            for source in range(7):
                if int(low_target[operator, source]) != target:
                    continue
                source_index = int(offsets3[source]) + qindex[3 - int(bdeg[source])][exponent]
                direct[:, column] = (
                    direct[:, column].astype(np.uint16)
                    + seeds[:, source_index].astype(np.uint16)
                ) % P
            # A linear source coefficient times a degree-(3-deg target) tail.
            tail_degree = 3 - int(bdeg[target])
            for unit_index, unit in enumerate(q_units):
                variable = next(index for index, value in enumerate(unit) if value)
                if not exponent[variable]:
                    continue
                predecessor = list(exponent)
                predecessor[variable] -= 1
                tail_index = int(offsets3[target]) + qindex[tail_degree][tuple(predecessor)]
                for quadratic in range(NQUAD):
                    hmap[quadratic * NQ + unit_index, column] = tquad[
                        operator, quadratic, tail_index
                    ]
        product = np.rint(
            m2_flat.astype(np.float64) @ hmap.astype(np.float64)
        ).astype(np.int64) % P
        transition = (product + direct.astype(np.int64)) % P
        selected_t_images.append((hmap, transition.astype(np.uint8)))
        start = NOLD + operator * NSEED
        matrix[start : start + NSEED] = transition.astype(np.uint8)
        print(f"  built selected T_{operator} seed block", flush=True)

    # Apply each T_i to all 126 quadratic rewrite-tail vectors.  The desired
    # 315 commutators are differences of the corresponding selected rows.
    tquad_batch = np.ascontiguousarray(tquad.reshape(NK * NQUAD, -1), dtype=np.uint8)
    tquad_m2 = np.stack(
        [tquad_batch[:, offsets3[7 + source] : offsets3[8 + source]] for source in range(NQUAD)],
        axis=1,
    ).reshape(NK * NQUAD, NQUAD * NQ)
    applied = []
    for operator, (hmap, _seed_transition) in enumerate(selected_t_images):
        direct = np.zeros((NK * NQUAD, len(selected)), dtype=np.uint8)
        for column, (target, _monomial_index, exponent) in enumerate(coordinate_labels):
            for source in range(7):
                if int(low_target[operator, source]) != target:
                    continue
                source_index = int(offsets3[source]) + qindex[3 - int(bdeg[source])][exponent]
                direct[:, column] = (
                    direct[:, column].astype(np.uint16)
                    + tquad_batch[:, source_index].astype(np.uint16)
                ) % P
        product = np.rint(
            tquad_m2.astype(np.float64) @ hmap.astype(np.float64)
        ).astype(np.int64) % P
        applied.append(((product + direct.astype(np.int64)) % P).astype(np.uint8))
    commutator_labels = []
    commutator_rows = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source in range(NQUAD):
                first = applied[left][right * NQUAD + source].astype(np.int16)
                second = applied[right][left * NQUAD + source].astype(np.int16)
                commutator_rows.append(np.ascontiguousarray((first - second) % P, dtype=np.uint8))
                commutator_labels.append((left, right, source))
    commutator_matrix = np.ascontiguousarray(np.vstack(commutator_rows), dtype=np.uint8)
    matrix[NOLD + NTRANS :] = commutator_matrix
    return matrix, offsets4, coordinate_labels


def main() -> None:
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--seed", type=int, default=DEFAULT_SEED)
    parser.add_argument("--selected", type=int, default=DEFAULT_SELECTED)
    parser.add_argument(
        "--scratch", type=Path, default=Path("/tmp/p25_cov_pc1_coupled")
    )
    parser.add_argument("--residual-block", type=int, default=250)
    args = parser.parse_args()
    if args.selected < PURE_Q_NULLITY or args.selected > 69597:
        raise SystemExit(f"selected must lie in [{PURE_Q_NULLITY},69597]")
    args.scratch.mkdir(parents=True, exist_ok=True)
    binary = args.scratch / "rank_u8_float"
    compile_ranker(binary)
    started = time.monotonic()

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets3 = frozen["off3"].astype(np.int32)
        bdeg = frozen["Bdeg"].astype(np.int8)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime changed")
    with np.load(MULTIPLICATION, allow_pickle=False) as frozen:
        low_target = frozen["low_target"].astype(np.int32)
        tquad = frozen["T_quad_F3"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("multiplication prime changed")
    with np.load(REWRITE, allow_pickle=False) as frozen:
        rule_exponents = frozen["k_exp"].astype(np.int8)
        rule_tails = frozen["tail_F3"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("rewrite prime changed")
    with np.load(MU_KERNEL, allow_pickle=False) as frozen:
        mu_kernel = frozen["kernel"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("PC0 kernel prime changed")
    if seeds.shape != (NSEED, 14134) or mu_kernel.shape != (NQ * NV, MU_NULLITY):
        raise AssertionError("input shape changed")

    transitions, commutators, m2 = formal_rows(seeds, offsets3, tquad)

    # The 315 raw commutators are edge differences among 336 reduction paths.
    # Their universal cycle space has dimension 105, independently of the
    # numerical rewrite tails.  Keep a canonical 210-row edge basis.
    commutator_incidence, commutator_labels = commutator_path_incidence()
    path_input_sha256 = verify_commutator_path_inputs(
        tquad, rule_exponents, rule_tails
    )
    incidence_rank, commutator_profile = rank_and_profile(commutator_incidence)
    if incidence_rank != NCOMM_BASIS:
        raise AssertionError(f"commutator incidence rank {incidence_rank}")
    commutator_syzygies = exact_right_kernel(
        np.ascontiguousarray(commutator_incidence.T, dtype=np.uint8),
        args.scratch,
        binary,
        "commutator_incidence_transpose",
    )
    if commutator_syzygies.shape != (NCOMM_RAW, NCOMM_SYZYGY):
        raise AssertionError(f"unexpected commutator syzygies {commutator_syzygies.shape}")
    if np.any(
        commutator_incidence.T.astype(np.float64)
        @ commutator_syzygies.astype(np.float64)
        % P
    ):
        raise AssertionError("universal commutator syzygy substitution failed")
    if np.any(
        commutators.T.astype(np.float64)
        @ commutator_syzygies.astype(np.float64)
        % P
    ):
        raise AssertionError("formal commutators violate universal cycle syzygies")
    commutator_basis = np.ascontiguousarray(
        commutators[commutator_profile], dtype=np.uint8
    )
    if rank_and_profile(commutator_basis)[0] != NCOMM_BASIS:
        raise AssertionError("selected commutator basis lost formal rank")

    extra_formal = np.ascontiguousarray(
        np.vstack([transitions, commutator_basis]), dtype=np.uint8
    )
    formal_rank, formal_profile = rank_and_profile(extra_formal)
    if formal_rank != FORMAL_W:
        raise AssertionError(f"formal extra rank {formal_rank}")

    # Kernel of extra_formal^T gives every formal dependency among the 4,350
    # transition and independent commutator rows.
    formal_kernel = exact_right_kernel(
        np.ascontiguousarray(extra_formal.T, dtype=np.uint8),
        args.scratch,
        binary,
        "extra_formal_transpose",
    )
    if formal_kernel.shape != (NEXTRA, FORMAL_DEPENDENCIES):
        raise AssertionError(f"unexpected formal kernel {formal_kernel.shape}")
    if np.any(extra_formal.T.astype(np.float64) @ formal_kernel.astype(np.float64) % P):
        raise AssertionError("formal dependency substitution failed")
    formal_kernel_rank, _ = rank_and_profile(formal_kernel.T)
    if formal_kernel_rank != FORMAL_DEPENDENCIES:
        raise AssertionError("formal dependency basis lost rank")

    # Lift the 19 polynomial multiplication kernels through a full-rank formal
    # transition basis.  This gives the remaining 19 pure-q dependencies.
    transition_rank, transition_profile = rank_and_profile(transitions)
    if transition_rank != FORMAL_W:
        raise AssertionError("transition formal rank changed")
    transition_basis = np.ascontiguousarray(transitions[transition_profile], dtype=np.uint8)
    transition_inverse = invert_modular(transition_basis)
    v0_indices = np.asarray(
        [variable * NV + seed for variable in range(NQ) for seed in range(NSEED)],
        dtype=np.int32,
    )
    w_indices = np.asarray(
        [variable * NV + NSEED + basis for variable in range(NQ) for basis in range(NW)],
        dtype=np.int32,
    )
    mu_v0 = np.ascontiguousarray(mu_kernel[v0_indices].T, dtype=np.uint8)
    mu_w = np.ascontiguousarray(mu_kernel[w_indices].T, dtype=np.uint8)
    transition_coefficients = np.rint(
        mu_w.astype(np.float64) @ transition_inverse.astype(np.float64)
    ).astype(np.int64) % P
    if not np.array_equal(
        (transition_coefficients.astype(np.float64) @ transition_basis.astype(np.float64)).astype(np.int64) % P,
        mu_w.astype(np.int64),
    ):
        raise AssertionError("multiplication-kernel lift failed")

    dependency_coefficients = np.zeros((PURE_Q_NULLITY, NCANDIDATE), dtype=np.uint8)
    dependency_coefficients[:FORMAL_DEPENDENCIES, NOLD:] = formal_kernel.T
    dependency_coefficients[FORMAL_DEPENDENCIES:, :NOLD] = mu_v0
    for row in range(MU_NULLITY):
        dependency_coefficients[
            FORMAL_DEPENDENCIES + row,
            NOLD + transition_profile,
        ] = transition_coefficients[row].astype(np.uint8)
    dependency_rank, _ = rank_and_profile(dependency_coefficients)
    if dependency_rank != PURE_Q_NULLITY:
        raise AssertionError(f"pure-q dependency rank {dependency_rank}")

    selected = np.sort(
        np.random.default_rng(args.seed)
        .choice(69597, size=args.selected, replace=False)
        .astype(np.int32)
    )
    raw_candidate_selected, offsets4, coordinate_labels = selected_coupled_matrix(
        seeds, offsets3, bdeg, low_target, tquad, m2, selected
    )
    candidate_selected = np.ascontiguousarray(
        np.vstack(
            [
                raw_candidate_selected[: NOLD + NTRANS],
                raw_candidate_selected[NOLD + NTRANS + commutator_profile],
            ]
        ),
        dtype=np.uint8,
    )
    if candidate_selected.shape != (NCANDIDATE, args.selected):
        raise AssertionError("selected coupled matrix shape changed")
    raw_commutator_selected = raw_candidate_selected[NOLD + NTRANS :]
    if np.any(
        commutator_syzygies.T.astype(np.float64)
        @ raw_commutator_selected.astype(np.float64)
        % P
    ):
        raise AssertionError("selected coupled commutators violate cycle syzygies")

    # Exact binary64 accumulation: each entry sums fewer than 30,000 products
    # of integers at most 88, far below 2^53.
    dependency_float = dependency_coefficients.astype(np.float64)
    residual = np.empty((PURE_Q_NULLITY, args.selected), dtype=np.uint8)
    for start in range(0, args.selected, args.residual_block):
        stop = min(args.selected, start + args.residual_block)
        block = np.rint(
            dependency_float @ candidate_selected[:, start:stop].astype(np.float64)
        ).astype(np.int64) % P
        residual[:, start:stop] = block.astype(np.uint8)
        print(f"  coupled residual columns {stop}/{args.selected}", flush=True)
    residual_rank, residual_profile = rank_and_profile(residual)
    if residual_rank != PURE_Q_NULLITY:
        raise SystemExit(
            f"selected coupled residual rank {residual_rank}/{PURE_Q_NULLITY}; "
            "the full degree-four kernel requires an all-coordinate substitution"
        )

    artifact = HERE / "pc1_coupled_degree4_certificate.npz"
    label_components = np.asarray([label[0] for label in coordinate_labels], dtype=np.int16)
    label_monomials = np.asarray([label[1] for label in coordinate_labels], dtype=np.int32)
    np.savez_compressed(
        artifact,
        prime=np.int32(P),
        selection_seed=np.int64(args.seed),
        selected_coupled_columns=selected,
        selected_components=label_components,
        selected_component_monomials=label_monomials,
        formal_transition_profile=transition_profile,
        formal_extra_profile=formal_profile,
        commutator_path_incidence=commutator_incidence,
        commutator_labels=commutator_labels,
        commutator_basis_rows=commutator_profile,
        commutator_cycle_syzygies=commutator_syzygies,
        pure_q_dependency_coefficients=dependency_coefficients,
        selected_coupled_residual=residual,
        residual_row_profile=residual_profile,
    )
    result = {
        "status": "PC1-COUPLED-DEGREE4-PASS",
        "prime": P,
        "inputs": {
            str(RELATION.relative_to(ROOT)): sha256_file(RELATION),
            str(MULTIPLICATION.relative_to(ROOT)): sha256_file(MULTIPLICATION),
            str(REWRITE.relative_to(ROOT)): sha256_file(REWRITE),
            MU_KERNEL.name: sha256_file(MU_KERNEL),
        },
        "candidate_ledger": {
            "old_q_seed_rows": NOLD,
            "transition_rows": NTRANS,
            "quadratic_commutator_rows_raw": NCOMM_RAW,
            "quadratic_commutator_rank": NCOMM_BASIS,
            "quadratic_commutator_cycle_syzygies": NCOMM_SYZYGY,
            "commutator_path_inputs_sha256": path_input_sha256,
            "all_coordinate_factorization": (
                "Every T_i input is byte-matched to its monic-rule path before "
                "application. By S-linearity, the full F4 commutator matrix equals "
                "the 315x336 path incidence times the 336 path images on all 160987 "
                "coordinates; the 105 incidence-cycle syzygies are therefore full "
                "coupled identities."
            ),
            "raw_total_rows": NRAW_CANDIDATE,
            "minimal_candidate_rows": NCANDIDATE,
        },
        "pure_q_projection": {
            "rank": PURE_Q_RANK,
            "kernel_dimension": PURE_Q_NULLITY,
            "formal_extra_rank": formal_rank,
            "formal_extra_kernel_dimension": FORMAL_DEPENDENCIES,
            "lifted_multiplication_kernel_dimension": MU_NULLITY,
            "dependency_basis_rank": dependency_rank,
            "dependency_basis_sha256": sha256_array(dependency_coefficients),
        },
        "coupled_residual": {
            "ambient_dimension": 69597,
            "selected_columns": args.selected,
            "selection_seed": args.seed,
            "selected_columns_sha256": sha256_array(selected),
            "candidate_restriction_sha256": sha256_array(candidate_selected),
            "residual_shape": list(residual.shape),
            "residual_rank": residual_rank,
            "residual_sha256": sha256_array(residual),
        },
        "full_degree4": {
            "old_rank": NOLD,
            "new_transition_generators": NTRANS,
            "new_commutator_generators": NCOMM_BASIS,
            "new_generators_total": NEXTRA,
            "rank": NCANDIDATE,
            "kernel_dimension": 0,
            "normal_form_statement": (
                "After quotienting the 105 universal commutator cycle syzygies, "
                "the 29,880 ordered candidate rows are a basis of the degree-four "
                "closure subspace; their deterministic selected coupled restriction "
                "is injective on the complete 2,297-dimensional pure-q kernel."
            ),
        },
        "artifact": artifact.name,
        "artifact_sha256": sha256_file(artifact),
        "resource": {
            "elapsed_seconds": time.monotonic() - started,
            "largest_durable_dense_shape": list(dependency_coefficients.shape),
            "historical_full_F4_dense_elimination_repeated": False,
        },
        "theorem_boundary": {
            "proves": (
                "Exactly over F_89, the 315 raw quadratic commutators have their 105 "
                "universal cycle syzygies and rank 210. After selecting a 210-row "
                "commutator basis, all 29,880 coupled degree-four relation candidates "
                "are linearly independent. Thus degree four adds all 4,140 transitions "
                "and 210 commutator generators to the 25,530 q-multiples of the seeds."
            ),
            "does_not_prove": (
                "T-stability in degree five or above, a finite stabilization or "
                "regularity bound, representation characters, projective support, "
                "or any characteristic-zero statement."
            ),
        },
    }
    (HERE / "pc1_coupled_degree4.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print("PASS_PC1_COUPLED_DEGREE4", flush=True)


if __name__ == "__main__":
    main()
