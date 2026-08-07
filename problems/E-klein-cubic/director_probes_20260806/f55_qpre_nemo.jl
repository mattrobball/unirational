#!/usr/bin/env julia
# ============================================================================
# f55_qpre_nemo.jl  --  INDEPENDENT SECOND ENGINE for the Q-preimage question
#
#   Does the mixed-fan witness field d LIFT to the Theorem-Q form?  I.e. is there
#   an integral-sloped PL h on the mixed fan and a sigma-INVARIANT integral-sloped
#   PL m with
#          2h + h.sigma^{-1} - e2*  =  d + m          as functions on N ?
#
#   Slope frame (U_f(C) in Lambda = Z^5/diag, last coordinate normalised to 0):
#          2 U_h(C) + sigma_*(U_h(sigma^{-1}C)) - e2  =  U_d(C) + U_m(C)     (**)
#   subject to  U_h(C)-U_h(C') in Z nu_W  and  U_m(C)-U_m(C') in Z nu_W  at every
#   wall W, and  U_m(sigma C) = sigma_*(U_m(C)).
#
# ENGINE.  Julia 1.12 + Nemo/Hecke (FLINT).  The system is 19780 x 5232 but has
# only ~4 nonzeros per row, and neither Nemo nor PARI ships a sparse exact solver
# (FLINT's own kernel/HNF on the 1022 x 1093 dense reduction ran > 10 min).  So
# the decisive elimination is a hand-written streaming modular echelon in
# compiled Julia (no modulus in the inner loop), while FLINT/Nemo supplies
#   * an INDEPENDENT rank/consistency cross-check over GF(p)  (stage 9),
#   * the Dixon solve of the 1078 x 1078 exact-rational core  (stage 10),
#   * Hecke.saturate and the integer left inverse that PROVE the kernel basis is
#     saturated, which is what turns the decision into a finite check.
#
# STAGES.  1 data - 2 fan rebuilt from sign vectors - 3 sigma_* derived+verified -
# 4 the multiplier-free wall encoding - 5 the slope-frame reduction checked
# pointwise - 6 assembly - 7 modular sweep + block ranks - 8/9 the exact Z-
# reduction - 10 the verdict - 11 negative controls - 12 timings - 13/14 whether
# the lift can be taken CONVEX (= support function of a lattice polytope).
#
# INPUT.  f55_qpre_data_P34.json (and P01) written by f55_qpre_export.py.  That
# JSON carries only: the 20 primitive normals in a stated order, a map
# sign-vector-string -> U_d, and the walls as pairs of sign-vector-strings plus a
# normal index.  Everything else (chamber set, adjacency, sigma-action, orbits,
# sigma_* on Lambda) is rebuilt HERE from the sign vectors and re-verified
# numerically against lattice points.
#
# Reproduce:  julia f55_qpre_nemo.jl            # pattern {3,4}
#             julia f55_qpre_nemo.jl P01        # pattern {0,1}
# ============================================================================
using Printf, Random
using Nemo
import Hecke

hdr(s) = (println("\n" * "="^78); println("== ", s); println("="^78); flush(stdout))
say(s) = (println(s); flush(stdout))

# ------------------------------------------------------------------ tiny JSON
mutable struct JP; b::Vector{UInt8}; i::Int; end
@inline function skipws!(p::JP)
    @inbounds while p.i <= length(p.b) && (p.b[p.i] == 0x20 || p.b[p.i] == 0x0a ||
                                           p.b[p.i] == 0x0d || p.b[p.i] == 0x09)
        p.i += 1
    end
end
function jstr(p::JP)
    @assert p.b[p.i] == UInt8('"'); p.i += 1
    j = p.i
    @inbounds while p.b[j] != UInt8('"'); j += 1; end
    s = String(copy(p.b[p.i:j-1])); p.i = j + 1; return s
end
function jval(p::JP)
    skipws!(p); c = p.b[p.i]
    if c == UInt8('{')
        p.i += 1; d = Dict{String,Any}(); skipws!(p)
        p.b[p.i] == UInt8('}') && (p.i += 1; return d)
        while true
            skipws!(p); k = jstr(p); skipws!(p)
            @assert p.b[p.i] == UInt8(':'); p.i += 1
            d[k] = jval(p); skipws!(p)
            if p.b[p.i] == UInt8(','); p.i += 1
            else; @assert p.b[p.i] == UInt8('}'); p.i += 1; break; end
        end
        return d
    elseif c == UInt8('[')
        p.i += 1; a = Any[]; skipws!(p)
        p.b[p.i] == UInt8(']') && (p.i += 1; return a)
        while true
            push!(a, jval(p)); skipws!(p)
            if p.b[p.i] == UInt8(','); p.i += 1
            else; @assert p.b[p.i] == UInt8(']'); p.i += 1; break; end
        end
        return a
    elseif c == UInt8('"')
        return jstr(p)
    else
        j = p.i; (p.b[j] == UInt8('-')) && (j += 1)
        @inbounds while j <= length(p.b) && p.b[j] >= UInt8('0') && p.b[j] <= UInt8('9'); j += 1; end
        v = parse(Int, String(p.b[p.i:j-1])); p.i = j; return v
    end
end
readjson(path) = jval(JP(read(path), 1))

# ------------------------------------------------------------- basic geometry
sigN(n) = (n[5], n[1], n[2], n[3], n[4])          # (sigma n)_j = n_{j-1 mod 5}
sigNi(n) = (n[2], n[3], n[4], n[5], n[1])
dot5(u, n) = u[1] * n[1] + u[2] * n[2] + u[3] * n[3] + u[4] * n[4] + u[5] * n[5]
lift5(u4) = (u4[1], u4[2], u4[3], u4[4], 0)
flipstr(s::String, t::Int) = String([i == t ? (s[i] == '+' ? '-' : '+') : s[i] for i in 1:20])
sgnc(c::Char) = c == '+' ? 1 : -1

function svof(NU5, n)
    s = Vector{Char}(undef, 20)
    @inbounds for t in 1:20
        v = dot5(NU5[t], n)
        v == 0 && return nothing
        s[t] = v > 0 ? '+' : '-'
    end
    return String(s)
end
crossok(dU, nu, j0) = all(dU[j] * nu[j0] == dU[j0] * nu[j] for j in 1:4)
function inZnu(dU, nu, j0)
    dU[j0] % nu[j0] != 0 && return false
    m = div(dU[j0], nu[j0])
    return all(dU[j] == m * nu[j] for j in 1:4)
end

# ---------------------------------------------------- modular decision engine
"""
Streaming row echelon of [A|b] over F_p; pivots only in the NV A-columns.
No modulus in the inner loop (entries stay below NV*p^2).
Returns (rank_Fp(A), first inconsistent input row or 0, input rows that pivoted).
"""
function ech_decide(NV::Int, ROWC, ROWV, rhsvec, p::Int)
    NROW = length(ROWC); ncol = NV + 1
    E = Vector{Vector{Int64}}(); pivsrc = Int[]
    byc = zeros(Int, ncol)
    r = Vector{Int64}(undef, ncol)
    badrow = 0
    @inbounds for ri in 1:NROW
        fill!(r, 0)
        for (k, cc) in enumerate(ROWC[ri]); r[cc] = mod(ROWV[ri][k], p); end
        r[ncol] = mod(rhsvec[ri], p)
        newpiv = false
        for c in 1:NV
            v = r[c] % p
            v == 0 && continue
            r[c] = v
            k = byc[c]
            if k == 0
                iv = invmod(v, p)
                @simd for j in c:ncol; r[j] = ((r[j] % p) * iv) % p; end
                push!(E, copy(r)); push!(pivsrc, ri); byc[c] = length(E)
                newpiv = true
                break
            else
                f = p - v; e = E[k]
                @simd for j in c:ncol; r[j] += f * e[j]; end
            end
        end
        if !newpiv && badrow == 0 && mod(r[ncol], p) != 0
            badrow = ri
        end
    end
    return length(E), badrow, pivsrc
end

"""Dense F_p solve of  M lam = rhs  with M given column-wise; nothing if insoluble."""
function densesolve(nrows::Int, cols::Vector{Vector{Int64}}, rhs::Vector{Int64}, p::Int)
    nc = length(cols)
    A = zeros(Int64, nrows, nc + 1)
    @inbounds for j in 1:nc, i in 1:nrows; A[i, j] = mod(cols[j][i], p); end
    @inbounds for i in 1:nrows; A[i, nc+1] = mod(rhs[i], p); end
    pivrow = Int[]; pivc = Int[]; rr = 1
    @inbounds for c in 1:nc
        k = 0
        for i in rr:nrows; if A[i, c] != 0; k = i; break; end; end
        k == 0 && continue
        if k != rr
            for j in c:(nc+1); A[rr, j], A[k, j] = A[k, j], A[rr, j]; end
        end
        iv = invmod(A[rr, c], p)
        @simd for j in c:(nc+1); A[rr, j] = (A[rr, j] * iv) % p; end
        for i in 1:nrows
            i == rr && continue
            f = A[i, c]
            f == 0 && continue
            f = p - f
            @simd for j in c:(nc+1); A[i, j] = (A[i, j] + f * A[rr, j]) % p; end
        end
        push!(pivrow, rr); push!(pivc, c); rr += 1
        rr > nrows && break
    end
    @inbounds for i in rr:nrows
        A[i, nc+1] != 0 && return nothing
    end
    lam = zeros(Int64, nc)
    for (i, c) in zip(pivrow, pivc); lam[c] = A[i, nc+1]; end
    return lam
