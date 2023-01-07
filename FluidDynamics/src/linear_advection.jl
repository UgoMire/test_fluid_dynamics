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

function ld_fdm!(du, u, p, t)
    for (i, x) in enumerate(p.xl)
        if i == 1
            du[i] = -p.v / p.dx * (u[i+1] - u[end])
        elseif i == p.Nx
            du[i] = -p.v / p.dx * (u[1] - u[i-1])
        else
            du[i] = -p.v / 2p.dx * (u[i+1] - u[i-1])
        end
    end
end

function ld_fvm!(du, u, p, t)
    # find the value at the cells
    u_half = zeros(p.Nx - 1)
    for (i, x) in enumerate(p.xl[1:end-1])
        u_half[i] =
            u[i+1] + (u[i] - u[i+1]) / (p.xl[i] - p.xl[i+1]) * (p.xl[i] - p.xl[i+1]) / 2
    end

    for (i, x) in enumerate(p.xl)
        if i == 1
            du[i] = -p.v / p.dx * (u_half[i] - u_half[end])
        elseif i == p.Nx
            du[i] = -p.v / p.dx * (u_half[1] - u_half[i-1])
        else
            du[i] = -p.v / p.dx * (u_half[i] - u_half[i-1])
        end
    end
end

function simul(tl, p::ParamsLA; method = "fdm")
    if method == "fdm"
        prob = ODEProblem(ld_fdm!, p.u0, (tl[1], tl[end]), p, saveat = tl)
    elseif method == "fvm"
        prob = ODEProblem(ld_fvm!, p.u0, (tl[1], tl[end]), p, saveat = tl)
    end

    return solve(prob)
end