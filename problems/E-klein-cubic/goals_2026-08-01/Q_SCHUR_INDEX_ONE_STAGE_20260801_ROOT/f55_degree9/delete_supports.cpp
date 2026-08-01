#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <unordered_set>
#include <vector>
using namespace std;

struct Mask {
  uint64_t low, high;
  bool operator==(Mask const &other) const {
    return low == other.low && high == other.high;
  }
};
struct MaskHash {
  size_t operator()(Mask const &mask) const {
    return mask.low ^
           (mask.high + 0x9e3779b97f4a7c15ULL + (mask.low << 6) +
            (mask.low >> 2));
  }
};
struct Occurrence {
  int equation;
  Mask term;
};

vector<vector<Mask>> equations;
vector<vector<Occurrence>> occurrences;
vector<int> active_count;
unordered_set<Mask, MaskHash> seen;
uint64_t nodes = 0;
int number_variables;

inline bool subset(Mask term, Mask support) {
  return (term.low & support.low) == term.low &&
         (term.high & support.high) == term.high;
}
inline int population(Mask mask) {
  return __builtin_popcountll(mask.low) + __builtin_popcountll(mask.high);
}
inline bool bit(Mask mask, int index) {
  return index < 64 ? (mask.low >> index) & 1
                    : (mask.high >> (index - 64)) & 1;
}

// Reverse equation order is the frozen certificate order.  Among singleton
// monomials choose one using the fewest distinct coefficient variables.
Mask singleton(Mask support, bool &has_singleton) {
  has_singleton = false;
  Mask best{0, 0};
  int best_size = 4;
  for (int offset = 0; offset < (int)equations.size(); ++offset) {
    int equation = (int)equations.size() - 1 - offset;
    if (active_count[equation] != 1)
      continue;
    Mask only{0, 0};
    for (auto iterator = equations[equation].rbegin();
         iterator != equations[equation].rend(); ++iterator) {
      if (subset(*iterator, support)) {
        only = *iterator;
        break;
      }
    }
    int size = population(only);
    if (size < best_size) {
      best = only;
      best_size = size;
      has_singleton = true;
      if (size == 1)
        return best;
    }
  }
  return best;
}

bool delete_tree(Mask support) {
  if (!seen.insert(support).second)
    return false;
  ++nodes;
  if (nodes % 1000000 == 0)
    cerr << "NODES=" << nodes << " SUPPORT_SIZE=" << population(support)
         << "\n";

  bool has_singleton;
  Mask witness = singleton(support, has_singleton);
  if (!has_singleton) {
    if (support.low || support.high) {
      cout << "FOUND_STOPPING_SUPPORT SIZE=" << population(support) << "\n";
      return true;
    }
    return false;
  }

  vector<int> variables;
  for (int variable = 0; variable < number_variables; ++variable)
    if (bit(witness, variable))
      variables.push_back(variable);
  // Frozen reverse-order branch rule: lower occurrence count first.
  sort(variables.begin(), variables.end(), [](int left, int right) {
    return occurrences[left].size() < occurrences[right].size();
  });

  for (int variable : variables) {
    vector<int> changed;
    changed.reserve(occurrences[variable].size());
    for (auto const &occurrence : occurrences[variable]) {
      if (subset(occurrence.term, support)) {
        --active_count[occurrence.equation];
        changed.push_back(occurrence.equation);
      }
    }
    Mask child = support;
    if (variable < 64)
      child.low &= ~(1ULL << variable);
    else
      child.high &= ~(1ULL << (variable - 64));
    bool found = delete_tree(child);
    for (int equation : changed)
      ++active_count[equation];
    if (found)
      return true;
  }
  return false;
}

int main(int argc, char **argv) {
  if (argc != 2)
    return 2;
  ifstream input(argv[1], ios::binary);
  uint32_t variable_count, equation_count;
  input.read((char *)&variable_count, 4);
  input.read((char *)&equation_count, 4);
  number_variables = variable_count;
  equations.resize(equation_count);
  occurrences.resize(variable_count);
  active_count.resize(equation_count);
  size_t term_count = 0;
  for (int equation = 0; equation < (int)equation_count; ++equation) {
    uint32_t count;
    input.read((char *)&count, 4);
    equations[equation].resize(count);
    active_count[equation] = count;
    term_count += count;
    for (Mask &term : equations[equation]) {
      input.read((char *)&term.low, 8);
      input.read((char *)&term.high, 8);
      for (int variable = 0; variable < number_variables; ++variable)
        if (bit(term, variable))
          occurrences[variable].push_back({equation, term});
    }
  }
  if (!input || number_variables != 65 || equation_count != 2860 ||
      term_count != 697125)
    return 3;

  Mask full{~0ULL, 1ULL};
  cout << "INSTANCE VARIABLES=65 EQUATIONS=2860 TERMS=697125 ORDER=REVERSE\n";
  bool found = delete_tree(full);
  cout << "RESULT " << (found ? "FOUND_STOPPING_SUPPORT" : "NO_STOPPING_SUPPORT")
       << " NODES=" << nodes << " SEEN=" << seen.size() << "\n";
  return found ? 1 : 0;
}
