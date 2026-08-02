#include <flint/mpoly_types.h>
#include <flint/fmpz_mpoly_q.h>
#include <flint/gr.h>
#include <flint/gr_poly.h>
#include <cstdio>

int main() {
  gr_ctx_t K;
  gr_ctx_init_fmpz_mpoly_q(K, 2, ORD_LEX);
  const char *names[2] = {"A", "u"};
  if (gr_ctx_set_gen_names(K, names) != GR_SUCCESS) return 2;
  gr_poly_t q, d, g, s, t, r;
  gr_poly_init(q,K); gr_poly_init(d,K); gr_poly_init(g,K);
  gr_poly_init(s,K); gr_poly_init(t,K); gr_poly_init(r,K);
  if (gr_poly_set_str(q,"Z^2+A+u","Z",K) != GR_SUCCESS) return 3;
  if (gr_poly_set_str(d,"2*Z","Z",K) != GR_SUCCESS) return 4;
  if (gr_poly_xgcd(g,s,t,q,d,K) != GR_SUCCESS) return 5;
  gr_poly_mul(r,s,q,K);
  gr_poly_t tmp; gr_poly_init(tmp,K); gr_poly_mul(tmp,t,d,K); gr_poly_add(r,r,tmp,K);
  char *gs=nullptr, *rs=nullptr;
  gr_poly_get_str(&gs,g,"Z",K); gr_poly_get_str(&rs,r,"Z",K);
  std::puts(gs); std::puts(rs); flint_free(gs); flint_free(rs);
  gr_poly_clear(tmp,K); gr_poly_clear(q,K); gr_poly_clear(d,K); gr_poly_clear(g,K);
  gr_poly_clear(s,K); gr_poly_clear(t,K); gr_poly_clear(r,K); gr_ctx_clear(K);
}
