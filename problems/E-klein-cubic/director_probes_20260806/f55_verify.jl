#!/usr/bin/env julia
# =============================================================================
# f55_verify.jl -- INDEPENDENT SECOND-ENGINE VERIFICATION of the claimed
# nonnegative integral witness exported by f55_witness_dump.py.
#
# The ONLY input is f55_witness.json, which contains no cell indices, no orbit
# numbering, no wall list and no ray list -- just the 20 normals, a map
# (sign vector) -> slope U, and the sign vectors of the zero cells.  Everything
# else -- the normals themselves, the wall adjacency, the ray set, the sigma
# action on cells, the sigma orbits, the intersection lattice, the chamber count
# -- is recomputed here from the mathematical definitions.
#
# SETUP:
#   N   = { n in Z^5 : sum(n) = 0 }
#   sigma(n)[j] = n[(j-1) mod 5]        (0-indexed; = circshift(n, 1))
#   G9  = (1,5,3,4,9),  c9 = (4,9,1,5,3),  mu_k[j] = G9[(j+k) mod 5]
#   20 normals: e_a - e_b (a<b), then mu_a - mu_b (a<b), lex order on pairs.
#   cell(n) = the length-20 sign vector ( sign<nu_t,n> )_t   (n off all walls)
#   d(n)    = < U[cell(n)] , n >
#
# CHECKS:  (A) wall continuity   (B) integrality of the wall jumps
#          (C) exact positivity at every ray of the arrangement
#          (D) pointwise laws at >= 1e6 random lattice points
#          (E) the zero set and the sigma-orbit structure
#          (F) negative controls (the harness must be able to fail)
#          (G) cross-check against (n,d) samples carried in the JSON
#          (H) Oscar/polymake independent fan computation
#
# Run:  julia f55_verify.jl        (env: F55_OSCAR=0 skips (H),
#                                        F55_NPTS=<n> changes the (D) budget)
# =============================================================================

using Random
const T00 = time()
hdr(s) = println("\n", "="^78, "\n== ", s, "\n", "="^78)

# ----------------------------------------------------------------------------
# 0.  a minimal JSON reader (JSON.jl is not in this depot's default environment)
# ----------------------------------------------------------------------------
mutable struct JR
    b::Vector{UInt8}
    i::Int
end
@inline function jskip(p::JR)
    while p.i <= length(p.b) && (p.b[p.i] == 0x20 || p.b[p.i] == 0x09 ||
                                 p.b[p.i] == 0x0a || p.b[p.i] == 0x0d)
        p.i += 1
    end
end
function jstr(p::JR)
    @assert p.b[p.i] == UInt8('"')
    p.i += 1
    st = p.i
    while p.b[p.i] != UInt8('"')
        p.b[p.i] == UInt8('\\') && error("escapes not supported in this reader")
        p.i += 1
    end
    s = String(p.b[st:p.i-1]); p.i += 1
    return s
end
function jval(p::JR)
    jskip(p)
    c = p.b[p.i]
    if c == UInt8('{')
        p.i += 1; d = Dict{String,Any}(); jskip(p)
        p.b[p.i] == UInt8('}') && (p.i += 1; return d)
        while true
            jskip(p); k = jstr(p); jskip(p)
            @assert p.b[p.i] == UInt8(':'); p.i += 1
            d[k] = jval(p); jskip(p)
            p.b[p.i] == UInt8(',') && (p.i += 1; continue)
            @assert p.b[p.i] == UInt8('}'); p.i += 1; return d
        end
    elseif c == UInt8('[')
        p.i += 1; a = Any[]; jskip(p)
        p.b[p.i] == UInt8(']') && (p.i += 1; return a)
        while true
            push!(a, jval(p)); jskip(p)
            p.b[p.i] == UInt8(',') && (p.i += 1; continue)
            @assert p.b[p.i] == UInt8(']'); p.i += 1; return a
        end
    elseif c == UInt8('"')
        return jstr(p)
    else
        st = p.i
        while p.i <= length(p.b) &&
              (p.b[p.i] in (UInt8('-'), UInt8('+'), UInt8('.'), UInt8('e'), UInt8('E')) ||
               (p.b[p.i] >= UInt8('0') && p.b[p.i] <= UInt8('9')))
            p.i += 1
        end
        s = String(p.b[st:p.i-1])
        v = tryparse(Int64, s)
        return v === nothing ? parse(Float64, s) : v
    end
end
readjson(path) = jval(JR(read(path), 1))

# ----------------------------------------------------------------------------
# 1.  the definitions
# ----------------------------------------------------------------------------
const G9 = (1, 5, 3, 4, 9)
const C9 = (4, 9, 1, 5, 3)
mu(k) = ntuple(i -> G9[mod(i - 1 + k, 5)+1], 5)     # mu_k[j] = G9[(j+k) mod 5]

const PAIRS = [(a, b) for a in 0:4 for b in (a+1):4]        # lex order, 0-indexed
const PIDX = Dict(PAIRS[i] => i for i in eachindex(PAIRS))

const NORM = let L = NTuple{5,Int64}[]
    for (a, b) in PAIRS                                     # A4 block: e_a - e_b
        v = zeros(Int64, 5); v[a+1] = 1; v[b+1] = -1
        push!(L, NTuple{5,Int64}(v))
    end
    for (a, b) in PAIRS                                     # G9 block: mu_a - mu_b
        ma = mu(a); mb = mu(b)
        push!(L, ntuple(i -> Int64(ma[i] - mb[i]), 5))
    end
    L
end
const NM = let M = Matrix{Int64}(undef, 20, 5)
    for t in 1:20, j in 1:5; M[t, j] = NORM[t][j]; end
    M
end
const A4 = [ntuple(j -> NORM[t][j] - NORM[t][5], 4) for t in 1:20]   # N (x) Q = Q^4

@inline sig(n::NTuple{5,Int64}) = (n[5], n[1], n[2], n[3], n[4])
@inline dot5(u::NTuple{5,Int64}, n::NTuple{5,Int64}) =
    u[1]*n[1] + u[2]*n[2] + u[3]*n[3] + u[4]*n[4] + u[5]*n[5]

