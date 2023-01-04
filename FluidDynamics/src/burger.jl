struct ParamsBurger
    ν::Float64

    xmin::Float64
    xmax::Float64
    Nx::Int64

    dx::Float64
    xl::Vector{Float64}

    u0::Vector{Float64}

    function ParamsBurger(v, xmin, xmax, Nx, f0)
        dx = (xmax - xmin) / (Nx - 1)
        xl = range(xmin, xmax, Nx)

        u0 = zeros(Nx)
        for (i, x) in enumerate(xl)
            u0[i] = f0(x)
        end

        new(v, xmin, xmax, Nx, dx, xl, u0)
    end
end

function burger!(du, u, p, t)
    for (i, x) in enumerate(p.xl)
        if i == 1
            du[i] =
                -u[i] / p.dx * (u[i+1] - u[end]) + p.ν / p.dx^2 * (u[i+1] - 2u[i] + u[end])
        elseif i == p.Nx
            du[i] = -u[i] / p.dx * (u[1] - u[i-1]) + p.ν / p.dx^2 * (u[1] - 2u[i] + u[i-1])
        else
            du[i] =
                -(u[i+1] + u[i-1]) / 4p.dx * (u[i+1] - u[i-1]) +
                p.ν / p.dx^2 * (u[i+1] - 2u[i] + u[i-1])
        end
    end
end

function simul(tl, p::ParamsBurger)
    prob = ODEProblem(burger!, p.u0, (tl[1], tl[end]), p, saveat = tl, alg_hints = [:stiff])
    return solve(prob)
end