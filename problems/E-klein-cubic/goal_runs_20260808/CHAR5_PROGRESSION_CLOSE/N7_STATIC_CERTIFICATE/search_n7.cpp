#include <algorithm>
#include <array>
#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <limits>
#include <map>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

// Exact development search for the root-degree-seven Boolean support system.
// This generator is not itself the certificate verifier.  It reconstructs the
// F_5 landing rows exactly and uses only integer bit masks.

namespace {

constexpr int P = 5;
constexpr int N = 5;
constexpr int ROOT_DEGREE = 7;
constexpr std::array<int, N> W = {1, 9, 4, 3, 5};

using Exp = std::array<int, N>;
using Mask = std::uint64_t;

std::uint64_t encode_exp(const Exp &e) {
  std::uint64_t key = 0;
  for (int x : e) key = key * 128 + static_cast<unsigned>(x);
  return key;
}

Exp rho(const Exp &e, int power) {
  power %= N;
  Exp out{};
  for (int j = 0; j < N; ++j) out[j] = e[(j - power + N) % N];
  return out;
}

std::vector<Exp> exponent_basis(int degree, int wanted_weight) {
  std::vector<Exp> out;
  Exp e{};
  // Descending composition order agrees with Python's
  // combinations_with_replacement exponent order used by the checker.
  for (e[0] = degree; e[0] >= 0; --e[0])
    for (e[1] = degree - e[0]; e[1] >= 0; --e[1])
      for (e[2] = degree - e[0] - e[1]; e[2] >= 0; --e[2])
        for (e[3] = degree - e[0] - e[1] - e[2]; e[3] >= 0; --e[3]) {
          e[4] = degree - e[0] - e[1] - e[2] - e[3];
          int weight = 0;
          for (int j = 0; j < N; ++j) weight += e[j] * W[j];
          if ((weight % 11 + 11) % 11 == wanted_weight) out.push_back(e);
        }
  return out;
}

struct Term {
  Exp exponent;
  int coefficient;
};

struct Row {
  std::vector<Mask> terms;
};

struct System {
  int nh = 0;
  int nk = 0;
  std::vector<Row> rows;
};

System landing_system(int d, int r) {
  Exp a{}, b{};
  for (int j = 0; j < N; ++j) {
    a[j] = (d * j) % P;
    b[j] = (a[j] + r) % P;
  }
  int wa = 0, wb = 0;
  for (int j = 0; j < N; ++j) {
    wa += a[j] * W[j];
    wb += b[j] * W[j];
  }
  wa %= 11;
  wb %= 11;
  int wh = 9 * (1 - wa);
  int wk = 9 * (1 - wb);
  wh = (wh % 11 + 11) % 11;
  wk = (wk % 11 + 11) % 11;
  auto hb = exponent_basis(ROOT_DEGREE, wh);
  auto kb = exponent_basis(ROOT_DEGREE, wk);

  System system;
  system.nh = static_cast<int>(hb.size());
  system.nk = static_cast<int>(kb.size());
  if (system.nh + system.nk > 64) {
    std::cerr << "too many Boolean variables\n";
    std::exit(2);
  }

  std::vector<Term> support;
  support.reserve(system.nh + system.nk);
  for (int i = 0; i < system.nh; ++i) {
    Exp e{};
    for (int j = 0; j < N; ++j) e[j] = a[j] + 5 * hb[i][j];
    support.push_back({e, i});
  }
  for (int i = 0; i < system.nk; ++i) {
    Exp e{};
    for (int j = 0; j < N; ++j) e[j] = b[j] + 5 * kb[i][j];
    support.push_back({e, system.nh + i});
  }

  // equations[target][sorted coefficient triple] is its coefficient mod 5.
  // The coefficient triple is encoded in base 64.
  std::unordered_map<std::uint64_t,
                     std::unordered_map<std::uint32_t, unsigned char>> equations;
  equations.reserve(12000);
  std::array<std::vector<Term>, N> shifted;
  for (int s = 0; s < N; ++s) {
    shifted[s].reserve(support.size());
    for (const auto &term : support)
      shifted[s].push_back({rho(term.exponent, s), term.coefficient});
  }
  for (int shift = 0; shift < N; ++shift) {
    const auto &current = shifted[shift];
    const auto &following = shifted[(shift + 1) % N];
    for (const auto &t1 : current)
      for (const auto &t2 : current)
        for (const auto &t3 : following) {
          Exp target{};
          for (int j = 0; j < N; ++j)
            target[j] = t1.exponent[j] + t2.exponent[j] + t3.exponent[j];
          std::array<int, 3> c = {t1.coefficient, t2.coefficient,
                                  t3.coefficient};
          std::sort(c.begin(), c.end());
          std::uint32_t monomial =
              static_cast<std::uint32_t>((c[0] * 64 + c[1]) * 64 + c[2]);
          auto &value = equations[encode_exp(target)][monomial];
          value = static_cast<unsigned char>((value + 1) % P);
        }
  }

  std::vector<std::pair<std::uint64_t,
                        std::unordered_map<std::uint32_t, unsigned char> *>>
      ordered;
  ordered.reserve(equations.size());
  for (auto &target_row : equations)
    ordered.push_back({target_row.first, &target_row.second});
  std::sort(ordered.begin(), ordered.end(),
            [](const auto &x, const auto &y) { return x.first < y.first; });

  system.rows.reserve(equations.size());
  for (auto &target_row : ordered) {
    Row row;
    row.terms.reserve(target_row.second->size());
    for (const auto &entry : *target_row.second) {
      if (entry.second == 0) continue;
      std::uint32_t code = entry.first;
      int c2 = code % 64;
      code /= 64;
      int c1 = code % 64;
      int c0 = code / 64;
      Mask mask = (Mask{1} << c0) | (Mask{1} << c1) | (Mask{1} << c2);
      row.terms.push_back(mask);
    }
    if (!row.terms.empty()) system.rows.push_back(std::move(row));
  }
  return system;
}

struct State {
  Mask yes = 0;
  Mask no = 0;
};

struct StateHash {
  std::size_t operator()(const State &s) const noexcept {
    std::uint64_t x = s.yes + 0x9e3779b97f4a7c15ULL;
    x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9ULL;
    x = (x ^ (x >> 27)) * 0x94d049bb133111ebULL;
    x ^= x >> 31;
    return static_cast<std::size_t>(x ^ (s.no + (s.no << 13)));
  }
};

bool operator==(const State &a, const State &b) {
  return a.yes == b.yes && a.no == b.no;
}

class Search {
 public:
  explicit Search(const System &system)
      : system_(system), n_(system.nh + system.nk),
        all_(n_ == 64 ? ~Mask{0} : (Mask{1} << n_) - 1),
        h_((Mask{1} << system.nh) - 1), k_(all_ ^ h_), occurrence_(n_, 0) {
    for (const auto &row : system_.rows)
      for (Mask term : row.terms)
        for (int v = 0; v < n_; ++v)
          if ((term >> v) & 1) ++occurrence_[v];
  }