const ONWALL = typemax(UInt32)
@inline function ckey(n::NTuple{5,Int64})::UInt32
    k = UInt32(0)
    @inbounds for t in 1:20
        v = NM[t,1]*n[1] + NM[t,2]*n[2] + NM[t,3]*n[3] + NM[t,4]*n[4] + NM[t,5]*n[5]
        v == 0 && return ONWALL
        v > 0 && (k |= (UInt32(1) << (t - 1)))
    end
    return k
end
function str2key(s::AbstractString)
    @assert length(s) == 20
    k = UInt32(0)
    for (t, ch) in enumerate(s)
        ch == '+' ? (k |= (UInt32(1) << (t - 1))) : (@assert ch == '-')
    end
    k
end

# Lambda = Z^5 / (1,1,1,1,1)
@inline nz(v::NTuple{5,Int64}) = (v[1]-v[5], v[2]-v[5], v[3]-v[5], v[4]-v[5], 0)
function intmult(w::NTuple{5,Int64}, v::NTuple{5,Int64})    # w == m*v in Lambda ?
    W = nz(w); V = nz(v)
    j = 0
    for i in 1:5; if V[i] != 0; j = i; break; end; end
    j == 0 && return (all(==(0), W), 0)
    W[j] % V[j] != 0 && return (false, 0)
    m = W[j] ÷ V[j]
    return (all(W[i] == m * V[i] for i in 1:5), m)
end

# sigma on sign vectors, DERIVED:
#   <e_a - e_b,  sigma n> = <e_{a-1} - e_{b-1}, n>
#   <mu_a - mu_b, sigma n> = <mu_{a+1} - mu_{b+1}, n>
const SRC, EPS = let S = zeros(Int, 20), E = zeros(Int, 20)
    for (idx, (a, b)) in enumerate(PAIRS)
        a2, b2 = mod(a - 1, 5), mod(b - 1, 5)
        a2 < b2 ? (S[idx] = PIDX[(a2, b2)]; E[idx] = 1) :
                  (S[idx] = PIDX[(b2, a2)]; E[idx] = -1)
        a3, b3 = mod(a + 1, 5), mod(b + 1, 5)
        a3 < b3 ? (S[10+idx] = 10 + PIDX[(a3, b3)]; E[10+idx] = 1) :
                  (S[10+idx] = 10 + PIDX[(b3, a3)]; E[10+idx] = -1)
    end
    (S, E)
end
@inline function sigkey(k::UInt32)
    r = UInt32(0)
    @inbounds for t in 1:20
        bit = (k >> (SRC[t] - 1)) & UInt32(1)
        EPS[t] < 0 && (bit ⊻= UInt32(1))
        bit == 1 && (r |= UInt32(1) << (t - 1))
    end
    r
end

# --- exact rational linear algebra on Q^4 -----------------------------------
function rref_rat(rows::Vector{Vector{Rational{BigInt}}}, d::Int)
    A = [copy(r) for r in rows]; m = length(A); piv = Int[]; r0 = 1
    for col in 1:d
        pr = 0
        for i in r0:m
            if A[i][col] != 0; pr = i; break; end
        end
        pr == 0 && continue
        A[r0], A[pr] = A[pr], A[r0]
        pv = A[r0][col]; A[r0] = A[r0] ./ pv
        for i in 1:m
            if i != r0 && A[i][col] != 0
                f = A[i][col]; A[i] = A[i] .- f .* A[r0]
            end
        end
        push!(piv, col); r0 += 1
    end
    return A[1:r0-1], piv
end
ratrow(t::Int) = Rational{BigInt}[Rational{BigInt}(A4[t][j]) for j in 1:4]
rank_of(ts) = length(rref_rat([ratrow(t) for t in ts], 4)[2])
function inspan(R, piv, v)
    w = copy(v)
    for (i, c) in enumerate(piv)
        if w[c] != 0; f = w[c]; w = w .- f .* R[i]; end
    end
    all(==(0), w)
end
function prim4(v::Vector{BigInt})
    g = BigInt(0)
    for x in v; g = gcd(g, abs(x)); end
    Tuple(Int64.(v .÷ g))
end

struct Pattern
    tag::String
    U::Dict{UInt32,NTuple{5,Int64}}
    zeros::Set{UInt32}
end

# --- exact phase-1 simplex (Bland's rule, Rational{BigInt}): is u in cone(G)? --
function in_cone(G::Vector{NTuple{4,Int64}}, u::NTuple{4,Int64})
    n = length(G); m = 4; N = n + m
    T = zeros(Rational{BigInt}, m, N + 1)
    for i in 1:m
        sgn = u[i] < 0 ? -1 : 1
        for j in 1:n; T[i, j] = Rational{BigInt}(sgn * G[j][i]); end
        T[i, n+i] = 1
        T[i, N+1] = Rational{BigInt}(sgn * u[i])
    end
    basis = [n + i for i in 1:m]
    cost(j) = j <= n ? Rational{BigInt}(0) : Rational{BigInt}(1)
    for _ in 1:20000
        cb = [cost(basis[i]) for i in 1:m]
        ent = 0
        for j in 1:N
            j in basis && continue
            z = sum(cb[i] * T[i, j] for i in 1:m) - cost(j)
            if z > 0; ent = j; break; end            # Bland: first improving column
        end
        ent == 0 && break
        piv = 0; best = Rational{BigInt}(0)
        for i in 1:m
            if T[i, ent] > 0
                rat = T[i, N+1] / T[i, ent]
                if piv == 0 || rat < best || (rat == best && basis[i] < basis[piv])
                    best = rat; piv = i
                end
            end
        end
        piv == 0 && return false
        pv = T[piv, ent]
        for j in 1:(N+1); T[piv, j] /= pv; end
        for i in 1:m
            if i != piv && T[i, ent] != 0
                f = T[i, ent]
                for j in 1:(N+1); T[i, j] -= f * T[piv, j]; end
            end
        end
        basis[piv] = ent
    end
    return sum(cost(basis[i]) * T[i, N+1] for i in 1:m) == 0