end

"""Row/column rank profile of A over F_p: (pivot rows, pivot columns)."""
function rank_profile(NV::Int, ROWC, ROWV, p::Int)
    NROW = length(ROWC)
    E = Vector{Vector{Int64}}(); pivsrc = Int[]; pivcol = Int[]
    byc = zeros(Int, NV); r = Vector{Int64}(undef, NV)
    @inbounds for ri in 1:NROW
        fill!(r, 0)
        for (k, cc) in enumerate(ROWC[ri]); r[cc] = mod(ROWV[ri][k], p); end
        for c in 1:NV
            v = r[c] % p
            v == 0 && continue
            r[c] = v; k = byc[c]
            if k == 0
                iv = invmod(v, p)
                @simd for j in c:NV; r[j] = ((r[j] % p) * iv) % p; end
                push!(E, copy(r)); push!(pivsrc, ri); push!(pivcol, c)
                byc[c] = length(E); break
            else
                f = p - v; e = E[k]
                @simd for j in c:NV; r[j] += f * e[j]; end
            end
        end
    end
    return pivsrc, sort(pivcol)
end

"""Particular F_p solution of [A|b] (free vars 0), or nothing when insoluble."""
function ech_particular(NV::Int, ROWC, ROWV, rhsvec, p::Int)
    NROW = length(ROWC); ncol = NV + 1
    E = Vector{Vector{Int64}}(); pcol = Int[]
    byc = zeros(Int, ncol)
    r = Vector{Int64}(undef, ncol)
    @inbounds for ri in 1:NROW
        fill!(r, 0)
        for (k, cc) in enumerate(ROWC[ri]); r[cc] = mod(ROWV[ri][k], p); end
        r[ncol] = mod(rhsvec[ri], p)
        newpiv = false
        for c in 1:NV
            v = r[c] % p
            v == 0 && continue
            r[c] = v
            k = byc[c]
            if k == 0
                iv = invmod(v, p)
                @simd for j in c:ncol; r[j] = ((r[j] % p) * iv) % p; end
                push!(E, copy(r)); push!(pcol, c); byc[c] = length(E); newpiv = true
                break
            else
                f = p - v; e = E[k]
                @simd for j in c:ncol; r[j] += f * e[j]; end
            end
        end
        !newpiv && mod(r[ncol], p) != 0 && return nothing
    end
    ord = sortperm(pcol)
    x = zeros(Int64, NV)
    @inbounds for a in length(ord):-1:1
        k = ord[a]; c = pcol[k]; e = E[k]
        s = e[ncol] % p
        for j in (c+1):NV
            ej = e[j] % p
            ej != 0 && x[j] != 0 && (s = (s - ej * x[j]) % p)
        end
        x[c] = mod(s, p)
    end
    return x
end

