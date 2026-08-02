#include <flint/fmpz.h>
#include <flint/fmpz_poly.h>
#include <flint/fmpz_mpoly_q.h>
#include <flint/gr.h>
#include <flint/gr_poly.h>
#include <flint/mpoly_types.h>

#include <array>
#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <stdexcept>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

static gr_ctx_t K;
static gr_ctx_t U_RING;
static bool SPECIALIZE_A=false;
static long A_VALUE=0;

static void check(int status, const char *where) {
  if (status != GR_SUCCESS) throw std::runtime_error(std::string(where) + " failed: " + std::to_string(status));
}

struct GPoly {
  gr_poly_t value;
  GPoly() { gr_poly_init(value, K); }
  GPoly(const GPoly &other) { gr_poly_init(value, K); check(gr_poly_set(value, other.value, K), "copy"); }
  GPoly(GPoly &&other) noexcept { gr_poly_init(value, K); gr_poly_swap(value, other.value, K); }
  GPoly &operator=(const GPoly &other) {
    if (this != &other) check(gr_poly_set(value, other.value, K), "assign");
    return *this;
  }
  GPoly &operator=(GPoly &&other) noexcept {
    if (this != &other) gr_poly_swap(value, other.value, K);
    return *this;
  }
  ~GPoly() { gr_poly_clear(value, K); }
};

struct Term {
  std::array<int, 5> e{}; // A,B,Y,Z,u
  std::string c;
};

static std::string signed_piece(const std::string &c, int a, int u, bool first) {
  std::string effective=c;
  if (SPECIALIZE_A) {
    fmpz_t value,base,power; fmpz_init(value); fmpz_init(base); fmpz_init(power);
    fmpz_set_str(value,c.c_str(),10); fmpz_set_si(base,A_VALUE); fmpz_pow_ui(power,base,a);
    fmpz_mul(value,value,power); char *s=fmpz_get_str(nullptr,10,value); effective=s; flint_free(s);
    fmpz_clear(value); fmpz_clear(base); fmpz_clear(power); a=0;
  }
  bool negative = !effective.empty() && effective[0] == '-';
  std::string abs_c = negative ? effective.substr(1) : effective;
  std::ostringstream out;
  if (!first) out << (negative ? "-" : "+");
  else if (negative) out << "-";
  out << "(" << abs_c << ")";
  if (a) out << "*A" << (a == 1 ? "" : "^" + std::to_string(a));
  if (u) out << "*u" << (u == 1 ? "" : "^" + std::to_string(u));
  return out.str();
}

static void set_specialized_u_polynomial(
    gr_ptr destination,
    const std::vector<std::tuple<int,int,std::string>> &terms) {
  fmpz_poly_t polynomial; fmpz_poly_init(polynomial);
  fmpz_t value,base,power,old; fmpz_init(value); fmpz_init(base); fmpz_init(power); fmpz_init(old);
  fmpz_set_si(base,A_VALUE);
  for (const auto &[a,u,c]:terms) {
    fmpz_set_str(value,c.c_str(),10); fmpz_pow_ui(power,base,a); fmpz_mul(value,value,power);
    fmpz_poly_get_coeff_fmpz(old,polynomial,u); fmpz_add(value,value,old);
    fmpz_poly_set_coeff_fmpz(polynomial,u,value);
  }
  gr_ptr base_element=gr_heap_init(U_RING);
  fmpz_poly_set(reinterpret_cast<fmpz_poly_struct *>(base_element),polynomial);
  check(gr_set_other(destination,base_element,U_RING,K),"embed Q[u]");
  gr_heap_clear(base_element,U_RING);
  fmpz_clear(value); fmpz_clear(base); fmpz_clear(power); fmpz_clear(old); fmpz_poly_clear(polynomial);
}