end
u4(U::NTuple{5,Int64}) = (U[1]-U[5], U[2]-U[5], U[3]-U[5], U[4]-U[5])

# ---------------------------------------------------------------- check (D) --
const BOXES = (5, 20, 100, 1000)
function checkD(U::Dict{UInt32,NTuple{5,Int64}}, npts::Int, seed::Int;
                c9::NTuple{5,Int64} = NTuple{5,Int64}(C9),
                bumpkey::UInt32 = ONWALL)
    Random.seed!(seed)
    tested = 0; skipped = 0; miss = 0; hits = 0
    vneg = 0; vmin2 = 0; vminzero = 0; vcong = 0
    perbox = Dict(B => 0 for B in BOXES)
    while tested < npts
        B = BOXES[rand(1:4)]
        g1 = rand(-B:B); g2 = rand(-B:B); g3 = rand(-B:B); g4 = rand(-B:B)
        n = (g1, g2, g3, g4, -(g1 + g2 + g3 + g4))
        m = n; ok = true; hit = false
        v1 = 0; v2 = 0; v3 = 0; v4 = 0; v5 = 0
        for k in 0:4
            kk = ckey(m)
            if kk == ONWALL; ok = false; break; end
            u = get(U, kk, nothing)
            if u === nothing; ok = false; miss += 1; break; end
            x = dot5(u, m)
            if kk == bumpkey; x += 1; hit = true; end
            k == 0 ? (v1 = x) : k == 1 ? (v2 = x) : k == 2 ? (v3 = x) :
                k == 3 ? (v4 = x) : (v5 = x)
            m = sig(m)
        end
        if !ok; skipped += 1; continue; end
        tested += 1; perbox[B] += 1; hit && (hits += 1)
        mn = min(v1, v2, v3, v4, v5)
        mn < 0 && (vneg += 1)
        ((v1 == mn) + (v2 == mn) + (v3 == mn) + (v4 == mn) + (v5 == mn)) < 2 &&
            (vmin2 += 1)
        mn != 0 && (vminzero += 1)
        s = v1 + 9*v2 + 81*v3 + 729*v4 + 6561*v5 +
            c9[1]*n[1] + c9[2]*n[2] + c9[3]*n[3] + c9[4]*n[4] + c9[5]*n[5]
        mod(s, 11) != 0 && (vcong += 1)
    end
    return (tested = tested, skipped = skipped, miss = miss, hits = hits,
            neg = vneg, min2 = vmin2, minzero = vminzero, cong = vcong,
            perbox = perbox)
end

# ------------------------------------------------------- check (D2): on walls --
# d extends continuously to the closed cells, so it is defined at EVERY point of
# N -- including the ~27% of lattice points that lie on some wall and that (D)
# throws away.  To evaluate d there without any wall/face bookkeeping: push the
# point slightly into a chamber along a fixed generic direction w,
#      n  ->  M*n + w ,  M = 1 + max_t |<nu_t, w>| ,
# which keeps every nonzero sign of n and resolves every zero sign by w.  The
# resulting chamber contains n in its closure, so d(n) = <U_that chamber, n>.
# Two independent directions w1, w2 must give the SAME value -- that is the
# continuity statement at the most degenerate points there are.
function dclosed(U::Dict{UInt32,NTuple{5,Int64}}, n::NTuple{5,Int64},
                 w::NTuple{5,Int64}, M::Int64)
    np = ntuple(i -> M * n[i] + w[i], 5)
    k = ckey(np)
    k == ONWALL && return (false, 0)
    u = get(U, k, nothing)
    u === nothing && return (false, 0)
    return (true, dot5(u, n))
end
function checkD_closed(U::Dict{UInt32,NTuple{5,Int64}}, npts::Int, seed::Int,
                       WS::Vector{Tuple{NTuple{5,Int64},Int64}})
    Random.seed!(seed)
    tested = 0; bad = 0; onwall = 0; ambig = 0
    vneg = 0; vmin2 = 0; vminzero = 0; vcong = 0
    c9 = NTuple{5,Int64}(C9)
    while tested < npts
        B = BOXES[rand(1:4)]
        g1 = rand(-B:B); g2 = rand(-B:B); g3 = rand(-B:B); g4 = rand(-B:B)
        n = (g1, g2, g3, g4, -(g1 + g2 + g3 + g4))
        m = n; ok = true; wallpt = false
        v = (0, 0, 0, 0, 0)
        for k in 0:4
            ckey(m) == ONWALL && (wallpt = true)
            x1 = 0; first = true
            for (w, M) in WS
                o, x = dclosed(U, m, w, M)
                if !o; ok = false; bad += 1; break; end
                if first; x1 = x; first = false
                elseif x != x1; ambig += 1; end
            end
            ok || break
            v = ntuple(q -> q == k + 1 ? x1 : v[q], 5)
            m = sig(m)
        end
        ok || continue
        tested += 1; wallpt && (onwall += 1)
        mn = min(v...)
        mn < 0 && (vneg += 1)
        count(==(mn), v) < 2 && (vmin2 += 1)
        mn != 0 && (vminzero += 1)
        s = v[1] + 9*v[2] + 81*v[3] + 729*v[4] + 6561*v[5] +
            c9[1]*n[1] + c9[2]*n[2] + c9[3]*n[3] + c9[4]*n[4] + c9[5]*n[5]
        mod(s, 11) != 0 && (vcong += 1)
    end
    return (tested = tested, onwall = onwall, bad = bad, ambig = ambig, neg = vneg,
            min2 = vmin2, minzero = vminzero, cong = vcong)
end