# ============================================================================
function main()
    T00 = time()
    TAG = length(ARGS) >= 1 ? ARGS[1] : "P34"
    DATA = joinpath(@__DIR__, "f55_qpre_data_$(TAG).json")

    # ------------------------------------------------------------ 1. the data
    hdr("1. data (only: 20 normals, sign-vector -> U_d, walls as sign-vector pairs)")
    J = readjson(DATA)
    say("file            : $(basename(DATA))  ($(filesize(DATA)) bytes)")
    say("pattern         : $(Int.(J["pattern"]))")
    NRM = [Int.(v) for v in J["normals"]]
    UDJ = J["ud"]::Dict{String,Any}
    WJ = J["walls"]::Vector{Any}
    @assert length(NRM) == 20
    say("normals         : 20   e.g. nu_1 = $(NRM[1]),  nu_11 = $(NRM[11])")
    say("chambers in map : $(length(UDJ))")
    say("walls in list   : $(length(WJ))")
    for t in 1:20
        @assert NRM[t][5] == 0 && gcd(NRM[t]...) == 1
    end
    say("all 20 normals primitive in Lambda and normalised to last coordinate 0: yes")

    SVS = sort!(collect(keys(UDJ)))
    NC = length(SVS)
    CIDX = Dict(s => i for (i, s) in enumerate(SVS))
    UD4 = [Int.(UDJ[SVS[c]])[1:4] for c in 1:NC]
    for c in 1:NC; @assert Int.(UDJ[SVS[c]])[5] == 0; end
    NU4 = [NRM[t][1:4] for t in 1:20]
    NU5 = [Tuple(NRM[t]) for t in 1:20]

    # -------------------------------------------- 2. rebuild the fan structure
    hdr("2. fan structure rebuilt from the sign vectors alone")
    adjpairs = Set{Tuple{Int,Int}}(); adjform = Dict{Tuple{Int,Int},Int}()
    for c in 1:NC, t in 1:20
        j = get(CIDX, flipstr(SVS[c], t), 0)
        if j > c
            push!(adjpairs, (c, j)); adjform[(c, j)] = t
        end
    end
    say(@sprintf("chambers = %d ; sign-vector pairs differing in exactly one of the 20 forms = %d",
                 NC, length(adjpairs)))

    WALL_I = Int[]; WALL_J = Int[]; WALL_T = Int[]; badw = 0
    for w in WJ
        a = w[1]::String; b = w[2]::String; t = Int(w[3]) + 1       # JSON index 0-based
        push!(WALL_I, CIDX[a]); push!(WALL_J, CIDX[b]); push!(WALL_T, t)
        [q for q in 1:20 if a[q] != b[q]] == [t] || (badw += 1)
    end
    NW = length(WALL_I)
    say("declared walls  = $NW ; sign vectors differ in exactly the declared normal index: $(NW-badw)/$NW")
    @assert badw == 0
    declared = Set((min(WALL_I[w], WALL_J[w]), max(WALL_I[w], WALL_J[w])) for w in 1:NW)
    say("declared wall set == independently derived one-flip adjacency set : $(declared == adjpairs)")
    @assert declared == adjpairs && length(declared) == NW
    for w in 1:NW
        @assert adjform[(min(WALL_I[w], WALL_J[w]), max(WALL_I[w], WALL_J[w]))] == WALL_T[w]
    end

    # sigma on sign vectors, DERIVED:
    #   form order A(a,b) a<b (10) then G(a,b) a<b (10);  A(a,b) reads sign(n_a-n_b),
    #   G(a,b) reads sign(H_a-H_b) with H_k(n) = <sigma^k n, G9>.  For m = sigma n,
    #   m_a - m_b = n_{a-1} - n_{b-1}  and  H_k(m) = H_{k+1}(n).
    PAIRS = [(a, b) for a in 0:4 for b in (a+1):4]
    pidx(a, b) = findfirst(==((a, b)), PAIRS)
    SIG_SRC = zeros(Int, 20); SIG_EPS = zeros(Int, 20)
    for t in 1:20
        (a, b) = PAIRS[t <= 10 ? t : t - 10]
        sh = t <= 10 ? -1 : +1
        a2 = mod(a + sh, 5); b2 = mod(b + sh, 5); off = t <= 10 ? 0 : 10
        if a2 < b2; SIG_SRC[t] = off + pidx(a2, b2); SIG_EPS[t] = 1
        else;       SIG_SRC[t] = off + pidx(b2, a2); SIG_EPS[t] = -1; end
    end
    sigsv(s::String) = String([(SIG_EPS[t] > 0 ? s[SIG_SRC[t]] :
                                (s[SIG_SRC[t]] == '+' ? '-' : '+')) for t in 1:20])

    rng = MersenneTwister(20260807)
    nsamp = 0; okmap = 0; okcell = 0
    while nsamp < 5000
        B = rand(rng, (5, 17, 60, 250))
        n0 = [rand(rng, -B:B) for _ in 1:4]
        n = (n0[1], n0[2], n0[3], n0[4], -sum(n0))
        s = svof(NU5, n); s === nothing && continue
        s2 = svof(NU5, sigN(n)); s2 === nothing && continue
        nsamp += 1
        okmap += (sigsv(s) == s2)
        okcell += (haskey(CIDX, s) && haskey(CIDX, s2))
    end
    say("sigma on sign vectors: derived map agrees with sign(sigma n) at $okmap/$nsamp lattice points")
    say("   (both sign vectors were keys of the chamber map at $okcell/$nsamp of them)")
    @assert okmap == nsamp == okcell

    SIGP = [CIDX[sigsv(SVS[c])] for c in 1:NC]
    @assert sort(SIGP) == collect(1:NC)
    INVSIG = zeros(Int, NC); for x in 1:NC; INVSIG[SIGP[x]] = x; end
    ORBREP = zeros(Int, NC); ORBK = zeros(Int, NC); REPS = Int[]; seen = falses(NC)
    for c in 1:NC
        seen[c] && continue
        push!(REPS, c); o = length(REPS); x = c
        for k in 0:4
            @assert !seen[x]
            seen[x] = true; ORBREP[x] = o; ORBK[x] = k; x = SIGP[x]
        end
        @assert x == c
    end
    NORB = length(REPS)
    say("sigma-orbits    : $NORB, every one FREE of size 5 ($(5*NORB) = $NC)")
    say(">>> DERIVED FAN COUNTS: chambers $NC, walls $NW, free sigma-orbits $NORB")
    if (NC, NW, NORB) != (1090, 2570, 218)
        say("!!! DISCREPANCY with the Python fan (expected 1090 / 2570 / 218)")
    end
    @assert (NC, NW, NORB) == (1090, 2570, 218)

    SIGW = Dict{Tuple{Int,Int},Int}()
    for w in 1:NW; SIGW[(min(WALL_I[w], WALL_J[w]), max(WALL_I[w], WALL_J[w]))] = w; end
    nwok = 0
    for w in 1:NW
        i2 = SIGP[WALL_I[w]]; j2 = SIGP[WALL_J[w]]
        nwok += haskey(SIGW, (min(i2, j2), max(i2, j2)))
    end
    say("sigma maps walls to walls: $nwok/$NW ; wall sigma-orbits: $(div(NW,5)) (all free)")
    @assert nwok == NW

    # -------------------------------------------------- 3. sigma_* on Lambda
    hdr("3. the induced action sigma_* on Lambda -- derived and verified numerically")
    shift_up(U, k) = ntuple(i -> U[mod(i - 1 + k, 5)+1], 5)
    shift_dn(U, k) = ntuple(i -> U[mod(i - 1 - k, 5)+1], 5)
    hu = 0; hd = 0; tot = 0
    for _ in 1:4000
        n0 = [rand(rng, -40:40) for _ in 1:4]
        n = (n0[1], n0[2], n0[3], n0[4], -sum(n0))
        U = ntuple(_ -> rand(rng, -40:40), 5)
        m = n
        for k in 1:4
            m = sigN(m); tot += 1
            lhs = dot5(U, m)
            hu += (lhs == dot5(shift_up(U, k), n))
            hd += (lhs == dot5(shift_dn(U, k), n))
        end
    end
    say("<U, sigma^k n> = <shift U, n>:  (shift U)_i = U_{i+k}: $hu/$tot ;  U_{i-k}: $hd/$tot")
    @assert hu == tot && hd < tot
    say("=> VERIFIED  <U, sigma^k n> = <shift_k U, n> with (shift_k U)_i = U_{(i+k) mod 5}.")
    say("   sigma_*, defined by <sigma_* U, n> = <U, sigma^{-1} n>, is therefore shift_{-1}:")
    say("   (sigma_* U)_i = U_{(i-1) mod 5}.  In the last-coordinate-0 frame of Lambda:")
    S = [0 0 0 -1; 1 0 0 -1; 0 1 0 -1; 0 0 1 -1]
    for i in 1:4; say("      S row $i = $(S[i,:])"); end
    SPOW = Vector{Matrix{Int}}(undef, 5)
    SPOW[1] = Int[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
    for k in 2:5; SPOW[k] = S * SPOW[k-1]; end
    say("   S^5 = I : $(S*SPOW[5] == SPOW[1])")
    @assert S * SPOW[5] == SPOW[1]
    bad = 0
    for _ in 1:4000
        n0 = [rand(rng, -40:40) for _ in 1:4]
        n = (n0[1], n0[2], n0[3], n0[4], -sum(n0))
        u = [rand(rng, -40:40) for _ in 1:4]
        bad += (dot5(lift5(S * u), n) != dot5(lift5(u), sigNi(n)))
    end
    say("   <S u, n> == <u, sigma^{-1} n> at 4000 random (u,n): $(4000-bad)/4000")
    @assert bad == 0
    bad = 0
    for w in 1:NW
        ii = INVSIG[WALL_I[w]]; jj = INVSIG[WALL_J[w]]
        w2 = SIGW[(min(ii, jj), max(ii, jj))]
        v = S * NU4[WALL_T[w2]]
        bad += !(v == NU4[WALL_T[w]] || v == -NU4[WALL_T[w]])
    end
    say("   S * nu(sigma^{-1}W) = +/- nu(W) at all $NW walls: $(NW-bad)/$NW")
    @assert bad == 0
    E2 = [0, 0, 1, 0]                   # e2 : n -> n_2 (0-indexed), last-coord-0 frame

    # ------------------------------ 4. the multiplier-free encoding of dU in Znu
    hdr("4. the multiplier-free encoding of  dU in Z*nu")
    J0 = [findfirst(!=(0), NU4[t]) for t in 1:20]
    nunit = count(t -> abs(NU4[t][J0[t]]) == 1, 1:20)
    say("pivot coordinate j0 = first nonzero coordinate of nu; |nu[j0]| = 1 for $nunit of 20")
    say("   |nu[j0]| per normal: $([abs(NU4[t][J0[t]]) for t in 1:20])")
    say("   A unit is NOT needed: nu is PRIMITIVE in Z^4, so dU integral and parallel to")
    say("   nu over Q already forces dU = m*nu with m in Z.  Checked exhaustively:")
    mis = 0; nchk = 0; nhit = 0
    for t in 1:20
        nu = NU4[t]; j0 = J0[t]
        for a in -3:3, b in -3:3, c in -3:3, e in -3:3
            dU = [a, b, c, e]; nchk += 1
            x = crossok(dU, nu, j0); y = inZnu(dU, nu, j0)
            mis += (x != y); nhit += x
        end
        for m in -40:40
            dU = m .* nu
            mis += !(crossok(dU, nu, j0) && inZnu(dU, nu, j0))
        end
    end
    say("   exhaustive box [-3,3]^4 for each normal ($nchk tests, $nhit of them satisfied):")
    say("   {3 cross-conditions} <=> {dU in Z*nu}  --  mismatches: $mis")
    @assert mis == 0

    # ---------------------------------- 5. verify the slope-frame reduction (**)
    function randPL(rng)
        cc = [rand(rng, -6:6) for _ in 1:20]
        aa = [rand(rng, -9:9) for _ in 1:4]
        ee = [rand(rng, -3:3) for _ in 1:5]
        U = [zeros(Int, 4) for _ in 1:NC]
        for c in 1:NC
            s = SVS[c]; u = copy(aa)
            for t in 1:20; u .+= (cc[t] * sgnc(s[t])) .* NU4[t]; end
            U[c] = u
        end
        # slope of  d.sigma^k  on C  is  shift_k U_d(sigma^k C) = S^{-k} U_d(sigma^k C)
        for k in 0:4
            ee[k+1] == 0 && continue
            M = SPOW[mod(5 - k, 5)+1]                       # S^{-k} = S^{5-k}
            for c in 1:NC
                x = c
                for _ in 1:k; x = SIGP[x]; end              # x = sigma^k C
                U[c] = U[c] .+ ee[k+1] .* (M * UD4[x])
            end
        end
        return (U, cc, aa, ee)
    end
    function evalPL(dat, n)
        (U, cc, aa, ee) = dat
        v = sum(cc[t] * abs(dot5(NU5[t], n)) for t in 1:20) + sum(aa[j] * n[j] for j in 1:4)
        m = n
        for k in 0:4
            if ee[k+1] != 0
                s = svof(NU5, m); s === nothing && return nothing
                v += ee[k+1] * dot5(lift5(UD4[CIDX[s]]), m)
            end
            m = sigN(m)
        end
        return v
    end
    wallviol(U) = count(w -> !inZnu(U[WALL_I[w]] .- U[WALL_J[w]], NU4[WALL_T[w]], J0[WALL_T[w]]),
                        1:NW)

    hdr("5. the slope-frame reduction (**) checked against POINTWISE evaluation")
    dat = randPL(rng); Uh = dat[1]
    say("random integral-sloped PL h drawn from the 29-parameter family")
    say("   h = sum_t c_t |<nu_t,.>| + <a,.> + sum_k e_k d.sigma^k ;  wall violations: $(wallviol(Uh))/$NW")
    @assert wallviol(Uh) == 0
    nb = 0; b0 = 0; b1 = 0; b2 = 0; firstbad = nothing
    for _ in 1:30000
        B = rand(rng, (5, 17, 60, 250))
        n0 = [rand(rng, -B:B) for _ in 1:4]
        n = (n0[1], n0[2], n0[3], n0[4], -sum(n0))
        s = svof(NU5, n); s === nothing && continue
        ni = sigNi(n); svof(NU5, ni) === nothing && continue
        v1 = evalPL(dat, n); v2 = evalPL(dat, ni)
        (v1 === nothing || v2 === nothing) && continue
        nb += 1
        F = 2 * v1 + v2 - n[3]                     # F = 2h + h.sigma^{-1} - e2*
        C = CIDX[s]
        lhs = 2 .* Uh[C] .+ (S * Uh[INVSIG[C]]) .- E2
        e0 = (v1 != dot5(lift5(Uh[C]), n))
        b0 += e0
        b1 += (F != dot5(lift5(lhs), n))
        b2 += (v2 != dot5(lift5(S * Uh[INVSIG[C]]), n))
        if firstbad === nothing && (e0 || F != dot5(lift5(lhs), n) ||
                                    v2 != dot5(lift5(S * Uh[INVSIG[C]]), n))
            firstbad = (n, C, v1, v2, e0)
        end
    end
    say("pointwise check at $nb random lattice points of N (FAILURES / total):")
    say("   base consistency  h(n) == <U_h(C(n)), n>                             : $b0/$nb")
    say("   slope of h.sigma^{-1} alone           ==  S U_h(sigma^{-1}C)         : $b2/$nb")
    say("   slope of F = 2h + h.sigma^{-1} - e2*  ==  2U_h(C)+S U_h(sig^{-1}C)-e2: $b1/$nb")
    if firstbad !== nothing
        (n, C, v1, v2, e0) = firstbad
        say("   FIRST FAILURE n = $n ; base-consistency failed there: $e0")
        say("     h(n) = $v1 vs <U_h(C),n> = $(dot5(lift5(Uh[C]),n))")
        say("     h(sig^-1 n) = $v2 vs <S U_h(sig^-1 C),n> = $(dot5(lift5(S*Uh[INVSIG[C]]),n))")
    end
    @assert b0 == 0 && b1 == 0 && b2 == 0 && nb > 15000
    say(">>> the slope-frame reduction (**) is VERIFIED; proceeding.")

    # ------------------------------------------------------- 6. assemble A x = b
    hdr("6. assembling the integer system")
    NV = 4 * NC + 4 * NORB
    ch(c, j) = (c - 1) * 4 + j
    cm(o, j) = 4 * NC + (o - 1) * 4 + j
    tasm = time()
    ROWC = Vector{Vector{Int32}}(); ROWV = Vector{Vector{Int64}}(); RHS = Int64[]
    acc = Dict{Int,Int64}()
    add!(k, v) = (acc[k] = get(acc, k, 0) + v)
    function pushrow!(rhs)
        cs = Int32[]; vs = Int64[]
        for k in sort!(collect(keys(acc)))
            acc[k] != 0 && (push!(cs, Int32(k)); push!(vs, acc[k]))
        end
        empty!(acc); push!(ROWC, cs); push!(ROWV, vs); push!(RHS, Int64(rhs))
    end
    nR1 = 0; nR2 = 0; nR3 = 0
    for w in 1:NW                                     # R1: h wall conditions
        i = WALL_I[w]; j = WALL_J[w]; nu = NU4[WALL_T[w]]; j0 = J0[WALL_T[w]]
        for j2 in 1:4
            j2 == j0 && continue
            add!(ch(i, j2), nu[j0]); add!(ch(j, j2), -nu[j0])
            add!(ch(i, j0), -nu[j2]); add!(ch(j, j0), nu[j2])
            pushrow!(0); nR1 += 1
        end
    end
    for w in 1:NW                                     # R2: m wall conditions
        i = WALL_I[w]; j = WALL_J[w]; nu = NU4[WALL_T[w]]; j0 = J0[WALL_T[w]]
        Ai = SPOW[ORBK[i]+1]; Aj = SPOW[ORBK[j]+1]; oi = ORBREP[i]; oj = ORBREP[j]
        for j2 in 1:4
            j2 == j0 && continue
            for l in 1:4
                add!(cm(oi, l), nu[j0] * Ai[j2, l] - nu[j2] * Ai[j0, l])
                add!(cm(oj, l), -nu[j0] * Aj[j2, l] + nu[j2] * Aj[j0, l])
            end
            pushrow!(0); nR2 += 1
        end
    end
    for c in 1:NC                                     # R3: the equation (**)
        cp = INVSIG[c]; A = SPOW[ORBK[c]+1]; o = ORBREP[c]
        for j in 1:4
            add!(ch(c, j), 2)
            for l in 1:4; S[j, l] != 0 && add!(ch(cp, l), S[j, l]); end
            for l in 1:4; A[j, l] != 0 && add!(cm(o, l), -A[j, l]); end
            pushrow!(UD4[c][j] + E2[j]); nR3 += 1
        end
    end
    NROW = length(ROWC); nnz = sum(length(x) for x in ROWC)
    say(@sprintf("unknowns  : %d   (U_h on %d chambers x 4  +  U_m on %d orbit reps x 4)",
                 NV, NC, NORB))
    say(@sprintf("rows      : %d   (R1 h-walls %d, R2 m-walls %d, R3 equation (**) %d)",
                 NROW, nR1, nR2, nR3))
    say(@sprintf("nonzeros  : %d  (%.2f per row) -- very sparse", nnz, nnz / NROW))
    TASM = time() - tasm
    say(@sprintf("assembly wall-clock: %.2f s", TASM))

    # substitution helper (exact Int64; all quantities stay far below 2^63)
    function residuals(Uhv, Umrep, rhsvec)
        x = zeros(Int64, NV)
        for c in 1:NC, j in 1:4; x[ch(c, j)] = Uhv[c][j]; end
        for o in 1:NORB, j in 1:4; x[cm(o, j)] = Umrep[o][j]; end
        bad = 0
        for r in 1:NROW
            s = Int64(0)
            for (k, cc) in enumerate(ROWC[r]); s += ROWV[r][k] * x[cc]; end
            s != rhsvec[r] && (bad += 1)
        end
        return bad
    end

    # a genuine sigma-invariant integral-sloped m, for the encoding self-test and
    # for negative control (ii):   m = sum_k g.sigma^k  for any integral-sloped g
    function randInvM(rng)
        g = randPL(rng)[1]
        Um = [zeros(Int, 4) for _ in 1:NC]
        for c in 1:NC
            x = c
            for k in 0:4
                Um[c] = Um[c] .+ (SPOW[k+1] * g[x])
                x = INVSIG[x]
            end
        end
        return Um
    end
    Um0 = randInvM(rng)
    inv_ok = count(c -> Um0[SIGP[c]] == S * Um0[c], 1:NC)
    say("self-test: a sigma-invariant integral-sloped m (m = sum_k g.sigma^k):")
    say("   U_m(sigma C) == S U_m(C) at $inv_ok/$NC chambers; wall violations $(wallviol(Um0))/$NW")
    @assert inv_ok == NC && wallviol(Um0) == 0

    # ------------------------------------------------- 7. the modular decision
    hdr("7. MAIN DECISION -- integer solvability of A x = b")
    PRIMES = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 101, 32749]
    res = Dict{Int,Tuple{Int,Int}}()
    tsw = time()
    for p in PRIMES
        t0 = time()
        rk, badr, _ = ech_decide(NV, ROWC, ROWV, RHS, p)
        res[p] = (rk, badr)
        say(@sprintf("  p = %-6d rank_Fp(A) = %5d   soluble mod p: %-5s %s   [%.1f s]",
                     p, rk, badr == 0, badr == 0 ? "" : "(first bad row #$badr)", time() - t0))
    end
    TSWEEP = time() - tsw
    FAILP = [p for p in PRIMES if res[p][2] != 0]
    OKP = [p for p in PRIMES if res[p][2] == 0]
    say("")
    say("INSOLUBLE mod p at p = $FAILP")
    say("soluble   mod p at p = $OKP")
    say(@sprintf("multi-prime sweep wall-clock: %.1f s", TSWEEP))
    # block ranks (structure diagnostics; also a consistency check on the reduction)
    i1 = 1:nR1; i2 = (nR1+1):(nR1+nR2); i3 = (nR1+nR2+1):NROW
    for (nm, idx) in (("R1 (h-walls)", i1), ("R2 (m-walls)", i2), ("R3 ((**))", i3),
                      ("R1+R3", vcat(collect(i1), collect(i3))))
        rk, _, _ = ech_decide(NV, ROWC[idx], ROWV[idx], RHS[idx], 32749)
        say(@sprintf("  block rank mod 32749: %-14s rows %5d  rank %5d", nm, length(idx), rk))
    end

    # ================================================ 8. the exact Z-reduction
    hdr("8. exact reduction: spanning tree + the lattice of integral-sloped PL h")
    # (a) Every U_h obeying the wall conditions on a SPANNING TREE of the chamber
    #     graph is  U_h(C) = u0 + sum_{e in path(root->C)} t_e nu_e  for unique
    #     integers (u0, t) -- a Z-isomorphism Z^{4+NC-1} -> {U_h : tree conditions}.
    #     R1 then reduces to the NW-(NC-1) NON-tree cross conditions.
    # (b) U_m is FORCED by (**):  U_m = 2U_h + S U_h.sigma^{-1} - e2 - U_d, and then
    #     R2 is AUTOMATIC:  each of the three terms of U_m(i)-U_m(j) already lies in
    #     Z nu_W  (for the middle one because S nu(sigma^{-1}W) = +/- nu(W), verified
    #     above, and d obeys the wall conditions).  What remains is exactly
    #        2U_h(sigma C) - S U_h(C) - S^2 U_h(sigma^{-1}C)
    #                    = (I-S) e2 + U_d(sigma C) - S U_d(C)                     (C)
    #     i.e. "the m forced by (**) is sigma-invariant".
    tred = time()
    par = zeros(Int, NC); parw = zeros(Int, NC); order = [1]
    seenb = falses(NC); seenb[1] = true
    adjl = [Tuple{Int,Int}[] for _ in 1:NC]
    for w in 1:NW
        push!(adjl[WALL_I[w]], (WALL_J[w], w)); push!(adjl[WALL_J[w]], (WALL_I[w], w))
    end
    qi = 1
    while qi <= length(order)
        u = order[qi]; qi += 1
        for (v, w) in adjl[u]
            if !seenb[v]; seenb[v] = true; par[v] = u; parw[v] = w; push!(order, v); end
        end
    end
    @assert all(seenb)
    treeid = zeros(Int, NW); ntree = 0
    for c in order[2:end]; ntree += 1; treeid[parw[c]] = ntree; end
    NP = 4 + ntree
    say("spanning tree of the chamber graph: $ntree tree edges, $(NW-ntree) non-tree walls")
    say("tree parameters: NP = 4 + $ntree = $NP")
    PATH = [Int[] for _ in 1:NC]
    for c in order[2:end]; PATH[c] = vcat(PATH[par[c]], [parw[c]]); end
    say("root-path lengths: min $(minimum(length.(PATH))), max $(maximum(length.(PATH)))")
    Uh_of(y) = [begin
                    u = y[1:4]
                    for w in PATH[c]; u = u .+ y[4+treeid[w]] .* NU4[WALL_T[w]]; end
                    u
                end for c in 1:NC]
    # self-test of the parametrisation
    ytest = [rand(rng, -5:5) for _ in 1:NP]
    Ut = Uh_of(ytest)
    ntv = count(w -> treeid[w] != 0 && !inZnu(Ut[WALL_I[w]] .- Ut[WALL_J[w]],
                                              NU4[WALL_T[w]], J0[WALL_T[w]]), 1:NW)
    say("random y in Z^NP: tree-wall condition violations $ntv/$ntree (must be 0); " *
        "non-tree violations $(wallviol(Ut))/$(NW-ntree)")
    @assert ntv == 0

    # (c) the non-tree cross conditions, in y
    R2C = Vector{Vector{Int32}}(); R2V = Vector{Vector{Int64}}(); R2B = Int64[]
    acc2 = Dict{Int,Int64}()
    add2!(k, v) = (acc2[k] = get(acc2, k, 0) + v)
    function push2!(rhs)
        cs = Int32[]; vs = Int64[]
        for k in sort!(collect(keys(acc2)))
            acc2[k] != 0 && (push!(cs, Int32(k)); push!(vs, acc2[k]))
        end
        empty!(acc2); push!(R2C, cs); push!(R2V, vs); push!(R2B, Int64(rhs))
    end
    for w in 1:NW
        treeid[w] != 0 && continue
        i = WALL_I[w]; j = WALL_J[w]; nu = NU4[WALL_T[w]]; j0 = J0[WALL_T[w]]
        pi_ = Set(PATH[i]); pj = Set(PATH[j])
        sym = union(setdiff(pi_, pj), setdiff(pj, pi_))
        for j2 in 1:4
            j2 == j0 && continue
            for e in sym
                s0 = (e in pi_) ? 1 : -1
                ne = NU4[WALL_T[e]]
                add2!(4 + treeid[e], s0 * (nu[j0] * ne[j2] - nu[j2] * ne[j0]))
            end
            push2!(0)
        end
    end
    NR2 = length(R2C)
    say("non-tree cross conditions: $NR2 rows x $NP columns, " *
        "$(sum(length(x) for x in R2C)) nonzeros")
    rkA = 0
    for p in (11, 32749, 1000003)
        rk, br, _ = ech_decide(NP, R2C, R2V, R2B, p)
        say(@sprintf("   rank mod %-8d = %d   =>  dim ker = %d", p, rk, NP - rk))
        p == 1000003 && (rkA = rk)
    end
    RHO = NP - rkA
    say(">>> the lattice Lambda_h of integral-sloped PL functions on this fan has rank $RHO")
    say(@sprintf("    [%.1f s]", time() - tred))


    # (d) the (C) rows, in the tree coordinates y
    S2 = S * S
    GC = Vector{Vector{Int32}}(); GV = Vector{Vector{Int64}}(); GB = Int64[]
    function pushG!(rhs)
        cs = Int32[]; vs = Int64[]
        for k in sort!(collect(keys(acc2)))
            acc2[k] != 0 && (push!(cs, Int32(k)); push!(vs, acc2[k]))
        end
        empty!(acc2); push!(GC, cs); push!(GV, vs); push!(GB, Int64(rhs))
    end
    function build_C_rows!(UDl)
        empty!(GC); empty!(GV); empty!(GB)
        for c in 1:NC
            sc = SIGP[c]; sci = INVSIG[c]
            for j in 1:4
                for l in 1:4
                    v = 2 * (l == j ? 1 : 0) - S[j, l] - S2[j, l]
                    v != 0 && add2!(l, v)
                end
                for e in PATH[sc]
                    ne = NU4[WALL_T[e]]; add2!(4 + treeid[e], 2 * ne[j])
                end
                for e in PATH[c]
                    ne = NU4[WALL_T[e]]
                    v = -sum(S[j, l] * ne[l] for l in 1:4); v != 0 && add2!(4 + treeid[e], v)
                end
                for e in PATH[sci]
                    ne = NU4[WALL_T[e]]
                    v = -sum(S2[j, l] * ne[l] for l in 1:4); v != 0 && add2!(4 + treeid[e], v)
                end
                rhs = (E2[j] - sum(S[j, l] * E2[l] for l in 1:4)) +
                      UDl[sc][j] - sum(S[j, l] * UDl[c][l] for l in 1:4)
                pushG!(rhs)
            end
        end
    end
    hdr("9. the exact Z-reduction: the (C) rows and the reduced system A' y = b'")
    build_C_rows!(UD4)
    say("(C) rows (sigma-invariance of the m forced by (**)): $(length(GC)) x $NP, " *
        "$(sum(length(x) for x in GC)) nonzeros")
    ytest2 = [rand(rng, -5:5) for _ in 1:NP]
    Ut2 = Uh_of(ytest2)
    bd = 0
    for c in 1:NC, j in 1:4
        ri = (c - 1) * 4 + j
        s0 = Int64(0)
        for (k, cc) in enumerate(GC[ri]); s0 += GV[ri][k] * ytest2[Int(cc)]; end
        direct = (2 .* Ut2[SIGP[c]] .- (S * Ut2[c]) .- (S2 * Ut2[INVSIG[c]]))[j]
        s0 != direct && (bd += 1)
    end
    say("   self-test of the (C) row encoding against direct slopes: $bd mismatches")
    @assert bd == 0

    APC = vcat(R2C, GC); APV = vcat(R2V, GV)
    build_C_rows!(UD4); APBmain = vcat(R2B, GB)
    NRP = length(APC)
    say("REDUCED SYSTEM A' y = b' : $NRP rows x $NP columns")
    say("   (Z-EQUIVALENT to the $NROW x $NV system of stage 6: U_h <-> y by the tree")
    say("    parametrisation, U_m forced by (**), and R2 automatic because each of the")
    say("    three pieces of U_m(i)-U_m(j) already lies in Z nu_W.)")
    for p in (5, 11, 1000003)
        rk, br, _ = ech_decide(NP, APC, APV, APBmain, p)
        say(@sprintf("   rank_Fp(A') = %4d, soluble mod %6d: %s", rk, p, br == 0))
    end
    # INDEPENDENT cross-check of the hand-rolled echelon: FLINT over GF(p)
    for p in (11, 32749)
        F = Nemo.Native.GF(p)
        Mf = zero_matrix(F, NRP, NP + 1)
        for ri in 1:NRP
            for (k, cc) in enumerate(APC[ri]); Mf[ri, Int(cc)] = F(APV[ri][k]); end
            Mf[ri, NP+1] = F(APBmain[ri])
        end
        Ma = zero_matrix(F, NRP, NP)
        for ri in 1:NRP, k in 1:length(APC[ri]); Ma[ri, Int(APC[ri][k])] = F(APV[ri][k]); end
        ra = rank(Ma); rf = rank(Mf)
        my, br, _ = ech_decide(NP, APC, APV, APBmain, p)
        say("   FLINT cross-check mod $p: rank(A') = $ra (mine $my, agree $(ra == my)); " *
            "rank[A'|b'] = $rf => soluble: $(rf == ra)")
        @assert ra == my && (rf == ra) == (br == 0)
    end

    return (; NV, NC, NORB, NW, NROW, ROWC, ROWV, RHS, res, PRIMES, FAILP, OKP,
            SVS, CIDX, UD4, NU4, NU5, J0, WALL_I, WALL_J, WALL_T, SIGP, INVSIG,
            ORBREP, ORBK, REPS, S, S2, SPOW, E2, ch, cm, residuals, randPL, randInvM,
            wallviol, evalPL, rng, TASM, TSWEEP, T00, svof, inZnu,
            NP, PATH, treeid, Uh_of, R2C, R2V, R2B, RHO, order, par, parw,
            APC, APV, APBmain, NRP, GC, GV, GB, build_C_rows!)
