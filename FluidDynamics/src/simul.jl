function simul(tl, p::ParamsLA)
    prob = ODEProblem(ld!, p.u0, (tl[1], tl[end]), p, saveat = tl)
    return solve(prob)
end

function simul(tl, p::ParamsBurger)
    prob = ODEProblem(burger!, p.u0, (tl[1], tl[end]), p, saveat = tl, alg_hints = [:stiff])
    return solve(prob)
end