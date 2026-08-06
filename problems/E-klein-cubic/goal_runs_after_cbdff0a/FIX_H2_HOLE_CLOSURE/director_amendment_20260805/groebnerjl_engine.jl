using Nemo, Groebner
P = "/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_cbdff0a/FIX_H2_HOLE_CLOSURE/msolve/"
CASES = [
 ("one_Z","h2f_r8_one_Z_lowdeg_qq.ms"), ("om_Z","h2m_r8_om_Z_lowdeg4_qq.ms"),
 ("om2_Z","h2m_r8_om2_Z_lowdeg4_qq.ms"), ("one_N","h2m_r8_one_N_lowdeg_qq.ms"),
 ("om_N","h2m_r8_om_N_lowdeg_qq.ms"), ("om2_N","h2m_r8_om2_N_lowdeg_direct_qq.ms")]

function load_case(fn)
    lines = readlines(P*fn)
    vars = String.(split(strip(lines[1]), ","))
    @assert strip(lines[2]) == "0"
    body = join(lines[3:end], "\n")
    @assert !occursin("(", body)
    polys = [strip(p) for p in split(body, ",\n") if !isempty(strip(p))]
    polys = [endswith(p, ",") ? chop(p) : p for p in polys]
    return vars, polys
end

function decide(tag, vars, polystrs)
    R, g = polynomial_ring(Nemo.QQ, vars)
    fs = map(polystrs) do p
        ex = Meta.parse(p)
        Base.eval(Main, Expr(:let, Expr(:block, [:($(Symbol(v)) = $(g[i])) for (i,v) in enumerate(vars)]...), ex))
    end
    t0 = time()
    gb = Groebner.groebner(fs)
    unit = (length(gb) == 1 && is_constant(gb[1]) && !iszero(gb[1]))
    println("$tag vars=$(length(vars)) gens=$(length(fs)) -> GROEBNER.JL unit=$(unit) ($(round(time()-t0,digits=1)) s)")
    flush(stdout)
    unit
end

let
    R,(x,y) = polynomial_ring(Nemo.QQ, ["x","y"])
    cu = Groebner.groebner([x, x+1]); cn = Groebner.groebner([x*y])
    u = length(cu)==1 && is_constant(cu[1]); n = length(cn)==1 && is_constant(cn[1])
    println("controls: unit->$(u) nonunit->$(n)"); flush(stdout)
    @assert u && !n
end
res = [decide(t, load_case(f)...) for (t,f) in CASES]
println("GROEBNERJL-ALL-UNIT: ", all(res))