end

const R = main()

# ============================================================================
# 10. THE EXACT INTEGER DECISION  (Dixon over Q + the saturated kernel)
# ============================================================================
# Method.  A' y = b' with A' of rank r.
#   * Dixon-solve a nonsingular r x r core to get the EXACT rational solution
#     y_Q = w/d and, with the same factorisation, an integer kernel matrix K0.
#     Verifying A' w = d b' and A' K0 = 0 on EVERY row (BigInt) proves Q-solubility
#     and pins ker_Q.
#   * Saturate K0 -> K and exhibit an integer left inverse P with P K = I.  That
#     PROVES K is a Z-basis of ker_Z(A') (v in Z^n cap ker_Q  =>  v = K (P v)).
#   * Then for any integer solution y:  d y - w  in ker_Q cap Z^n = K Z^k, so
#     d y = w + K s with s in Z^k, and applying P forces s = -P w.  Hence
#         an integer solution exists  <=>  (I - K P) w == 0  (mod d),
#     and if it does, y = (w + K s)/d is one.  In the negative case every row phi
#     of (I - K P) with d does-not-divide phi.w is a complete certificate:
#     phi.K = 0, so phi.(d y) = phi.w for EVERY solution y, forcing d | phi.w.
function decide_Z(APC, APV, bvec, NP, tag)
    t0 = time()
    psrc, pcol = rank_profile(NP, APC, APV, 1000003)
    r = length(psrc)
    pset = Set(pcol)
    fcol = [c for c in 1:NP if !(c in pset)]
    say(@sprintf("  [%s] rank profile mod 1000003: rank %d, %d free columns", tag, r, length(fcol)))
    nrhs = 1 + length(fcol)
    Bq = zero_matrix(Nemo.QQ, r, r); Cq = zero_matrix(Nemo.QQ, r, nrhs)
    pcpos = Dict(c => i for (i, c) in enumerate(pcol))
    fcpos = Dict(c => i for (i, c) in enumerate(fcol))
    for (a, ri) in enumerate(psrc)
        for (k, cc) in enumerate(APC[ri])
            c = Int(cc); v = APV[ri][k]
            haskey(pcpos, c) ? (Bq[a, pcpos[c]] = v) : (Cq[a, 1+fcpos[c]] = -v)
        end
        Cq[a, 1] = bvec[ri]
    end
    X = Nemo.solve(Bq, Cq; side = :right)
    say(@sprintf("  [%s] Dixon solve %dx%d with %d right-hand sides   [%.1f s]",
                 tag, r, r, nrhs, time() - t0))
    den = BigInt(1)
    for i in 1:r; den = lcm(den, BigInt(denominator(X[i, 1]))); end
    w = zeros(BigInt, NP)
    for i in 1:r
        w[pcol[i]] = BigInt(numerator(X[i, 1])) * div(den, BigInt(denominator(X[i, 1])))
    end
    bad = 0
    for ri in 1:length(APC)
        s = BigInt(0)
        for (k, cc) in enumerate(APC[ri]); s += APV[ri][k] * w[Int(cc)]; end
        s != den * bvec[ri] && (bad += 1)
    end
    say(@sprintf("  [%s] exact rational solution y_Q = w/d with d = %s;  A' w == d b' on %d/%d rows",
                 tag, string(den), length(APC) - bad, length(APC)))
    bad != 0 && return (; ok = false, qsoluble = false, den = den)
    nk = length(fcol)
    K0 = [zeros(BigInt, NP) for _ in 1:nk]
    for j in 1:nk
        dj = BigInt(1)
        for i in 1:r; dj = lcm(dj, BigInt(denominator(X[i, 1+j]))); end
        for i in 1:r
            K0[j][pcol[i]] = BigInt(numerator(X[i, 1+j])) * div(dj, BigInt(denominator(X[i, 1+j])))
        end
        K0[j][fcol[j]] = dj
        g = BigInt(0); for v in K0[j]; g = gcd(g, v); end
        g > 1 && (K0[j] = K0[j] .÷ g)
    end
    Kz = zero_matrix(Nemo.ZZ, nk, NP)
    for j in 1:nk, i in 1:NP; Kz[j, i] = K0[j][i]; end
    Ks = Hecke.saturate(Kz)
    K = [[BigInt(Ks[j, i]) for i in 1:NP] for j in 1:nk]
    badk = 0
    for ri in 1:length(APC), j in 1:nk
        s = BigInt(0)
        for (k, cc) in enumerate(APC[ri]); s += APV[ri][k] * K[j][Int(cc)]; end
        s != 0 && (badk += 1)
    end
    say(@sprintf("  [%s] kernel rank %d; A' K == 0 exactly at %d/%d of the products",
                 tag, nk, length(APC) * nk - badk, length(APC) * nk))
    @assert badk == 0
    fl, Pt = can_solve_with_solution(Ks, identity_matrix(Nemo.ZZ, nk); side = :right)
    @assert fl
    P = [[BigInt(Pt[i, j]) for i in 1:NP] for j in 1:nk]
    for j in 1:nk, l in 1:nk
        @assert sum(P[j][i] * K[l][i] for i in 1:NP) == (j == l ? 1 : 0)
    end
    say("  [$tag] integer left inverse P with P K = I_$nk verified exactly")
    say("  [$tag]    => K is a Z-BASIS of the SATURATED lattice ker_Z(A')")
    s = [-sum(P[j][i] * w[i] for i in 1:NP) for j in 1:nk]
    q = [w[i] + sum(K[j][i] * s[j] for j in 1:nk) for i in 1:NP]         # (I - K P) w
    resid = [mod(q[i], den) for i in 1:NP]
    nzi = [i for i in 1:NP if resid[i] != 0]
    ysol = isempty(nzi) ? [div(q[i], den) for i in 1:NP] : BigInt[]
    return (; ok = isempty(nzi), qsoluble = true, den, w, K, P, s, q, resid, nzi, nk,
            fcol, pcol, psrc, r, ysol, t = time() - t0)
