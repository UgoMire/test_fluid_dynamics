struct ParamsLA
    v::Float64

    xmin::Float64
    xmax::Float64
    Nx::Int64

    dx::Float64
    xl::Vector{Float64}

    u0::Vector{Float64}

    function ParamsLA(v, xmin, xmax, Nx, f0)
        dx = (xmax - xmin) / (Nx - 1)
        xl = range(xmin, xmax, Nx)

        u0 = zeros(Nx)
        for (i, x) in enumerate(xl)
            u0[i] = f0(x)
        end

        new(v, xmin, xmax, Nx, dx, xl, u0)
    end
end

function ld!(du, u, p, t)
    for (i, x) in enumerate(p.xl)
        if i == 1
            du[i] = -p.v / p.dx * (u[i+1] - u[end])
        elseif i == p.Nx
            du[i] = -p.v / p.dx * (u[1] - u[i-1])
        else
            du[i] = -p.v / p.dx * (u[i+1] - u[i-1])
        end
    end
end

function simul_ld(tmin, tmax, p::ParamsLA)
    prob = ODEProblem(ld!, p.u0, (tmin, tmax), p)
    return solve(prob)
end