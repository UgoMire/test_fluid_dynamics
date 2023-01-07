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

function burger_fdm!(du, u, p, t)
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

function burger_fvm_linear!(du, u, p, t)
    # find the value at the cells
    u_half = zeros(p.Nx - 1)
    for (i, x) in enumerate(p.xl[1:end-1])
        u_half[i] =
            u[i+1] + (u[i] - u[i+1]) / (p.xl[i] - p.xl[i+1]) * (p.xl[i] - p.xl[i+1]) / 2
    end

    for (i, x) in enumerate(p.xl)
        if i == 1
            du[i] = -1 / 2p.dx * (u_half[i]^2 - u_half[end]^2)
        elseif i == p.Nx
            du[i] = -1 / 2p.dx * (u_half[1]^2 - u_half[i-1]^2)
        else
            du[i] = -1 / 2p.dx * (u_half[i]^2 - u_half[i-1]^2)
        end
    end
end

function burger_fvm_upwind!(du, u, p, t)
    # find the value at the cells
    u_half = zeros(p.Nx - 1)
    for i = 1:(p.Nx-1)
        if u[i] > 0
            u_half[i] = u[i]
        else
            u_half[i] = u[i+1]
        end
    end

    for (i, x) in enumerate(p.xl)
        if i == 1
            du[i] = -1 / 2p.dx * (u_half[i]^2 - u_half[end]^2)
        elseif i == p.Nx
            du[i] = -1 / 2p.dx * (u_half[1]^2 - u_half[i-1]^2)
        else
            du[i] = -1 / 2p.dx * (u_half[i]^2 - u_half[i-1]^2)
        end
    end
end

function simul(tl, p::ParamsBurger; method = "fdm")
    if method == "fdm"
        prob = ODEProblem(burger_fdm!, p.u0, (tl[1], tl[end]), p, saveat = tl)
    elseif method == "fvm_linear"
        prob = ODEProblem(burger_fvm_linear!, p.u0, (tl[1], tl[end]), p, saveat = tl)
    elseif method == "fvm_upwind"
        prob = ODEProblem(burger_fvm_upwind!, p.u0, (tl[1], tl[end]), p, saveat = tl)
    end

    return solve(prob)
end