end

# ---------------------------------------------------------------- verification
"""Full end-to-end check of a candidate integer y: rebuild h and m and substitute."""
function Uh_from_y(y)
    [begin
         u = BigInt.(y[1:4])
         for w in R.PATH[c]; u = u .+ y[4+R.treeid[w]] .* R.NU4[R.WALL_T[w]]; end
         u
     end for c in 1:R.NC]
end
verify_lift(y, UDl; label = "", npts = 25000) =
    verify_lift_U(Uh_from_y(y), UDl; label = label, npts = npts)

"""Wall multipliers of a PL field U: U(i)-U(j) = t_w * nu, oriented so that nu > 0
   on the chamber i.  U is CONVEX iff every t_w >= 0 (support function iff t_w >= 0)."""
function multw(U)
    [begin
         i = R.WALL_I[w]; j = R.WALL_J[w]; tt = R.WALL_T[w]
         nu = R.NU4[tt]; j0 = R.J0[tt]
         sg = R.SVS[i][tt] == '+' ? 1 : -1
         sg * div(U[i][j0] - U[j][j0], nu[j0])
     end for w in 1:R.NW]
end

function verify_lift_U(Uh, UDl; label = "", npts = 25000)
    NC = R.NC; NW = R.NW; NORB = R.NORB
    hw = count(w -> !inZnu(Uh[R.WALL_I[w]] .- Uh[R.WALL_J[w]], R.NU4[R.WALL_T[w]],
                             R.J0[R.WALL_T[w]]), 1:NW)
    Um = [2 .* Uh[c] .+ (R.S * Uh[R.INVSIG[c]]) .- R.E2 .- UDl[c] for c in 1:NC]
    mw = count(w -> !inZnu(Um[R.WALL_I[w]] .- Um[R.WALL_J[w]], R.NU4[R.WALL_T[w]],
                             R.J0[R.WALL_T[w]]), 1:NW)
    minv = count(c -> Um[R.SIGP[c]] != R.S * Um[c], 1:NC)
    say("  $label  h wall violations $hw/$NW ; m wall violations $mw/$NW ; " *
        "m sigma-invariance failures $minv/$NC")
    # substitute into the FULL 19780 x 5232 system
    x = zeros(BigInt, R.NV)
    for c in 1:NC, j in 1:4; x[R.ch(c, j)] = Uh[c][j]; end
    for o in 1:NORB, j in 1:4; x[R.cm(o, j)] = Um[R.REPS[o]][j]; end
    rhsfull = copy(R.RHS)
    for c in 1:NC, j in 1:4
        rhsfull[R.NROW-4*NC+(c-1)*4+j] = UDl[c][j] + R.E2[j]
    end
    badr = 0
    for ri in 1:R.NROW
        s = BigInt(0)
        for (k, cc) in enumerate(R.ROWC[ri]); s += R.ROWV[ri][k] * x[Int(cc)]; end
        s != rhsfull[ri] && (badr += 1)
    end
    say("  $label  substitution into ALL $(R.NROW) rows of the FULL system: $badr violations")
    # pointwise ground truth
    rr = MersenneTwister(31337)
    nb = 0; bslope = 0; btwice = 0; bid = 0; bminv = 0
    hval(n, C) = sum(Uh[C][j] * n[j] for j in 1:4)
    for _ in 1:npts
        B = rand(rr, (5, 17, 60, 250, 900))
        n0 = [rand(rr, -B:B) for _ in 1:4]
        n = (n0[1], n0[2], n0[3], n0[4], -sum(n0))
        cs = Int[]; ok = true
        m = n
        for k in 1:5
            sv = svof(R.NU5, m)
            sv === nothing && (ok = false; break)
            push!(cs, R.CIDX[sv]); m = sigN(m)
        end
        ok || continue
        nb += 1
        # F(sigma^i n) for i = 0..4, computed from h and the fan directly
        Fv = BigInt[]
        m = n
        for i in 1:5
            Ci = cs[i]; mi = R.INVSIG[Ci]
            # sigma^{-1}(sigma^i n) is sigma^{i-1} n, whose chamber is cs[i-1]
            iprev = i == 1 ? 5 : i - 1
            mi != cs[iprev] && (bid += 1)
            v = 2 * hval(m, Ci) + sum((R.S*Uh[cs[iprev]])[j] * m[j] for j in 1:4) - m[3]
            push!(Fv, v)
            m = sigN(m)
        end
        # THE identity, pointwise:  F(x) = d(x) + m(x),  and m sigma-invariant
        dv = BigInt[]; mv = BigInt[]
        m = n
        for i in 1:5
            push!(dv, sum(UDl[cs[i]][j] * m[j] for j in 1:4))
            push!(mv, sum(Um[cs[i]][j] * m[j] for j in 1:4))
            m = sigN(m)
        end
        any(Fv[i] != dv[i] + mv[i] for i in 1:5) && (bslope += 1)
        length(unique(mv)) != 1 && (bminv += 1)
        mn = minimum(Fv)
        count(==(mn), Fv) < 2 && (btwice += 1)
    end
    say("  $label  pointwise at $nb lattice points of N (all 5 sigma-translates each):")
    say("  $label     F(x) = d(x) + m(x) exactly                    : $bslope failures")
    say("  $label     m(sigma^i n) = m(n)  (m really sigma-invariant): $bminv failures")
    say("  $label     sigma-orbit min of F attained at least TWICE   : $btwice failures")
    bid != 0 && say("  $label     chamber-index consistency errors: $bid")
    # convexity diagnostics (a convex integral-sloped PL function on a complete fan
    # IS the support function of a lattice polytope -- "Theorem Q proper")
    convviol(U) = count(<(0), multw(U))
    say("  $label  CONVEXITY across the $NW walls (0 violations <=> support function):")
    say("  $label     h : $(convviol(Uh)) violations ;  m : $(convviol(Um)) ;  " *
        "d : $(convviol(UDl))")
    return (hw, mw, minv, badr, bslope, btwice, nb)
