#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

namespace {
constexpr int NROW = 37;
constexpr int NCOL = 243;
constexpr int NK = 4305;
constexpr std::int64_t NQUAD = static_cast<std::int64_t>(NK) * (NK + 1) / 2;

struct DSU {
  std::vector<std::int32_t> parent;
  std::vector<std::uint8_t> rank;
  explicit DSU(std::size_t n) : parent(n), rank(n, 0) {
    for (std::size_t i = 0; i < n; ++i) parent[i] = static_cast<std::int32_t>(i);
  }
  std::int32_t find(std::int32_t x) {
    std::int32_t root = x;
    while (parent[root] != root) root = parent[root];
    while (parent[x] != x) {
      std::int32_t next = parent[x];
      parent[x] = root;
      x = next;
    }
    return root;
  }
  bool unite(std::int32_t a, std::int32_t b) {
    a = find(a); b = find(b);
    if (a == b) return false;
    if (rank[a] < rank[b]) std::swap(a, b);
    parent[b] = a;
    if (rank[a] == rank[b]) ++rank[a];
    return true;
  }
};

std::int32_t qindex(std::int32_t a, std::int32_t b) {
  if (a > b) std::swap(a, b);
  const std::int64_t offset = static_cast<std::int64_t>(a) * NK
      - static_cast<std::int64_t>(a) * (a - 1) / 2;
  return static_cast<std::int32_t>(offset + (b - a));
}
}  // namespace

int main(int argc, char** argv) {
  if (argc != 3) {
    std::cerr << "usage: free_minor_union CELL_FREE_IDS.raw LABELS.raw\n";
    return 2;
  }
  std::vector<std::int32_t> cell(NROW * NCOL);
  {
    std::ifstream input(argv[1], std::ios::binary);
    if (!input) throw std::runtime_error("cannot open cell map");
    input.read(reinterpret_cast<char*>(cell.data()),
               static_cast<std::streamsize>(cell.size() * sizeof(std::int32_t)));
    if (!input || input.peek() != EOF) throw std::runtime_error("bad cell map size");
  }
  DSU dsu(static_cast<std::size_t>(NQUAD));
  std::uint64_t all_free_minors = 0;
  std::uint64_t nonzero_edges = 0;
  std::uint64_t successful_unions = 0;
  std::uint64_t pivot_histogram[5] = {0, 0, 0, 0, 0};
  for (int a = 0; a < NROW; ++a) {
    for (int b = a + 1; b < NROW; ++b) {
      const auto* ca = &cell[a * NCOL];
      const auto* cb = &cell[b * NCOL];
      for (int alpha = 0; alpha < NCOL; ++alpha) {
        const auto aa = ca[alpha];
        const auto ba = cb[alpha];
        for (int beta = alpha + 1; beta < NCOL; ++beta) {
          const auto ab = ca[beta];
          const auto bb = cb[beta];
          const int pivot_count = (aa < 0) + (ba < 0) + (ab < 0) + (bb < 0);
          ++pivot_histogram[pivot_count];
          if (pivot_count != 0) continue;
          ++all_free_minors;
          const auto left = qindex(aa, bb);
          const auto right = qindex(ab, ba);
          if (left == right) continue;
          ++nonzero_edges;
          if (dsu.unite(left, right)) ++successful_unions;
        }
      }
    }
  }
  std::vector<std::int32_t> root_label(static_cast<std::size_t>(NQUAD), -1);
  std::vector<std::int32_t> labels(static_cast<std::size_t>(NQUAD));
  std::int32_t components = 0;
  for (std::int32_t i = 0; i < NQUAD; ++i) {
    const auto root = dsu.find(i);
    auto& label = root_label[root];
    if (label < 0) label = components++;
    labels[i] = label;
  }
  {
    std::ofstream output(argv[2], std::ios::binary | std::ios::trunc);
    if (!output) throw std::runtime_error("cannot open label output");
    output.write(reinterpret_cast<const char*>(labels.data()),
                 static_cast<std::streamsize>(labels.size() * sizeof(std::int32_t)));
    if (!output) throw std::runtime_error("label write failed");
  }
  std::cout << "nquad=" << NQUAD << "\n"
            << "all_free_minors=" << all_free_minors << "\n"
            << "nonzero_edges=" << nonzero_edges << "\n"
            << "successful_unions=" << successful_unions << "\n"
            << "quotient_components=" << components << "\n";
  for (int i = 0; i <= 4; ++i)
    std::cout << "minors_with_" << i << "_pivot_cells=" << pivot_histogram[i] << "\n";
  return 0;
}