# ============================================================================
function main()
    HERE = dirname(abspath(@__FILE__))
    JPATH = joinpath(HERE, "f55_witness.json")

    hdr("0. definitions rebuilt from scratch; JSON read")
    J = readjson(JPATH)
    println("  read $(JPATH)  ($(filesize(JPATH)) bytes)")
    @assert all(sum(v) == 0 for v in NORM)          # every normal lies in N
    jn = [NTuple{5,Int64}(Int64.(v)) for v in J["normals"]]
    println("  20 normals rebuilt here == the JSON's declared normals : ", jn == NORM)
    jn == NORM || error("normal convention mismatch -- STOP")
    @assert Tuple(Int64.(J["G9"])) == G9 && Tuple(Int64.(J["c9"])) == C9
    println("  G9 = $G9, c9 = $C9 (agree with the JSON)")
    let ok = true
        Random.seed!(1)
        for _ in 1:2000
            g = ntuple(_ -> rand(-30:30), 4)
            n = (g[1], g[2], g[3], g[4], -sum(g)); m = n
            for k in 0:4
                dot5(NTuple{5,Int64}(G9), m) == dot5(NTuple{5,Int64}(mu(k)), n) ||
                    (ok = false)
                m = sig(m)
            end
        end
        println("  identity <sigma^k n, G9> = <n, mu_k> on 2000 random n in N : ", ok)
        @assert ok
    end

    PATS = Pattern[]
    for (tag, pd) in sort(collect(J["patterns"]), by = x -> x[1])
        U = Dict{UInt32,NTuple{5,Int64}}()
        for (s, u) in pd["cells"]; U[str2key(s)] = NTuple{5,Int64}(Int64.(u)); end
        Z = Set{UInt32}(str2key(s) for s in pd["zero_cells"])
        @assert length(U) == length(pd["cells"]) && all(z -> haskey(U, z), Z)
        push!(PATS, Pattern(tag, U, Z))
        println("  pattern $(tag): $(length(U)) cells, $(length(Z)) zero cells, ",
                "max|U| = $(maximum(maximum(abs, u) for u in values(U)))")
    end
    CELLKEYS = sort(collect(keys(PATS[1].U)))
    for p in PATS
        @assert sort(collect(keys(p.U))) == CELLKEYS
    end
    NCELL = length(CELLKEYS)
    CELLSET = Set{UInt32}(CELLKEYS)
    println("  cell set (identical for all patterns): $NCELL distinct sign vectors")

    # ========================================================================
    hdr("A. WELL-DEFINEDNESS / CONTINUITY ACROSS WALLS")
    # A lattice point ON wall t: project a generic n in N onto nu_t^perp inside N,
    #   n' = |nu_t|^2 n - <nu_t,n> nu_t      (nu_t itself lies in N).
    # The two cells adjacent along that wall at n' are the cells of M n' +- nu_t
    # with M large enough that the other 19 signs are those of n'.
    tA = time(); NPTS_A = 20000
    Random.seed!(20260807)
    wallpairs = Dict{Tuple{UInt32,UInt32},Int}()
    resA = Dict(p.tag => [0, 0] for p in PATS)
    nA = 0; nrejA = 0; nmissA = 0
    while nA < NPTS_A
        t = rand(1:20); nu = NORM[t]
        B = (6, 20, 60)[rand(1:3)]
        g = ntuple(_ -> rand(-B:B), 4)
        n0 = (g[1], g[2], g[3], g[4], -sum(g))
        nn = dot5(nu, nu); ln = dot5(nu, n0)
        np = ntuple(i -> nn * n0[i] - ln * nu[i], 5)
        all(==(0), np) && continue
        gg = 0
        for i in 1:5; gg = gcd(gg, abs(np[i])); end
        np = ntuple(i -> np[i] ÷ gg, 5)
        vals = ntuple(s -> dot5(NORM[s], np), 20)
        vals[t] == 0 || error("projection off the wall")
        any(s -> s != t && vals[s] == 0, 1:20) && (nrejA += 1; continue)
        cs = ntuple(s -> dot5(NORM[s], nu), 20)
        M = 1 + maximum(abs, cs)
        kp = ckey(ntuple(i -> M * np[i] + nu[i], 5))
        km = ckey(ntuple(i -> M * np[i] - nu[i], 5))
        (kp == ONWALL || km == ONWALL) && error("crossing point landed on a wall")
        xor(kp, km) == (UInt32(1) << (t - 1)) ||
            error("the two adjacent cells differ in != 1 sign")
        nA += 1
        lo, hi = minmax(kp, km)
        wallpairs[(lo, hi)] = t
        for p in PATS
            up = get(p.U, kp, nothing); um = get(p.U, km, nothing)
            if up === nothing || um === nothing; nmissA += 1; continue; end
            r = resA[p.tag]; r[1] += 1
            dot5(up, np) == dot5(um, np) || (r[2] += 1)
        end
    end
    println("  wall points sampled: $nA   (rejected for hitting a 2nd wall: $nrejA)")
    println("  distinct walls (= adjacent cell pairs) hit: $(length(wallpairs))")
    println("  sign vectors that MISSED the cell map: $nmissA")
    for p in PATS
        r = resA[p.tag]
        println("  pattern $(p.tag): $(r[1]) wall points tested -> $(r[2]) ",
                "DISCONTINUITIES (d jumps across the wall)")
    end
    println("  [$(round(time()-tA, digits=1))s]")

    # ========================================================================
    hdr("B. INTEGRALITY OF THE WALL JUMPS  (U - U' in Z*nu inside Lambda = Z^5/diag)")
    # Adjacency recomputed here: two chambers of an arrangement are adjacent iff
    # their sign vectors differ in EXACTLY one coordinate (only that hyperplane
    # can separate them, so they share a facet inside it).  No wall list imported.
    tB = time()
    ADJ = Tuple{UInt32,UInt32,Int}[]
    for k in CELLKEYS, t in 1:20
        k2 = xor(k, UInt32(1) << (t - 1))
        (k2 in CELLSET && k2 > k) && push!(ADJ, (k, k2, t))
    end
    nA4w = count(x -> x[3] <= 10, ADJ)
    println("  adjacent cell pairs (Hamming distance 1): $(length(ADJ))  ",
            "[A4-class $nA4w, G9-class $(length(ADJ)-nA4w)]")
    ADJSET = Set(ADJ)
    println("  every wall found by random sampling in (A) is in this list: ",
            all(w -> (w[1], w[2], wallpairs[w]) in ADJSET, keys(wallpairs)))
    for p in PATS
        bad = 0; ms = Int[]
        for (k1, k2, t) in ADJ
            D = ntuple(i -> p.U[k1][i] - p.U[k2][i], 5)
            ok, m = intmult(D, NORM[t])
            ok ? push!(ms, m) : (bad += 1)
        end
        println("  pattern $(p.tag): jumps NOT of the form m*nu, m in Z : ",
                "$bad of $(length(ADJ)) ;  m in [$(minimum(ms)), $(maximum(ms))], ",
                "#(m=0) = $(count(==(0), ms))")
    end
    println("  NOTE: U - U' = m*nu on a wall implies <U,x> = <U',x> for EVERY x in")
    println("        that wall, so (B) clean over all $(length(ADJ)) walls is an")
    println("        exhaustive form of (A).")
    println("  [$(round(time()-tB, digits=1))s]")

    # ========================================================================
    hdr("C. RAYS OF THE 20-HYPERPLANE ARRANGEMENT, AND EXACT POSITIVITY THERE")
    tC = time()
    @assert rank_of(1:20) == 4
    println("  arrangement is essential: rank of the 20 normals restricted to N = 4")
    rayact = Dict{NTuple{4,Int64},Vector{Int}}()
    ntrip = 0
    for i in 1:18, j in (i+1):19, k in (j+1):20
        R, piv = rref_rat([ratrow(i), ratrow(j), ratrow(k)], 4)
        length(piv) == 3 || continue
        ntrip += 1
        free = only(setdiff(1:4, piv))
        v = Rational{BigInt}[Rational{BigInt}(0) for _ in 1:4]
        v[free] = 1
        for (a, c) in enumerate(piv); v[c] = -R[a][free]; end
        L = BigInt(1)
        for x in v; L = lcm(L, denominator(x)); end
        w = BigInt[numerator(x * L) for x in v]
        for s in (1, -1)
            r = prim4(BigInt.(s .* w))
            if !haskey(rayact, r)
                act = [t for t in 1:20 if sum(A4[t][q] * r[q] for q in 1:4) == 0]
                rank_of(act) == 3 || error("candidate ray with active rank != 3")
                rayact[r] = act
            end
        end
    end
    RAYS4 = sort(collect(keys(rayact)))
    NR = length(RAYS4)
    RAYS5 = [(r[1], r[2], r[3], r[4], -(r[1]+r[2]+r[3]+r[4])) for r in RAYS4]
    println("  rank-3 triples of normals with a 1-dim kernel: $ntrip of $(binomial(20,3))")
    println("  RAYS (own exact enumeration; both half-lines of every rank-3 flat, ",
            "each with active set of rank exactly 3): $NR")
    println("  ray set closed under r -> -r: ",
            Set(RAYS4) == Set(ntuple(i -> -r[i], 4) for r in RAYS4),
            " ; max |ray coordinate| = ", maximum(maximum(abs, r) for r in RAYS4))

    # intersection lattice + Zaslavsky (own computation)
    function closure_of(ts)
        R, piv = rref_rat([ratrow(t) for t in ts], 4)
        m = UInt32(0)
        for t in 1:20
            inspan(R, piv, ratrow(t)) && (m |= UInt32(1) << (t - 1))
        end
        (m, length(piv))
    end
    flats = Dict{UInt32,Int}(UInt32(0) => 0)
    level = UInt32[UInt32(0)]
    for rk in 1:4
        nxt = UInt32[]
        for S in level, i in 1:20
            (S & (UInt32(1) << (i - 1))) != 0 && continue
            ts = [t for t in 1:20 if (S & (UInt32(1) << (t - 1))) != 0]
            push!(ts, i)
            m, r = closure_of(ts)
            r == rk || continue
            if !haskey(flats, m); flats[m] = rk; push!(nxt, m); end
        end
        level = nxt
    end
    mob = Dict{UInt32,Int}()
    for (F, rk) in sort(collect(flats), by = x -> x[2])
        mob[F] = rk == 0 ? 1 :
                 -sum(mob[G] for (G, r2) in flats if r2 < rk && (G & ~F) == 0)
    end
    ZAS = sum(abs, values(mob))
    nflat = Dict(r => count(==(r), values(flats)) for r in 0:4)
    println("  intersection lattice, #flats by rank: ", sort(collect(nflat)))
    println("  Zaslavsky chamber count |chi(-1)| = $ZAS ; cells in the JSON = $NCELL ",
            "; EQUAL: ", ZAS == NCELL, "  <= the JSON cell list is COMPLETE")
    println("  #rays == 2 * #(rank-3 flats) = 2*$(nflat[3]) : ", NR == 2 * nflat[3])

    raysign = Vector{Tuple{UInt32,UInt32}}(undef, NR)
    for i in 1:NR
        pos = UInt32(0); zer = UInt32(0)
        for t in 1:20
            v = dot5(NORM[t], RAYS5[i])
            v == 0 ? (zer |= UInt32(1) << (t - 1)) :
                     (v > 0 && (pos |= UInt32(1) << (t - 1)))
        end
        raysign[i] = (pos, zer)
    end
    RCELLS = [UInt32[] for _ in 1:NR]
    for i in 1:NR
        pos, zer = raysign[i]
        for k in CELLKEYS
            (k & ~zer) == pos && push!(RCELLS[i], k)
        end
    end
    println("  every ray lies in the closure of >= 1 cell: ", all(!isempty, RCELLS),
            " ; (ray,cell) incidences = ", sum(length, RCELLS),
            " ; per-ray cell count min/max = ", minimum(length, RCELLS), "/",
            maximum(length, RCELLS))
    for p in PATS
        incons = 0; neg = 0; zro = 0
        dmin = typemax(Int128); dmax = typemin(Int128)
        for i in 1:NR
            vs = unique(Int128(dot5(p.U[c], RAYS5[i])) for c in RCELLS[i])
            length(vs) > 1 && (incons += 1)
            v = vs[1]
            v < 0 && (neg += 1); v == 0 && (zro += 1)
            dmin = min(dmin, v); dmax = max(dmax, v)
        end
        println("  pattern $(p.tag): d(r) depends on the chosen incident cell at ",
                "$incons of $NR rays ; d(r) < 0 at $neg rays ; d(r) = 0 at $zro ; ",
                "range [$dmin, $dmax]")
    end
    println("  [$(round(time()-tC, digits=1))s]")

    # ========================================================================
    hdr("C2. EXACT DUAL-CONE CERTIFICATE FOR  d >= 0  ON EVERY CELL")
    # Independent of the ray enumeration and of Minkowski-Weyl:
    #   cell C = { x : s_t <a_t, x> >= 0, t = 1..20 },  so the functionals that are
    #   nonnegative on C are exactly cone{ s_t a_t : t }.  Hence
    #        d >= 0 on all of C   <=>   u_C in cone{ s_t a_t }.
    # Decided by an exact rational phase-1 simplex, per cell.
    tC2 = time()
    for p in PATS
        bad = 0; badneg = 0; nnz = 0
        for k in CELLKEYS
            gens = [ntuple(q -> ((k >> (t-1)) & UInt32(1)) == 1 ? A4[t][q] : -A4[t][q], 4)
                    for t in 1:20]
            uu = u4(p.U[k])
            in_cone(gens, uu) || (bad += 1)
            if uu != (0, 0, 0, 0)                    # control: -u must NOT be in C*
                nnz += 1
                in_cone(gens, ntuple(q -> -uu[q], 4)) && (badneg += 1)
            end
        end
        println("  pattern $(p.tag): cells whose slope is NOT in the dual cone ",
                "(i.e. d < 0 somewhere on the cell): $bad of $NCELL")
        println("     built-in control: cells with U != 0 for which -U IS also in the ",
                "dual cone: $badneg of $nnz  (must be 0; the cones are pointed)")
    end
    println("  [$(round(time()-tC2, digits=1))s]")

    # ========================================================================
    hdr("D. POINTWISE LAWS AT RANDOM LATTICE POINTS OF N")
    NPTS_D = parse(Int, get(ENV, "F55_NPTS", "1000000"))
    println("  arithmetic: plain Int64.  Bound: |n_i| <= 4000 (box 1000), max|U| <= 845,")
    println("  so |d| <= 5*4000*845 < 1.7e7 and |sum_k 9^k d_k + <n,c9>| < 6e11 << 9.2e18.")
    tD = time()
    for p in PATS
        r = checkD(p.U, NPTS_D, 777)
        println("  pattern $(p.tag): $(r.tested) points with all 5 sigma-translates in ",
                "open cells ($(r.skipped) rejected: some translate on a wall)")
        println("     per box (|entries| <= B): $(sort(collect(r.perbox)))")
        println("     sign vectors missing from the cell map     : $(r.miss)")
        println("     d < 0 somewhere in the sigma-orbit         : $(r.neg) failures")
        println("     min_k d(sig^k n) attained < 2 times        : $(r.min2) failures")
        println("     min_k d(sig^k n) != 0                      : $(r.minzero) failures")
        println("     sum_k 9^k d(sig^k n) + <n,c9> != 0 (mod 11): $(r.cong) failures")
    end
    println("  [$(round(time()-tD, digits=1))s]")

    # ========================================================================
    hdr("D2. THE SAME LAWS AT THE POINTS (D) THROWS AWAY -- ON THE WALLS")
    tD2 = time()
    Random.seed!(31337)
    ws = NTuple{5,Int64}[]
    while length(ws) < 2
        g = ntuple(_ -> rand(-9:9), 4)
        w = (g[1], g[2], g[3], g[4], -sum(g))
        all(t -> dot5(NORM[t], w) != 0, 1:20) && push!(ws, w)
    end
    Ms = [Int64(1 + maximum(abs(dot5(NORM[t], w)) for t in 1:20)) for w in ws]
    WS = Tuple{NTuple{5,Int64},Int64}[]
    for (w, M) in zip(ws, Ms)
        push!(WS, (w, M)); push!(WS, (ntuple(i -> -w[i], 5), M))
    end
    println("  4 push-off directions (w, -w for two generic w): ",
            join([string(x[1]) for x in WS], " "))
    println("  +-w land in OPPOSITE chambers along every wall through the point, so")
    println("  agreement of all four is a sharp continuity test at the degenerate points.")
    NPTS_D2 = max(200000, NPTS_D ÷ 5)
    for p in PATS
        r = checkD_closed(p.U, NPTS_D2, 555, WS)
        println("  pattern $(p.tag): $(r.tested) points, of which $(r.onwall) have at ",
                "least one sigma-translate ON a wall ($(round(100*r.onwall/r.tested, digits=1))%)")
        println("     push-off directions DISAGREE (d ill-defined)         : $(r.ambig)")
        println("     evaluation failed (chamber not in the map)           : $(r.bad)")
        println("     d < 0                                                : $(r.neg)")
        println("     min_k d(sig^k n) attained < 2 times                  : $(r.min2)")
        println("     min_k d(sig^k n) != 0                                : $(r.minzero)")
        println("     sum_k 9^k d(sig^k n) + <n,c9> != 0 (mod 11)          : $(r.cong)")
    end
    println("  [$(round(time()-tD2, digits=1))s]")

    # ========================================================================
    hdr("E. THE ZERO SET AND THE SIGMA-ORBIT STRUCTURE OF THE CELLS")
    tE = time()
    let bad = 0, tot = 0
        Random.seed!(99)
        while tot < 20000
            g = ntuple(_ -> rand(-40:40), 4)
            n = (g[1], g[2], g[3], g[4], -sum(g))
            k = ckey(n); k == ONWALL && continue
            ks = ckey(sig(n)); ks == ONWALL && continue
            tot += 1
            sigkey(k) == ks || (bad += 1)
        end
        println("  derived sigma-action on sign vectors validated on $tot random ",
                "points: $bad mismatches")
        @assert bad == 0
    end
    seenk = Set{UInt32}(); ORBS = Vector{Vector{UInt32}}()
    for k in CELLKEYS
        k in seenk && continue
        o = [k]; c = k
        for _ in 1:4
            c = sigkey(c)
            c in CELLSET || error("sigma image of a cell is not a cell")
            push!(o, c)
        end
        sigkey(o[end]) == k || error("sigma^5 != id on cells")
        length(unique(o)) == 5 || error("sigma-orbit of size < 5")
        union!(seenk, o); push!(ORBS, o)
    end
    println("  sigma-orbits of cells: $(length(ORBS)), all free (size 5); ",
            "5*$(length(ORBS)) = $NCELL : ", 5 * length(ORBS) == NCELL)

    CELLRAYS = Dict{UInt32,Vector{Int}}(k => Int[] for k in CELLKEYS)
    for i in 1:NR, c in RCELLS[i]; push!(CELLRAYS[c], i); end
    INTPT = Dict{UInt32,NTuple{5,Int64}}(); badint = 0
    for k in CELLKEYS
        s = (0, 0, 0, 0, 0)
        for i in CELLRAYS[k]
            rr = RAYS5[i]; s = ntuple(q -> s[q] + rr[q], 5)
        end
        ckey(s) == k ? (INTPT[k] = s) : (badint += 1)
    end
    println("  independent interior points (sum of the rays in each cell's closure): ",
            "$(length(INTPT))/$NCELL built, $badint failed to reproduce the sign vector")
    @assert badint == 0
    for p in PATS
        nzU = count(k -> nz(p.U[k]) != (0, 0, 0, 0, 0), collect(p.zeros))
        nzd = count(k -> dot5(p.U[k], INTPT[k]) != 0, collect(p.zeros))
        orbz = extrema(count(c -> c in p.zeros, o) for o in ORBS)
        negint = count(k -> dot5(p.U[k], INTPT[k]) < 0, CELLKEYS)
        extra = count(k -> !(k in p.zeros) && nz(p.U[k]) == (0, 0, 0, 0, 0), CELLKEYS)
        println("  pattern $(p.tag): declared zero cells with U != 0 in Lambda: $nzU ",
                "of $(length(p.zeros)) ; d != 0 at their interior points: $nzd")
        println("     zero cells per sigma-orbit: min $(orbz[1]), max $(orbz[2])   ",
                "(>= 2 required)")
        println("     d < 0 at the $NCELL independent cell interior points: $negint")
        println("     cells with U = 0 that are NOT declared zero cells: $extra")
    end
    println("  [$(round(time()-tE, digits=1))s]")

    # ========================================================================
    hdr("F. NEGATIVE CONTROLS  (the harness must be able to fail)")
    tF = time()
    NPTS_F = max(50000, NPTS_D ÷ 20)
    P0 = PATS[findfirst(p -> p.tag == J["crosscheck_pattern"], PATS)]
    println("  controls run on pattern $(P0.tag) with $NPTS_F points each")

    bumpc = first(k for k in CELLKEYS if !(k in P0.zeros))
    r = checkD(P0.U, NPTS_F, 4242; bumpkey = bumpc)
    println("  (i)   d -> d+1 on ONE cell ($(r.hits) of $(r.tested) orbits touch it): ",
            "d<0 $(r.neg) | twice-min $(r.min2) | min!=0 $(r.minzero) | ",
            "congruence $(r.cong)  ==> ",
            (r.min2 + r.minzero + r.cong > 0 ? "FAILS as required" :
             "!!! PASSED SILENTLY -- HARNESS BROKEN"))

    r = checkD(P0.U, NPTS_F, 4242; c9 = (0, 0, 0, 0, 0))
    println("  (ii)  c9 -> 0 in the congruence: $(r.cong) of $(r.tested) failures  ==> ",
            (r.cong > 0 ? "FAILS as required" : "!!! PASSED SILENTLY -- HARNESS BROKEN"))

    delta = (0, 0, 0, 0, 0)
    for cand in [(1,1,0,0,0), (1,2,0,0,0), (1,1,1,0,0), (2,3,5,7,0)]
        if all(t -> !intmult(NTuple{5,Int64}(cand), NORM[t])[1], 1:20)
            delta = NTuple{5,Int64}(cand); break
        end
    end
    @assert delta != (0, 0, 0, 0, 0)
    println("  (iii) perturbation delta = $delta, verified NOT an integer multiple of ",
            "any of the 20 normals in Lambda")
    zc = first(sort(collect(P0.zeros)))
    U3 = copy(P0.U)
    U3[zc] = ntuple(i -> P0.U[zc][i] + delta[i], 5)
    badB = 0; nwall = 0
    for (k1, k2, t) in ADJ
        (k1 == zc || k2 == zc) || continue
        nwall += 1
        D = ntuple(i -> U3[k1][i] - U3[k2][i], 5)
        intmult(D, NORM[t])[1] || (badB += 1)
    end
    println("  (iii) check (B): $badB of that cell's $nwall walls now have ",
            "non-integral jumps  ==> ",
            (badB > 0 ? "FAILS as required" : "!!! PASSED SILENTLY -- HARNESS BROKEN"))
    dz = dot5(U3[zc], INTPT[zc])
    println("  (iii) check (E): d at that zero cell's interior point = $dz  ==> ",
            (dz != 0 ? "FAILS as required" : "!!! PASSED SILENTLY -- HARNESS BROKEN"))
    r = checkD(U3, NPTS_F, 4242)
    println("  (iii) check (D): d<0 $(r.neg) | twice-min $(r.min2) | ",
            "min!=0 $(r.minzero) | congruence $(r.cong)  ==> ",
            (r.neg + r.min2 + r.minzero + r.cong > 0 ? "FAILS as required" :
             "!!! PASSED SILENTLY -- HARNESS BROKEN"))

    # exhaustive continuity sweep, one relative-interior wall point per adjacent
    # pair, built as the sum of the rays common to both closures
    function wallsweep(U)
        bad = 0; tot = 0
        for (k1, k2, t) in ADJ
            common = intersect(Set(CELLRAYS[k1]), Set(CELLRAYS[k2]))
            isempty(common) && continue
            s = (0, 0, 0, 0, 0)
            for i in common
                rr = RAYS5[i]; s = ntuple(q -> s[q] + rr[q], 5)
            end
            dot5(NORM[t], s) == 0 || continue
            tot += 1
            dot5(U[k1], s) == dot5(U[k2], s) || (bad += 1)
        end
        (bad, tot)
    end
    r = checkD_closed(U3, 50000, 555, WS)
    println("  (iii) check (D2) on the perturbed field: push-off disagreements ",
            "$(r.ambig) | d<0 $(r.neg) | twice-min $(r.min2) | congruence $(r.cong)",
            "  ==> ", (r.ambig + r.neg + r.min2 + r.cong > 0 ? "FAILS as required" :
                       "!!! PASSED SILENTLY -- HARNESS BROKEN"))
    # targeted: the D2 push-off machinery must SEE the perturbation at that cell's
    # own walls (relative-interior wall points built from the shared rays)
    amb3 = 0; tot3 = 0
    for (k1, k2, t) in ADJ
        (k1 == zc || k2 == zc) || continue
        common = intersect(Set(CELLRAYS[k1]), Set(CELLRAYS[k2]))
        isempty(common) && continue
        s = (0, 0, 0, 0, 0)
        for i in common
            rr = RAYS5[i]; s = ntuple(q -> s[q] + rr[q], 5)
        end
        dot5(NORM[t], s) == 0 || continue
        tot3 += 1
        vals = unique([dclosed(U3, s, w, M)[2] for (w, M) in WS])
        length(vals) > 1 && (amb3 += 1)
    end
    println("  (iii) targeted (D2): push-off disagreement at $amb3 of $tot3 wall points ",
            "of the perturbed cell  ==> ",
            (amb3 > 0 ? "FAILS as required" : "!!! PASSED SILENTLY -- HARNESS BROKEN"))
    b3, t3 = wallsweep(U3)
    println("  (iii) check (A): $b3 of $t3 shared-wall points now discontinuous  ==> ",
            (b3 > 0 ? "FAILS as required" : "!!! PASSED SILENTLY -- HARNESS BROKEN"))
    for p in PATS
        b0, t0 = wallsweep(p.U)
        println("  (A-exhaustive, UNPERTURBED, pattern $(p.tag)): $b0 discontinuities ",
                "at $t0 wall points (one per adjacent pair, built from ray sums)")
    end
    println("  [$(round(time()-tF, digits=1))s]")

    # ========================================================================
    hdr("G. CROSS-CHECK AGAINST THE (n,d) SAMPLES THE PYTHON PROBE PUT IN THE JSON")
    let tag = J["crosscheck_pattern"], p = PATS[findfirst(q -> q.tag == tag, PATS)],
        bad = 0, tot = 0
        for s in J["crosscheck_samples"]
            n = NTuple{5,Int64}(Int64.(s["n"])); want = Int64(s["d"])
            k = ckey(n)
            tot += 1
            (k != ONWALL && haskey(p.U, k) && dot5(p.U[k], n) == want) || (bad += 1)
        end
        println("  $tot (n,d) pairs computed by the Python probe, recomputed here from ",
                "the sign vectors: $bad mismatches")
    end

    return (RAYS4 = RAYS4, NCELL = NCELL, NR = NR, PATS = PATS, CELLKEYS = CELLKEYS)