end

# ============================================================================
hdr("10. MAIN VERDICT")
tmain = time()
DEC = decide_Z(R.APC, R.APV, R.APBmain, R.NP, "main")
say("")
if !DEC.qsoluble
    say("!!! the system is NOT soluble even over Q")
elseif DEC.ok
    say("#"^78)
    say("###  SOLVABLE OVER Z  --  the witness d DOES lift.")
    say("#"^78)
    verify_lift(DEC.ysol, R.UD4; label = "[main]")
else
    say("#"^78)
    say("###  NOT SOLVABLE OVER Z  --  the witness d does NOT lift.")
    say("#"^78)
    say("  the system IS soluble over Q (exact y_Q = w/d exhibited and verified)")
    DFAC = [(BigInt(p), e) for (p, e) in Nemo.factor(Nemo.ZZ(DEC.den))]
    say("  d = $(DEC.den) = $(join([string(p)*"^"*string(e) for (p,e) in DFAC], " * "))")
    say("  (I - K P) w has $(length(DEC.nzi)) of $(R.NP) coordinates != 0 mod d")
    i0 = DEC.nzi[1]
    phi = [(j == i0 ? BigInt(1) : BigInt(0)) -
           sum(DEC.K[l][i0] * DEC.P[l][j] for l in 1:DEC.nk) for j in 1:R.NP]
    pw = sum(phi[j] * DEC.w[j] for j in 1:R.NP)
    say("  CERTIFICATE: phi = row $i0 of (I - K P) in Z^$(R.NP), support $(count(!=(0), phi))")
    say("     phi . K  = $([sum(phi[j]*DEC.K[l][j] for j in 1:R.NP) for l in 1:DEC.nk])  (must be all 0)")
    say("     phi . w  = $pw ;  phi.w mod d = $(mod(pw, DEC.den))  (must be != 0)")
    say("     every integer solution y has d*y = w + K s (s in Z^$(DEC.nk)), so")
    say("     phi.w = phi.(d y) = d * (phi.y), i.e. d | phi.w  --  CONTRADICTION.")
    ppows = Tuple{BigInt,Int}[]
    for (p, e) in DFAC
        pp = BigInt(p)
        for k in 1:e
            if any(mod(DEC.q[i], pp^k) != 0 for i in 1:R.NP)
                push!(ppows, (BigInt(p), k)); break
            end
        end
    end
    say("  smallest failing prime powers, one per prime dividing d: " *
        join([string(p) * "^" * string(k) for (p, k) in ppows], ", "))
