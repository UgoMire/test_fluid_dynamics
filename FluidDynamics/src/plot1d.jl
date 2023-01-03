function plot1d(sol, tl, xl)
    # sol_pl = [sol(t)[i] for t in tl, i = 1:length(xl)]
    sol_pl = [sol[it][i] for it = 1:length(sol.t), i = 1:length(xl)]


    fig = Figure()
    ax = Axis(fig[1, 1], xlabel = "x", ylabel = "t")

    ctrf = contourf!(ax, xl, sol.t, sol_pl')
    Colorbar(fig[:, end+1], ctrf)

    display(fig)
end

function anim1d(sol, tl, xl)
    ul = [sol[i] for i = 1:length(sol.t)]

    fig = Figure()
    ax = Axis(fig[1, 1], xlabel = "x", ylabel = "u")

    time_index = Observable(1)
    u = lift(time_index) do i
        ul[i]
    end

    lines!(ax, xl, u)

    record(fig, "plots/anim.mp4", 1:length(sol.t)) do i
        time_index[] = i
    end

    # display(fig)
end