  bool solve(Mask &witness) { return dfs({0, 0}, witness); }

  bool prove(std::vector<unsigned char> &certificate) {
    proof_nodes_ = 0;
    proof_leaves_ = 0;
    return prove_dfs({0, 0}, certificate);
  }

  std::uint64_t nodes() const { return nodes_; }
  std::uint64_t leaves() const { return leaves_; }
  std::size_t cache_size() const { return unsat_.size(); }
  std::uint64_t proof_nodes() const { return proof_nodes_; }
  std::uint64_t proof_leaves() const { return proof_leaves_; }

 private:
  bool propagate(State &state) {
    while (true) {
      if (state.yes & state.no) return false;
      bool changed = false;
      Mask unknown = all_ ^ (state.yes | state.no);

      for (Mask group : {h_, k_}) {
        if (state.yes & group) continue;
        Mask candidates = unknown & group;
        if (!candidates) return false;
        if ((candidates & (candidates - 1)) == 0) {
          state.yes |= candidates;
          unknown &= ~candidates;
          changed = true;
        }
      }

      for (const auto &row : system_.rows) {
        int active = 0;
        int possible = 0;
        Mask common = all_;
        Mask only = 0;
        for (Mask term : row.terms) {
          if (term & state.no) continue;
          ++possible;
          if ((term & ~state.yes) == 0) {
            ++active;
            if (active >= 2) break;
          } else {
            common &= term;
            only = term;
          }
        }
        if (active >= 2) continue;
        if (active == 1) {
          if (possible == 1) return false;
          Mask forced = common & unknown;
          if (forced) {
            state.yes |= forced;
            unknown &= ~forced;
            changed = true;
          }
        } else if (possible == 1) {
          Mask kill = only & unknown;
          if (!kill) return false;
          if ((kill & (kill - 1)) == 0) {
            state.no |= kill;
            unknown &= ~kill;
            changed = true;
          }
        }
      }
      if (!changed) return true;
    }
  }

