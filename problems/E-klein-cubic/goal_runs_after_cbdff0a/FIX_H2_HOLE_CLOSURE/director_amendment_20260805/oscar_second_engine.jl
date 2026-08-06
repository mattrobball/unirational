using Oscar
P = "/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_cbdff0a/FIX_H2_HOLE_CLOSURE/msolve/"
CASES = [
 ("one_Z","h2f_r8_one_Z_lowdeg_qq.ms"), ("om_Z","h2m_r8_om_Z_lowdeg4_qq.ms"),
 ("om2_Z","h2m_r8_om2_Z_lowdeg4_qq.ms"), ("one_N","h2m_r8_one_N_lowdeg_qq.ms"),
 ("om_N","h2m_r8_om_N_lowdeg_qq.ms"), ("om2_N","h2m_r8_om2_N_lowdeg_direct_qq.ms")]

function load_case(fn)
    lines = readlines(P*fn)
    vars = split(strip(lines[1]), ",")
    @assert strip(lines[2]) == "0"
    body = join(lines[3:end], "\n")
    @assert !occursin("(", body)
    polys = [strip(p) for p in split(body, ",\n") if !isempty(strip(p))]
    polys = [endswith(p, ",") ? p[1:end-1] : p for p in polys]
    return vars, polys
end

function decide(tag, vars, polys)
    R, gens_ = polynomial_ring(QQ, String.(vars))
    env = Dict(Symbol(v) => gens_[i] for (i,v) in enumerate(vars))
    fs = elem_type(R)[]
    for p in polys
        ex = Meta.parse(p)
        f = Base.eval(Main, :(let $([:( $(k) = $(v) ) for (k,v) in env]...); $(ex) end))
        push!(fs, R(f))
    end
    I = ideal(R, fs)
    t0 = time()
    gb = groebner_basis_f4(I)
    unit = (length(gb) == 1 && is_one(leading_monomial(gb[1])) && is_unit(leading_coefficient(gb[1])))
    println("$tag  vars=$(length(vars)) gens=$(length(fs)) -> F4 unit=$(unit)  ($(round(time()-t0, digits=1)) s)  gb_len=$(length(gb))")
    flush(stdout)
    return unit
end

# controls
let
    R,(x,y) = polynomial_ring(QQ, ["x","y"])
    gu = groebner_basis_f4(ideal(R,[x, x+1])); gn = groebner_basis_f4(ideal(R,[x*y]))
    cu = (length(gu)==1 && is_one(leading_monomial(gu[1])))
    cn = (length(gn)==1 && is_one(leading_monomial(gn[1])))
    println("controls: unit->$(cu) (expect true), nonunit->$(cn) (expect false)"); flush(stdout)
    @assert cu && !cn
end
res = Bool[]
for (tag, fn) in CASES
    vars, polys = load_case(fn)
    push!(res, decide(tag, vars, polys))
end
println("OSCAR-ALL-UNIT: ", all(res))