end
say(@sprintf("stage 10 wall-clock: %.1f s", time() - tmain))

# ============================================================================
hdr("11. NEGATIVE CONTROLS")
# (i) break PL continuity of d on a single chamber -> must become insoluble
say("control (i): d' = d with U_d(C0) shifted by e_1 on ONE chamber (breaks PL continuity)")
UDbad = [copy(u) for u in R.UD4]
UDbad[7][1] += 1
say("   d' fails the wall conditions at $(R.wallviol(UDbad)) of $(R.NW) walls (must be > 0)")
rhsbad = copy(R.RHS)
for c in 1:R.NC, j in 1:4
    rhsbad[R.NROW-4*R.NC+(c-1)*4+j] = UDbad[c][j] + R.E2[j]
end
for p in (2, 3, 5, 7, 11, 32749)
    rk, br, _ = ech_decide(R.NV, R.ROWC, R.ROWV, rhsbad, p)
    say(@sprintf("   FULL system with d': rank %d, soluble mod %6d: %s", rk, p, br == 0))
end

# (ii) a d'' that provably DOES lift
say("")
say("control (ii): d'' := 2h0 + h0.sigma^{-1} - e2* - m0 for a random integral-sloped h0")
say("              and a random sigma-invariant integral-sloped m0")
h0 = R.randPL(R.rng)[1]
m0 = R.randInvM(R.rng)
UDgood = [2 .* h0[c] .+ (R.S * h0[R.INVSIG[c]]) .- R.E2 .- m0[c] for c in 1:R.NC]
say("   d'' wall violations: $(R.wallviol(UDgood))/$(R.NW) (must be 0)")
R.build_C_rows!(UDgood)
bgood = vcat(R.R2B, R.GB)
DEC2 = decide_Z(R.APC, R.APV, bgood, R.NP, "ctrl-ii")
say("   control (ii) verdict: soluble over Z = $(DEC2.ok)  (must be true)")
if DEC2.ok
    verify_lift(DEC2.ysol, UDgood; label = "[ctrl-ii]", npts = 25000)
end

# ============================================================================
hdr("12. TIMINGS AND REPRODUCTION")
say(@sprintf("assembly of the %d x %d system      : %.2f s", R.NROW, R.NV, R.TASM))
say(@sprintf("13-prime modular sweep on it        : %.1f s", R.TSWEEP))
say(@sprintf("exact integer decision (stage 10)   : %.1f s", time() - tmain))
say(@sprintf("TOTAL wall-clock                    : %.1f s", time() - R.T00))
say("")
say("reproduce:  python3 f55_qpre_export.py 3,4 0,1   &&   julia f55_qpre_nemo.jl [P34|P01]")