  static void put_u16(std::vector<unsigned char> &out, unsigned value) {
    out.push_back(static_cast<unsigned char>(value & 255));
    out.push_back(static_cast<unsigned char>((value >> 8) & 255));
  }

  static void put_u64(std::vector<unsigned char> &out, Mask value) {
    for (int i = 0; i < 8; ++i)
      out.push_back(static_cast<unsigned char>((value >> (8 * i)) & 255));
  }

  bool propagate_record(State &state, std::vector<unsigned char> &out) {
    while (true) {
      if (state.yes & state.no) {
        std::cerr << "unexpected overlapping recorded state\n";
        std::exit(3);
      }
      bool changed = false;
      Mask unknown = all_ ^ (state.yes | state.no);

      int group_id = 0;
      for (Mask group : {h_, k_}) {
        if (state.yes & group) {
          ++group_id;
          continue;
        }
        Mask candidates = unknown & group;
        if (!candidates) {
          out.push_back(4);  // conflict: nonzero group exhausted
          out.push_back(static_cast<unsigned char>(group_id));
          return false;
        }
        if ((candidates & (candidates - 1)) == 0) {
          int variable = __builtin_ctzll(candidates);
          out.push_back(1);  // force the sole remaining group variable true
          out.push_back(static_cast<unsigned char>(group_id));
          out.push_back(static_cast<unsigned char>(variable));
          state.yes |= candidates;
          unknown &= ~candidates;
          changed = true;
        }
        ++group_id;
      }

      for (unsigned row_id = 0; row_id < system_.rows.size(); ++row_id) {
        const auto &row = system_.rows[row_id];
        int active = 0;
        int possible = 0;
        Mask common = all_;
        Mask only = 0;
        for (Mask term : row.terms) {
          if (term & state.no) continue;
          ++possible;
          if ((term & ~state.yes) == 0) {
            ++active;
            if (active >= 2) break;
          } else {
            common &= term;
            only = term;
          }
        }
        if (active >= 2) continue;
        if (active == 1) {
          if (possible == 1) {
            out.push_back(5);  // conflict: exactly one active term
            put_u16(out, row_id);
            return false;
          }
          Mask forced = common & unknown;
          if (forced) {
            out.push_back(2);  // force a common alternative support true
            put_u16(out, row_id);
            put_u64(out, forced);
            state.yes |= forced;
            unknown &= ~forced;
            changed = true;
          }
        } else if (possible == 1) {
          Mask kill = only & unknown;
          if (!kill) {
            std::cerr << "unexpected recorded row classification\n";
            std::exit(3);
          }
          if ((kill & (kill - 1)) == 0) {
            int variable = __builtin_ctzll(kill);
            out.push_back(3);  // force the sole undecided factor false
            put_u16(out, row_id);
            out.push_back(static_cast<unsigned char>(variable));
            state.no |= kill;
            unknown &= ~kill;
            changed = true;
          }
        }
      }
      if (!changed) return true;
    }
  }

  int choose(const State &state) const {
    Mask unknown = all_ ^ (state.yes | state.no);
    Mask critical = 0;
    for (const auto &row : system_.rows) {
      int active = 0;
      Mask candidates = 0;
      for (Mask term : row.terms) {
        if (term & state.no) continue;
        if ((term & ~state.yes) == 0) {
          ++active;
          if (active >= 2) break;
        } else {
          candidates |= term & unknown;
        }
      }
      if (active == 1) critical |= candidates;
    }
    Mask pool = critical ? critical : unknown;
    int best = -1;
    std::uint64_t score = 0;
    while (pool) {
      int v = __builtin_ctzll(pool);
      // Prefer the larger index on ties.  The exponent basis is in the
      // checker's descending lexicographic order, so this is the relabeling
      // of the generator's empirically smaller ascending-order proof tree.
      if (best < 0 || occurrence_[v] >= score) {
        best = v;
        score = occurrence_[v];
      }
      pool &= pool - 1;
    }
    return best;
  }

