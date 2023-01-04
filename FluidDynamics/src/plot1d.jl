const MAIN_THEME = Theme(
    fontsize = 20,
    fonts = (; regular = "CMU Serif", titlefont = "CMU Serif"),
    # font = "DejaVu",
    Axis = (
        xticksmirrored = true,
        yticksmirrored = true,
        xtickalign = 1,
        ytickalign = 1,
        # xticks=WilkinsonTicks(6),
        # yticks=WilkinsonTicks(6),
        xgridvisible = false,
        ygridvisible = false,
    ),
    Legend = (framevisible = false,),
)


function plot1d(sol, tl, xl)
    set_theme!(MAIN_THEME)

    # sol_pl = [sol(t)[i] for t in tl, i = 1:length(xl)]
    sol_pl = [sol[it][i] for it = 1:length(sol.t), i = 1:length(xl)]


    fig = Figure()
    ax = Axis(fig[1, 1], xlabel = "x", ylabel = "t")

    ctrf = contourf!(ax, xl, sol.t, sol_pl')
    Colorbar(fig[:, end+1], ctrf)

    display(fig)
end

function anim1d(sol, tl, xl, name = "plots/anim.mp4")
    ul = [sol[i] for i = 1:length(sol.t)]

    fig = Figure()
    ax = Axis(fig[1, 1], xlabel = L"x", ylabel = L"u(x)")

    time_index = Observable(1)
    u = lift(time_index) do i
        ul[i]
    end

    lines!(ax, xl, u)

    record(fig, name, 1:length(sol.t)) do i
        time_index[] = i
        # autolimits!(ax)
    end

    # display(fig)
end