static GPoly load_rur(const std::string &path) {
  std::ifstream in(path);
  if (!in) throw std::runtime_error("cannot open " + path);
  std::string line; std::getline(in, line);
  std::map<int, std::vector<std::tuple<int,int,std::string>>> by_z;
  while (std::getline(in, line)) {
    if (line.empty()) continue;
    std::istringstream row(line);
    int a,u,z; std::string c; row >> a >> u >> z >> c;
    by_z[z].push_back({a,u,c});
  }
  GPoly answer;
  gr_ptr coefficient = gr_heap_init(K);
  for (const auto &[z, terms] : by_z) {
    if (SPECIALIZE_A) {
      set_specialized_u_polynomial(coefficient,terms);
    } else {
      std::ostringstream expression; bool first=true;
      for (const auto &[a,u,c] : terms) {
        expression << signed_piece(c,a,u,first); first=false;
      }
      check(gr_set_str(coefficient, expression.str().c_str(), K), "parse RUR coefficient");
    }
    check(gr_poly_set_coeff_scalar(answer.value, z, coefficient, K), "set RUR coefficient");
  }
  gr_heap_clear(coefficient, K);
  return answer;
}

static std::vector<Term> load_terms(const std::string &path, bool with_u=true) {
  std::ifstream in(path);
  if (!in) throw std::runtime_error("cannot open " + path);
  std::string line; std::getline(in,line);
  std::vector<Term> answer;
  while (std::getline(in,line)) {
    if (line.empty()) continue;
    std::istringstream row(line); Term t;
    if (with_u) row >> t.e[0] >> t.e[1] >> t.e[2] >> t.e[3] >> t.e[4] >> t.c;
    else row >> t.e[0] >> t.e[1] >> t.e[2] >> t.e[3] >> t.c;
    answer.push_back(std::move(t));
  }
  return answer;
}

static std::vector<Term> derivative(const std::vector<Term> &terms, const std::vector<int> &indices) {
  std::vector<Term> answer;
  fmpz_t coefficient; fmpz_init(coefficient);
  for (const Term &original : terms) {
    Term t=original; fmpz_set_str(coefficient,t.c.c_str(),10); bool zero=false;
    for (int index : indices) {
      if (!t.e[index]) { zero=true; break; }
      fmpz_mul_ui(coefficient,coefficient,t.e[index]); --t.e[index];
    }
    if (!zero) {
      char *text=fmpz_get_str(nullptr,10,coefficient); t.c=text; flint_free(text);
      answer.push_back(std::move(t));
    }
  }
  fmpz_clear(coefficient); return answer;
}

static GPoly mulmod(const GPoly &a, const GPoly &b, const GPoly &q) {
  GPoly result; check(gr_poly_mulmod(result.value,a.value,b.value,q.value,K),"mulmod"); return result;
}

static GPoly add(const GPoly &a, const GPoly &b) {
  GPoly result; check(gr_poly_add(result.value,a.value,b.value,K),"add"); return result;
}

static GPoly scalar_mul(const GPoly &a, gr_srcptr c) {
  GPoly result; check(gr_poly_mul_scalar(result.value,a.value,c,K),"scalar mul"); return result;
}

static bool is_zero(const GPoly &a) { return gr_poly_is_zero(a.value,K)==T_TRUE; }

static GPoly evaluate_cleared(
    const std::vector<Term> &terms,
    const std::vector<GPoly> &nbp,
    const std::vector<GPoly> &nyp,
    const std::vector<GPoly> &qpp,
    const std::vector<GPoly> &zp,
    const GPoly &q) {
  using Key=std::tuple<int,int,int>;
  std::map<Key,std::vector<const Term*>> groups;
  for (const Term &t:terms) groups[{t.e[1],t.e[2],t.e[3]}].push_back(&t);
  int degree=0;
  for (const Term &t:terms) degree=std::max(degree,t.e[1]+t.e[2]);
  GPoly answer;
  gr_ptr coefficient=gr_heap_init(K);
  for (const auto &[key,group]:groups) {
    const auto [b,y,z]=key;
    if (SPECIALIZE_A) {
      std::vector<std::tuple<int,int,std::string>> coefficient_terms;
      coefficient_terms.reserve(group.size());
      for (const Term *t:group) coefficient_terms.push_back({t->e[0],t->e[4],t->c});
      set_specialized_u_polynomial(coefficient,coefficient_terms);
    } else {
      std::ostringstream expression; bool first=true;
      for (const Term *t:group) {
        expression << signed_piece(t->c,t->e[0],t->e[4],first); first=false;
      }
      check(gr_set_str(coefficient,expression.str().c_str(),K),"parse source coefficient");
    }
    GPoly basis=mulmod(nbp.at(b),nyp.at(y),q);
    basis=mulmod(basis,qpp.at(degree-b-y),q);
    basis=mulmod(basis,zp.at(z),q);
    answer=add(answer,scalar_mul(basis,coefficient));
  }
  gr_heap_clear(coefficient,K); return answer;
}