# ============================================================================
# 13. BONUS: is there a CONVEX lift?  ("Theorem Q proper" at this level)
# ============================================================================
# A convex integral-sloped PL function on a complete fan IS the support function
# of a lattice polytope.  The solution set of A' y = b' is  y0 + ker_Z(A'), a
# 15-dimensional affine lattice, so "does a convex lift exist?" is 2570 linear
# inequalities in 15 unknowns.  We decide the RATIONAL relaxation exactly, by
# Farkas, with a phase-1 simplex over Rational{BigInt} (16 rows x 2570 columns).
"""Phase-1 simplex over the rationals: is there x >= 0 with M x = q?  Bland's rule."""
function lp_feasible(M::Vector{Vector{Rational{BigInt}}}, q::Vector{Rational{BigInt}})
    k = length(M); m = length(M[1])
    T = [Rational{BigInt}[] for _ in 1:k]
    for i in 1:k
        sgn = q[i] < 0 ? -1 : 1
        row = vcat(sgn .* M[i], [Rational{BigInt}(j == i ? 1 : 0) for j in 1:k],
                   [sgn * q[i]])
        T[i] = row
    end
    basis = [m + i for i in 1:k]
    N = m + k
    cost(j) = j > m ? Rational{BigInt}(1) : Rational{BigInt}(0)
    for _ in 1:200000
        cB = [cost(basis[i]) for i in 1:k]
        ent = 0
        for j in 1:N
            j in basis && continue
            z = sum(cB[i] * T[i][j] for i in 1:k) - cost(j)
            if z > 0; ent = j; break; end
        end
        ent == 0 && break
        piv = 0; best = Rational{BigInt}(0)
        for i in 1:k
            if T[i][ent] > 0
                rat = T[i][N+1] / T[i][ent]
                if piv == 0 || rat < best || (rat == best && basis[i] < basis[piv])
                    best = rat; piv = i
                end
            end
        end
        piv == 0 && return (false, Rational{BigInt}[])       # unbounded: cannot happen
        pv = T[piv][ent]; T[piv] = T[piv] ./ pv
        for i in 1:k
            if i != piv && T[i][ent] != 0
                f = T[i][ent]; T[i] = T[i] .- f .* T[piv]
            end
        end
        basis[piv] = ent
    end
    cB = [cost(basis[i]) for i in 1:k]
    obj = sum(cB[i] * T[i][N+1] for i in 1:k)
    x = zeros(Rational{BigInt}, m)
    for i in 1:k; basis[i] <= m && (x[basis[i]] = T[i][N+1]); end
    return (obj == 0, x)
end

hdr("13. is there a CONVEX lift?  (support function <=> Theorem Q proper)")
tcx = time()
NWl = R.NW
# g_w . y >= 0  <=>  h convex across wall w   (with y = y0 + K z)
GW = [zeros(BigInt, R.NP) for _ in 1:NWl]
for w in 1:NWl
    i = R.WALL_I[w]; j = R.WALL_J[w]; tt = R.WALL_T[w]
    nu = R.NU4[tt]; j0 = R.J0[tt]
    sg = R.SVS[i][tt] == '+' ? 1 : -1
    pi_ = Set(R.PATH[i]); pj = Set(R.PATH[j])
    for e in union(setdiff(pi_, pj), setdiff(pj, pi_))
        s0 = (e in pi_) ? 1 : -1
        GW[w][4+R.treeid[e]] += BigInt(s0 * sg * nu[j0] * R.NU4[R.WALL_T[e]][j0])
    end
end
y0 = DEC.ysol; Kb = DEC.K; nkk = DEC.nk
Amat = [[sum(GW[w][i] * Kb[l][i] for i in 1:R.NP) for l in 1:nkk] for w in 1:NWl]
bvec2 = [sum(GW[w][i] * y0[i] for i in 1:R.NP) for w in 1:NWl]
say("convexity system: $NWl inequalities  a_w . z + b_w >= 0  in $nkk unknowns z")
say("   the lift found in stage 10 (z = 0) violates $(count(w -> bvec2[w] < 0, 1:NWl)) of them")
say("   the CONCAVE alternative (all signs flipped) is violated at " *
    "$(count(w -> bvec2[w] > 0, 1:NWl)) walls")
# Farkas: infeasible over Q  <=>  exists lam >= 0 with sum lam_w a_w = 0, sum lam_w b_w = -1
Mrows = Vector{Vector{Rational{BigInt}}}()
for l in 1:nkk
    push!(Mrows, [Rational{BigInt}(Amat[w][l]) for w in 1:NWl])
end
push!(Mrows, [Rational{BigInt}(bvec2[w]) for w in 1:NWl])
qv = vcat([Rational{BigInt}(0) for _ in 1:nkk], [Rational{BigInt}(-1)])
fe, lam = lp_feasible(Mrows, qv)
if fe
    sup = [w for w in 1:NWl if lam[w] != 0]
    chk1 = [sum(lam[w] * Amat[w][l] for w in sup) for l in 1:nkk]
    chk2 = sum(lam[w] * bvec2[w] for w in sup)
    say("   FARKAS CERTIFICATE FOUND: lambda >= 0 with support $(length(sup)) walls,")
    say("      sum lam_w a_w = $(all(==(0), chk1) ? "0 (exact)" : string(chk1))")
    say("      sum lam_w b_w = $chk2  (must be < 0)")
    say("   => NO CONVEX (support-function) lift exists, even over Q, in the whole")
    say("      15-dimensional solution family.  THEOREM Q PROPER IS NOT TOUCHED by")
    say("      the stage-10 result: the lift that exists is PL but NOT convex.")
else
    say("   no Farkas certificate: the convexity inequalities ARE feasible over Q on")
    say("   the 15-dimensional solution family.  Whether an INTEGRAL z achieves them")
    say("   is a further (and now very small) question -- reported, not claimed.")
end
say(@sprintf("stage 13 wall-clock: %.1f s", time() - tcx))

# ============================================================================
# 14. AN EXPLICIT CONVEX LIFT: h is the support function of a lattice polytope
# ============================================================================
# The kernel of the homogeneous system contains every sigma-INVARIANT integral-
# sloped PL function h1 (then 2h1 + h1.sigma^{-1} = 3h1, which is sigma-invariant).
# Take   g = sum_t |<nu_t , .>|   (convex, integral-sloped, jump 2 across every
# wall of type t) and h1 = sum_k g.sigma^k : sigma-invariant and STRICTLY convex
# across every wall.  Then h + t*h1 is a lift for every t in Z, and is CONVEX for
# t large -- i.e. it is the support function of a lattice polytope.
hdr("14. an explicit CONVEX lift  (h = support function of a lattice polytope)")
tcv = time()
Ug = [sum(BigInt(R.SVS[c][t] == '+' ? 1 : -1) .* R.NU4[t] for t in 1:20) for c in 1:R.NC]
Uh1 = [begin
           v = zeros(BigInt, 4)
           x = c
           for k in 0:4
               v = v .+ R.SPOW[mod(5 - k, 5)+1] * Ug[x]
               x = R.SIGP[x]
           end
           v
       end for c in 1:R.NC]
say("h1 = sum_k g.sigma^k with g = sum_t |<nu_t,.>| :")
say("   sigma-invariance U_h1(sigma C) = S U_h1(C) : " *
    "$(count(c -> Uh1[R.SIGP[c]] == R.S * Uh1[c], 1:R.NC))/$(R.NC)")
say("   wall-condition violations : $(R.wallviol(Uh1))/$(R.NW)")
mh1 = multw(Uh1)
say("   wall multipliers of h1: min $(minimum(mh1)), max $(maximum(mh1)) " *
    "-- STRICTLY convex at every wall: $(all(>(0), mh1))")
@assert all(>(0), mh1) && R.wallviol(Uh1) == 0
Uh_main = Uh_from_y(DEC.ysol)
mh = multw(Uh_main)
tmin = maximum([mh[w] >= 0 ? BigInt(0) : cld(-mh[w], mh1[w]) for w in 1:R.NW])
say("smallest t with h + t*h1 convex : t = $tmin")
Uh_cvx = [Uh_main[c] .+ tmin .* Uh1[c] for c in 1:R.NC]
say("   convexity violations of h + $(tmin)*h1 : $(count(<(0), multw(Uh_cvx)))/$(R.NW)")
verify_lift_U(Uh_cvx, R.UD4; label = "[convex]")
Qverts = unique([Tuple(u) for u in Uh_cvx])
say("   the lattice polytope Q = conv{U_h(C)} has $(length(Qverts)) distinct slope")
say("   vectors among the $(R.NC) chambers; h = h_Q = max_C <U_h(C), . >")
# and check h really is the max of its own slopes at random lattice points
function support_check(U, npt)
    rrq = MersenneTwister(4242); okmax = 0; totq = 0
    for _ in 1:npt
        B = rand(rrq, (7, 40, 200))
        n0 = [rand(rrq, -B:B) for _ in 1:4]
        n = (n0[1], n0[2], n0[3], n0[4], -sum(n0))
        sv = svof(R.NU5, n); sv === nothing && continue
        totq += 1
        C = R.CIDX[sv]
        v = sum(U[C][j] * n[j] for j in 1:4)
        mx = maximum(sum(U[c][j] * n[j] for j in 1:4) for c in 1:R.NC)
        v == mx && (okmax += 1)
    end
    return okmax, totq
end
let (okmax, totq) = support_check(Uh_cvx, 3000)
    say("   h(n) == max_C <U_h(C), n> at $okmax/$totq random lattice points  " *
        "(=> h IS the support function of Q = conv{U_h(C)})")
end
say("")
say("#"^78)
say("###  THE WITNESS d LIFTS WITH h CONVEX -- h is the support function h_Q of an")
say("###  honest lattice polytope Q, and m = F - d is sigma-invariant integral-sloped")
say("###  PL.  At the value-form level the obstruction is GONE.")
say("#"^78)
say(@sprintf("stage 14 wall-clock: %.1f s", time() - tcv))