end

const RES = main()

# ============================================================================
if get(ENV, "F55_OSCAR", "1") != "0"
    hdr("H. OSCAR / POLYMAKE INDEPENDENT FAN COMPUTATION")
    tH = time()
    try
        @eval using Oscar
        println("  Oscar $(Base.invokelatest(pkgversion, Main.Oscar)) loaded ",
                "[$(round(time()-tH, digits=1))s]")
        Base.eval(Main, quote
            # The chamber fan of the central arrangement { <nu_t, .> = 0 } is the
            # NORMAL FAN of the zonotope Z = sum_t [-a_t, a_t] built from the same
            # functionals a_t.  Nothing from the JSON enters this computation.
            local segs = [convex_hull([collect(A4[t])'; -collect(A4[t])']) for t in 1:20]
            local Z = segs[1]
            for t in 2:20; Z = minkowski_sum(Z, segs[t]); end
            println("  zonotope of the 20 normals: dim $(dim(Z)), ",
                    "$(n_vertices(Z)) vertices")
            local NFan = normal_fan(Z)
            local orays = rays(NFan)
            local nmax = n_maximal_cones(NFan)
            local function toprim(rv)
                v = [Rational{BigInt}(x) for x in rv]
                L = BigInt(1); for x in v; L = lcm(L, denominator(x)); end
                prim4(BigInt[numerator(x * L) for x in v])
            end
            local oset = Set(toprim(r) for r in orays)
            println("  Oscar/polymake normal fan: $(length(oset)) rays, ",
                    "$nmax maximal cones (chambers)")
            println("  AGREEMENT with the own exact enumeration:  rays ",
                    oset == Set(RES.RAYS4), " ($(length(oset)) vs $(RES.NR)) ;  ",
                    "chambers ", nmax == RES.NCELL, " ($nmax vs $(RES.NCELL))")
            # strongest form: the SIGN VECTORS of polymake's maximal cones must be
            # exactly the JSON's 1090 keys (interior point = sum of the cone's rays)
            local ks = Set{UInt32}()
            for c in maximal_cones(NFan)
                local s = (0, 0, 0, 0)
                for r in rays(c)
                    local pr = toprim(r); s = ntuple(q -> s[q] + pr[q], 4)
                end
                push!(ks, ckey((s[1], s[2], s[3], s[4], -(s[1]+s[2]+s[3]+s[4]))))
            end
            println("  sign vectors of polymake's $(length(ks)) maximal cones == the ",
                    "JSON's cell keys: ", ks == Set(RES.CELLKEYS))
            local M = matrix(ZZ, 20, 4, vcat([collect(A4[t]) for t in 1:20]...))
            println("  Nemo/FLINT rank of the 20x4 normal matrix = $(rank(M)) ",
                    "(own exact RREF said 4)")
        end)
        println("  [$(round(time()-tH, digits=1))s]")
    catch e
        println("  !! OSCAR BLOCK FAILED: ", sprint(showerror, e))
        println("  !! the ray/chamber counts of section (C) stand on the own exact")
        println("  !! enumeration alone.")
    end
end

hdr("TOTAL")
println("  runtime $(round(time()-T00, digits=1))s")