static std::vector<GPoly> powers(const GPoly &x, int n, const GPoly &q) {
  std::vector<GPoly> result(n+1); check(gr_poly_one(result[0].value,K),"one");
  for (int i=1;i<=n;i++) result[i]=mulmod(result[i-1],x,q);
  return result;
}

static void report_zero(const std::string &name, const GPoly &value) {
  if (!is_zero(value)) {
    char *text=nullptr; gr_poly_get_str(&text,value.value,"Z",K);
    std::cerr << "FAIL_" << name << "=" << text << "\n"; flint_free(text);
    throw std::runtime_error(name+" nonzero");
  }
  std::cout << "REDUCE_" << name << "=0\n";
}

static void report_nonzero(const std::string &name, const GPoly &value) {
  if (is_zero(value)) throw std::runtime_error(name+" unexpectedly zero");
  std::cout << "UNIT_" << name << "=nonzero_in_irreducible_degree6_field\n";
}

int main(int argc,char **argv) try {
  if (argc!=2 && argc!=3) throw std::runtime_error("usage: verifier ROOT_E_KLEIN_CUBIC [A_VALUE]");
  const std::string root=argv[1];
  if (argc==3) { SPECIALIZE_A=true; A_VALUE=std::stol(argv[2]); }
  if (SPECIALIZE_A) {
    gr_ctx_init_fmpz_poly(U_RING);
    gr_ctx_init_gr_fraction(K,U_RING,GR_FRACTION_STRONGLY_CANONICAL);
  } else {
    gr_ctx_init_fmpz_mpoly_q(K,2,ORD_LEX);
    const char *names2[2]={"A","u"}; check(gr_ctx_set_gen_names(K,names2),"set names");
  }
  {
    const std::string here=root+"/goals_after_bd610a/scratch_t3/";
    GPoly q=load_rur(here+"generic_singular_rur_QZ.tsv");
    GPoly nb=load_rur(here+"generic_singular_rur_NB.tsv");
    GPoly ny=load_rur(here+"generic_singular_rur_NY.tsv");
    GPoly qp; check(gr_poly_derivative(qp.value,q.value,K),"derivative q");
    GPoly z; check(gr_poly_gen(z.value,K),"Z");
    auto nbp=powers(nb,10,q), nyp=powers(ny,10,q), qpp=powers(qp,10,q), zp=powers(z,16,q);

    auto P=load_terms(root+"/tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv",true);
    const std::vector<std::pair<std::string,std::vector<int>>> specs={
      {"P",{}},{"Pu",{4}},{"PA",{0}},{"PB",{1}},{"PY",{2}},{"PZ",{3}}
    };
    for (const auto &[name,spec]:specs)
      report_zero(name,evaluate_cleared(derivative(P,spec),nbp,nyp,qpp,zp,q));

    if (!SPECIALIZE_A) {
      const std::string factors=root+"/certificates/fold_normalization_t2r/saturation_factors/";
      report_nonzero("B",nb);
      const std::vector<std::tuple<std::string,std::string,bool>> gate_specs={
        {"ell","ell_lc_u.tsv",false},{"Q4","G_factor_Q4.tsv",false},
        {"Puu","P_uu.tsv",true},{"C","C_content.tsv",false},{"delta","delta_Cramer.tsv",true}
      };
      for (const auto &[name,file,with_u]:gate_specs)
        report_nonzero(name,evaluate_cleared(load_terms(factors+file,with_u),nbp,nyp,qpp,zp,q));
      report_nonzero("qprime",qp);
      std::cout << "QPRIME_UNIT_FOLLOWS_FROM_IRREDUCIBLE_Q=1\n";
      std::cout << "GENERIC_RUR_FLINT_EXACT_PASS\n";
    } else {
      std::cout << "A_SPECIALIZATION=" << A_VALUE << "\n";
      std::cout << "GENERIC_RUR_FLINT_A_FIBRE_PASS\n";
    }
  }
  gr_ctx_clear(K); if (SPECIALIZE_A) gr_ctx_clear(U_RING); return 0;
} catch (const std::exception &e) {
  std::cerr << "ERROR: " << e.what() << "\n";
  return 1;
}
