#!/usr/bin/env python3
"""Dependency-free exact support audit at progression root degree five.

For each of the sixteen (d,r) families, the full coefficient landing system
is constructed by ``verify.landing_system``.  A coefficient support can
possibly solve the equations only if every landing row has either zero or at
least two active coefficient monomials.  A row with exactly one active
monomial is a nonzero monomial equation and is impossible on that support.

There are at most 24 coefficient variables, so this script generates and
compiles a small C++ program which checks every one of the 2^N supports,
requiring both Frobenius-residue components to be nonzero.  It is a complete
finite enumeration, not a MILP/SAT success flag and not a coefficient-height
search.
"""

from __future__ import annotations

import hashlib
import subprocess
import tempfile
from pathlib import Path

from verify import landing_system


def coefficient_mask(monomial: tuple[int, ...]) -> int:
    mask = 0
    for index in set(monomial):
        mask |= 1 << index
    return mask


def family_data(d: int, r: int):
    *_, basis_h, basis_k, equations = landing_system(d, r, 5)
    rows = []
    for polynomial in equations:
        # Distinct coefficient monomials with the same squarefree support
        # remain distinct possible summands, hence duplicate masks are kept.
        row = tuple(coefficient_mask(monomial) for monomial in polynomial)
        rows.append(row)
    rows.sort(key=len)
    offsets = [0]
    terms = []
    for row in rows:
        terms.extend(row)
        offsets.append(len(terms))
    return len(basis_h), len(basis_k), tuple(offsets), tuple(terms)


def array(name: str, values) -> str:
    body = ",".join(str(value) for value in values)
    return f"static const uint32_t {name}[] = {{{body}}};\n"


def generated_source():
    declarations = []
    calls = []
    metadata = []
    for d in range(1, 5):
        for r in range(1, 5):
            hdim, kdim, offsets, terms = family_data(d, r)
            tag = f"d{d}r{r}"
            declarations.append(array(f"off_{tag}", offsets))
            declarations.append(array(f"term_{tag}", terms))
            calls.append(
                f"  ok = audit({d},{r},{hdim},{kdim},off_{tag},"
                f"{len(offsets)-1},term_{tag}) && ok;"
            )
            metadata.append((d, r, hdim, kdim, len(offsets) - 1, len(terms)))

    source = r'''// Generated exact exhaustive support verifier.
#include <atomic>
#include <cstdint>
#include <iostream>
#include <thread>
#include <vector>

''' + "".join(declarations) + r'''

bool audit(int d, int r, int hdim, int kdim,
           const uint32_t* offsets, uint32_t row_count,
           const uint32_t* terms) {
  const int n = hdim + kdim;
  const uint32_t total = uint32_t(1) << n;
  const uint32_t hmask = (uint32_t(1) << hdim) - 1;
  const uint32_t bmask = (total - 1) ^ hmask;
  std::atomic<uint32_t> winner(0);
  unsigned workers = std::thread::hardware_concurrency();
  if (!workers) workers = 4;
  std::vector<std::thread> pool;
  for (unsigned worker = 0; worker < workers; ++worker) {
    uint32_t begin = uint64_t(total) * worker / workers;
    uint32_t end = uint64_t(total) * (worker + 1) / workers;
    pool.emplace_back([=, &winner]() {
      for (uint32_t support = begin; support < end && !winner.load(); ++support) {
        if (!(support & hmask) || !(support & bmask)) continue;
        bool impossible = false;
        for (uint32_t row = 0; row < row_count; ++row) {
          int active = 0;
          for (uint32_t index = offsets[row]; index < offsets[row + 1]; ++index) {
            const uint32_t monomial = terms[index];
            if ((support & monomial) == monomial && ++active == 2) break;
          }
          if (active == 1) { impossible = true; break; }
        }
        if (!impossible) {
          uint32_t expected = 0;
          winner.compare_exchange_strong(expected, support);
          break;
        }
      }
    });
  }
  for (auto& thread : pool) thread.join();
  const uint32_t found = winner.load();
  std::cout << "FAMILY " << d << " " << r
            << " HDIM " << hdim << " KDIM " << kdim
            << " ROWS " << row_count << " SUPPORT ";
  if (found) std::cout << found << "\n";
  else std::cout << "NONE\n";
  return found == 0;
}

int main() {
  bool ok = true;
''' + "\n".join(calls) + r'''
  if (!ok) return 1;
  std::cout << "F55-CHAR5-PROGRESSION-DEGREE35-SUPPORT-EMPTY-EXACT\n";
  return 0;
}
'''
    return source, tuple(metadata)


def main():
    source, metadata = generated_source()
    assert len(metadata) == 16
    assert max(h + k for _, _, h, k, _, _ in metadata) == 24
    digest = hashlib.sha256(source.encode()).hexdigest()
    with tempfile.TemporaryDirectory(prefix="char5_progression_n5_") as temp:
        directory = Path(temp)
        source_path = directory / "audit.cpp"
        executable = directory / "audit"
        source_path.write_text(source)
        subprocess.run(
            ["c++", "-O3", "-std=c++17", "-pthread", source_path,
             "-o", executable],
            check=True,
        )
        completed = subprocess.run(
            [executable],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
        )
    lines = completed.stdout.splitlines()
    family_lines = [line for line in lines if line.startswith("FAMILY ")]
    assert len(family_lines) == 16
    assert all(line.endswith(" SUPPORT NONE") for line in family_lines)
    for line in lines:
        print(line)
    print(f"GENERATED_CPP_SHA256 {digest}")


if __name__ == "__main__":
    main()
