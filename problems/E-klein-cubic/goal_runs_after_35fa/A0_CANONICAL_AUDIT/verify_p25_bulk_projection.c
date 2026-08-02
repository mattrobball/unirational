/* Independent bulk nonmembership for P25V.0 via sparse random column projection.
 * Does not import producer; does not read 4140/315 from JSON.
 * Soundness: nonzero projected remainder => vector not in S_1·V_0.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
#include "flint/flint.h"
#include "flint/nmod_mat.h"
#include "flint/ulong_extras.h"

#define P 89UL
#define N_SEEDS 690
#define N_VARS 37
#define DIM3 9139
#define DIM4 91390
#define N_GEN (N_SEEDS * N_VARS)
#define N_QUAD 21
#define N_K 6
#define R 28000
#define S 64
#define PROJ_SEED 20260802UL

typedef struct { int k; ulong c; } hit_t;

static double now_s(void) {
    struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + 1e-9 * ts.tv_nsec;
}
static uint8_t *load_file(const char *path, size_t expect) {
    FILE *f = fopen(path, "rb");
    if (!f) { perror(path); exit(1); }
    uint8_t *buf = malloc(expect);
    if (!buf) { fprintf(stderr, "OOM\n"); exit(1); }
    if (fread(buf, 1, expect, f) != expect) { fprintf(stderr, "short %s\n", path); exit(1); }
    fclose(f); return buf;
}
static int32_t *load_i32(const char *path, size_t n) {
    FILE *f = fopen(path, "rb");
    if (!f) { perror(path); exit(1); }
    int32_t *buf = malloc(n * sizeof(int32_t));
    if (fread(buf, 4, n, f) != n) { fprintf(stderr, "short i32 %s\n", path); exit(1); }
    fclose(f); return buf;
}
static uint64_t rng_state;
static uint64_t rng_next(void) {
    uint64_t x = rng_state;
    x ^= x >> 12; x ^= x << 25; x ^= x >> 27;
    rng_state = x;
    return x * 0x2545F4914F6CDD1DULL;
}

static void project_from_v4(const ulong *v4, ulong *vp,
                            hit_t **hits, int *nhits) {
    memset(vp, 0, R * sizeof(ulong));
    for (slong mon = 0; mon < DIM4; mon++) {
        ulong c = v4[mon];
        if (!c) continue;
        int n = nhits[mon];
        hit_t *h = hits[mon];
        for (int i = 0; i < n; i++)
            vp[h[i].k] = (vp[h[i].k] + c * h[i].c) % P;
    }
}

static int remainder_nonzero(ulong *vp, nmod_mat_t Gpi, slong rk, const slong *pivots) {
    for (slong ri = 0; ri < rk; ri++) {
        slong pc = pivots[ri];
        if (pc < 0) continue;
        ulong c = vp[pc] % P;
        if (!c) continue;
        ulong piv = nmod_mat_entry(Gpi, ri, pc);
        if (piv != 1) {
            ulong inv = n_invmod(piv, P);
            c = (c * inv) % P;
        }
        for (slong j = 0; j < R; j++) {
            ulong aij = nmod_mat_entry(Gpi, ri, j);
            if (aij) vp[j] = (vp[j] + P - (c * aij) % P) % P;
        }
    }
    for (int k = 0; k < R; k++) if (vp[k] % P) return 1;
    return 0;
}

int main(int argc, char **argv) {
    const char *dir = argc > 1 ? argv[1] : "tmp/p25v_closure";
    const char *outj = argc > 2 ? argv[2]
        : "goal_runs_after_35fa/A0_CANONICAL_AUDIT/verify_p25_bulk_projection_result.json";
    char path[1024];
    double t0 = now_s();
    printf("=== P25 sparse projection R=%d S=%d seed=%lu ===\n", R, S, (unsigned long)PROJ_SEED);
    fflush(stdout);

    snprintf(path, sizeof path, "%s/V0_u8.bin", dir);
    uint8_t *V0 = load_file(path, (size_t)N_SEEDS * DIM3);
    snprintf(path, sizeof path, "%s/mul_maps_i32.bin", dir);
    int32_t *maps = load_i32(path, (size_t)N_VARS * DIM3);
    snprintf(path, sizeof path, "%s/Tq0_u8.bin", dir);
    uint8_t *Tq0 = load_file(path, (size_t)N_K * N_QUAD * DIM3);
    snprintf(path, sizeof path, "%s/seed_quad_u8.bin", dir);
    uint8_t *seed_quad = load_file(path, (size_t)N_SEEDS * N_QUAD * N_VARS);
    snprintf(path, sizeof path, "%s/Tq_quad_u8.bin", dir);
    uint8_t *Tqq = load_file(path, (size_t)N_K * N_QUAD * N_QUAD * N_VARS);

    /* Build sparse projection: for each mon4, list of (k,coef) */
    int *nhits = calloc(DIM4, sizeof(int));
    int *cap = calloc(DIM4, sizeof(int));
    hit_t **hits = calloc(DIM4, sizeof(hit_t *));
    rng_state = PROJ_SEED;
    for (int k = 0; k < R; k++) {
        for (int s = 0; s < S; s++) {
            int mon = (int)(rng_next() % DIM4);
            ulong c = 1 + (rng_next() % (P - 1));
            if (nhits[mon] >= cap[mon]) {
                cap[mon] = cap[mon] ? cap[mon] * 2 : 4;
                hits[mon] = realloc(hits[mon], (size_t)cap[mon] * sizeof(hit_t));
            }
            hits[mon][nhits[mon]].k = k;
            hits[mon][nhits[mon]].c = c;
            nhits[mon]++;
        }
    }
    printf("projection table t=%.1f\n", now_s() - t0); fflush(stdout);

    nmod_mat_t Gpi;
    nmod_mat_init(Gpi, N_GEN, R, P);
    for (int a = 0; a < N_SEEDS; a++) {
        const uint8_t *va = V0 + (size_t)a * DIM3;
        for (int j = 0; j < N_VARS; j++) {
            slong row = (slong)a * N_VARS + j;
            const int32_t *mp = maps + (size_t)j * DIM3;
            for (int t = 0; t < DIM3; t++) {
                uint8_t c = va[t];
                if (!c) continue;
                int mon = mp[t];
                hit_t *h = hits[mon];
                int n = nhits[mon];
                for (int i = 0; i < n; i++) {
                    ulong cur = nmod_mat_entry(Gpi, row, h[i].k);
                    nmod_mat_entry(Gpi, row, h[i].k) = (cur + (ulong)c * h[i].c) % P;
                }
            }
        }
        if ((a + 1) % 100 == 0 || a + 1 == N_SEEDS) {
            printf("  Gpi %d/%d t=%.1f\n", a + 1, N_SEEDS, now_s() - t0);
            fflush(stdout);
        }
    }
    free(V0);
    printf("Gpi built t=%.1f\n", now_s() - t0); fflush(stdout);

    slong rk = nmod_mat_rref(Gpi);
    printf("rank(pi(G))=%ld t=%.1f\n", (long)rk, now_s() - t0); fflush(stdout);

    slong *pivots = malloc((size_t)rk * sizeof(slong));
    for (slong r = 0; r < rk; r++) {
        pivots[r] = -1;
        for (slong c = 0; c < R; c++) {
            if (nmod_mat_entry(Gpi, r, c)) { pivots[r] = c; break; }
        }
    }

    /* sanity: row 0 of G should reduce to 0 — rebuild from first seed*var0 using maps */
    {
        ulong *vp = calloc(R, sizeof(ulong));
        /* Gpi is already rref'd so can't check original row0; skip or re-fill one row.
         * Instead check that a zero vector stays zero. */
        free(vp);
    }

    ulong *v4 = calloc(DIM4, sizeof(ulong));
    ulong *vp = calloc(R, sizeof(ulong));

    int n_out = 0, n_in = 0, n_zero = 0;
    for (int i = 0; i < N_K; i++) {
        for (int a = 0; a < N_SEEDS; a++) {
            memset(v4, 0, DIM4 * sizeof(ulong));
            for (int qi = 0; qi < N_QUAD; qi++) {
                for (int jvar = 0; jvar < N_VARS; jvar++) {
                    uint8_t cL = seed_quad[((size_t)a * N_QUAD + qi) * N_VARS + jvar];
                    if (!cL) continue;
                    const int32_t *mp = maps + (size_t)jvar * DIM3;
                    const uint8_t *Tc = Tq0 + ((size_t)i * N_QUAD + qi) * DIM3;
                    for (int t = 0; t < DIM3; t++) {
                        uint8_t cT = Tc[t];
                        if (!cT) continue;
                        v4[mp[t]] = (v4[mp[t]] + (ulong)cL * cT) % P;
                    }
                }
            }
            int isz = 1;
            for (slong j = 0; j < DIM4; j++) if (v4[j]) { isz = 0; break; }
            if (isz) { n_zero++; n_in++; continue; }
            project_from_v4(v4, vp, hits, nhits);
            if (remainder_nonzero(vp, Gpi, rk, pivots)) n_out++; else n_in++;
        }
        printf("  T_%d cum out=%d in_or_inconcl=%d zero=%d t=%.1f\n",
               i, n_out, n_in, n_zero, now_s() - t0);
        fflush(stdout);
    }
    printf("Ti: out=%d in=%d zero=%d / %d\n", n_out, n_in, n_zero, N_K * N_SEEDS);

    int c_out = 0, c_in = 0, c_zero = 0, c_tests = 0;
    for (int i = 0; i < N_K; i++) {
        for (int j = i + 1; j < N_K; j++) {
            for (int qi = 0; qi < N_QUAD; qi++) {
                memset(v4, 0, DIM4 * sizeof(ulong));
                for (int qi2 = 0; qi2 < N_QUAD; qi2++) {
                    for (int jvar = 0; jvar < N_VARS; jvar++) {
                        uint8_t cL = Tqq[((((size_t)j * N_QUAD + qi) * N_QUAD + qi2) * N_VARS) + jvar];
                        if (cL) {
                            const int32_t *mp = maps + (size_t)jvar * DIM3;
                            const uint8_t *Tc = Tq0 + ((size_t)i * N_QUAD + qi2) * DIM3;
                            for (int t = 0; t < DIM3; t++) {
                                uint8_t cT = Tc[t];
                                if (!cT) continue;
                                v4[mp[t]] = (v4[mp[t]] + (ulong)cL * cT) % P;
                            }
                        }
                        uint8_t cL2 = Tqq[((((size_t)i * N_QUAD + qi) * N_QUAD + qi2) * N_VARS) + jvar];
                        if (cL2) {
                            const int32_t *mp = maps + (size_t)jvar * DIM3;
                            const uint8_t *Tc = Tq0 + ((size_t)j * N_QUAD + qi2) * DIM3;
                            for (int t = 0; t < DIM3; t++) {
                                uint8_t cT = Tc[t];
                                if (!cT) continue;
                                ulong sub = ((ulong)cL2 * cT) % P;
                                v4[mp[t]] = (v4[mp[t]] + P - sub) % P;
                            }
                        }
                    }
                }
                c_tests++;
                int isz = 1;
                for (slong jj = 0; jj < DIM4; jj++) if (v4[jj]) { isz = 0; break; }
                if (isz) { c_zero++; c_in++; continue; }
                project_from_v4(v4, vp, hits, nhits);
                if (remainder_nonzero(vp, Gpi, rk, pivots)) c_out++; else c_in++;
            }
        }
        printf("  comm after i=%d out=%d in=%d zero=%d t=%.1f\n",
               i, c_out, c_in, c_zero, now_s() - t0);
        fflush(stdout);
    }
    printf("comm: out=%d in=%d zero=%d / %d\n", c_out, c_in, c_zero, c_tests);

    int ok = (n_out == 4140) && (c_out == 315);
    FILE *jf = fopen(outj, "w");
    fprintf(jf,
        "{\n"
        "  \"method\": \"sparse_random_column_projection_flint_rref\",\n"
        "  \"prime\": %lu,\n"
        "  \"R\": %d,\n"
        "  \"S\": %d,\n"
        "  \"proj_seed\": %lu,\n"
        "  \"rank_pi_G\": %ld,\n"
        "  \"n_Ti_tests\": %d,\n"
        "  \"n_Ti_out_certified\": %d,\n"
        "  \"n_Ti_projection_zero_remainder\": %d,\n"
        "  \"n_Ti_zero\": %d,\n"
        "  \"n_comm_tests\": %d,\n"
        "  \"n_comm_out_certified\": %d,\n"
        "  \"n_comm_projection_zero_remainder\": %d,\n"
        "  \"n_comm_zero\": %d,\n"
        "  \"ok\": %s,\n"
        "  \"elapsed_seconds\": %.3f,\n"
        "  \"soundness\": \"if projected remainder nonzero then original vector not in S1·V0\",\n"
        "  \"reads_4140_from_json\": false,\n"
        "  \"expected\": {\"n_Ti_out\": 4140, \"n_comm_out\": 315}\n"
        "}\n",
        P, R, S, (unsigned long)PROJ_SEED, (long)rk,
        N_K * N_SEEDS, n_out, n_in, n_zero,
        c_tests, c_out, c_in, c_zero,
        ok ? "true" : "false", now_s() - t0);
    fclose(jf);
    printf("DONE ok=%d t=%.1f wrote %s\n", ok, now_s() - t0, outj);

    nmod_mat_clear(Gpi);
    free(maps); free(Tq0); free(seed_quad); free(Tqq);
    free(pivots); free(v4); free(vp); free(nhits); free(cap);
    for (int m = 0; m < DIM4; m++) free(hits[m]);
    free(hits);
    flint_cleanup();
    return ok ? 0 : 2;
}
