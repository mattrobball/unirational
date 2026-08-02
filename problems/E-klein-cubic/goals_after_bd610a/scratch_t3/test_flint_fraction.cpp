#include <flint/fmpz_poly.h>
#include <flint/gr.h>
#include <flint/gr_poly.h>
#include <cstdio>
int main(){
 gr_ctx_t R,K; gr_ctx_init_fmpz_poly(R); const char* n[1]={"u"}; gr_ctx_set_gen_names(R,n);
 gr_ctx_init_gr_fraction(K,R,GR_FRACTION_STRONGLY_CANONICAL); gr_ctx_set_gen_names(K,n);
 gr_ptr p=gr_heap_init(R); int sp=gr_set_str(p,"u^2+1",R); printf("pstatus=%d\n",sp);
 gr_ptr x=gr_heap_init(K); int s=gr_set_other(x,p,R,K); printf("status=%d\n",s);
 gr_stream_t st; gr_stream_init_file(st,stdout); gr_write(st,x,K); puts("");
 gr_heap_clear(x,K); gr_heap_clear(p,R); gr_ctx_clear(K); gr_ctx_clear(R);
}