  bool dfs(State state, Mask &witness) {
    ++nodes_;
    if (!propagate(state)) {
      ++leaves_;
      return false;
    }
    if ((state.yes | state.no) == all_) {
      witness = state.yes;
      return true;
    }
    if (unsat_.find(state) != unsat_.end()) return false;
    int variable = choose(state);
    Mask bit = Mask{1} << variable;
    // Sparse supports first.
    State zero = state;
    zero.no |= bit;
    if (dfs(zero, witness)) return true;
    State nonzero = state;
    nonzero.yes |= bit;
    if (dfs(nonzero, witness)) return true;
    unsat_.insert(state);
    return false;
  }

  bool prove_dfs(State state, std::vector<unsigned char> &out) {
    ++proof_nodes_;
    if (!propagate_record(state, out)) {
      ++proof_leaves_;
      return true;
    }
    if ((state.yes | state.no) == all_) return false;
    int variable = choose(state);
    out.push_back(7);  // exhaustive Boolean branch, zero child then one child
    out.push_back(static_cast<unsigned char>(variable));
    Mask bit = Mask{1} << variable;
    State zero = state;
    zero.no |= bit;
    if (!prove_dfs(zero, out)) return false;
    State nonzero = state;
    nonzero.yes |= bit;
    return prove_dfs(nonzero, out);
  }

  const System &system_;
  int n_;
  Mask all_, h_, k_;
  std::vector<std::uint64_t> occurrence_;
  std::unordered_set<State, StateHash> unsat_;
  std::uint64_t nodes_ = 0;
  std::uint64_t leaves_ = 0;
  std::uint64_t proof_nodes_ = 0;
  std::uint64_t proof_leaves_ = 0;
};

}  // namespace

int main(int argc, char **argv) {
  int only_d = 0, only_r = 0;
  bool emit = argc == 3 && std::string(argv[1]) == "--emit";
  std::string emit_path;
  if (emit) {
    emit_path = argv[2];
  } else if (argc == 3) {
    only_d = std::atoi(argv[1]);
    only_r = std::atoi(argv[2]);
  }
  std::vector<unsigned char> certificate;
  if (emit) {
    certificate.insert(certificate.end(), {'N', '7', 'P', '1'});
  }
  for (int d = 1; d <= 4; ++d) {
    for (int r = 1; r <= 4; ++r) {
      if (only_d && (d != only_d || r != only_r)) continue;
      auto start = std::chrono::steady_clock::now();
      System system = landing_system(d, r);
      auto built = std::chrono::steady_clock::now();
      Search search(system);
      Mask witness = 0;
      bool sat = false;
      if (!emit) sat = search.solve(witness);
      auto stopped = std::chrono::steady_clock::now();
      if (!emit) {
        std::cout << "CASE " << d << ' ' << r << " VARS "
                  << system.nh + system.nk << " ROWS " << system.rows.size()
                  << " NODES " << search.nodes() << " LEAVES "
                  << search.leaves() << " CACHE " << search.cache_size()
                  << " STATUS " << (sat ? "SAT" : "UNSAT") << " MASK "
                  << witness << " BUILD_SECONDS "
                  << std::chrono::duration<double>(built - start).count()
                  << " SEARCH_SECONDS "
                  << std::chrono::duration<double>(stopped - built).count()
                  << '\n' << std::flush;
      }
      if (emit) {
        certificate.push_back(static_cast<unsigned char>(d));
        certificate.push_back(static_cast<unsigned char>(r));
        certificate.push_back(static_cast<unsigned char>(system.nh));
        certificate.push_back(static_cast<unsigned char>(system.nk));
        std::size_t before = certificate.size();
        bool proved = search.prove(certificate);
        if (!proved) {
          std::cerr << "proof generation reached a satisfying assignment\n";
          return 5;
        }
        std::cout << "PROOF " << d << ' ' << r << " VARS "
                  << system.nh + system.nk << " ROWS " << system.rows.size()
                  << " NODES "
                  << search.proof_nodes() << " LEAVES " << search.proof_leaves()
                  << " BYTES " << certificate.size() - before << '\n'
                  << std::flush;
      }
    }
  }
  if (emit) {
    certificate.push_back(255);
    std::ofstream stream(emit_path, std::ios::binary);
    stream.write(reinterpret_cast<const char *>(certificate.data()),
                 static_cast<std::streamsize>(certificate.size()));
    if (!stream) {
      std::cerr << "failed to write certificate\n";
      return 6;
    }
    std::cout << "CERTIFICATE_BYTES " << certificate.size() << '\n';
  }
}
