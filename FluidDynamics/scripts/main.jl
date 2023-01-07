using FluidDynamics, CairoMakie

# f0(x) = 0.5 / (x + 1) * sin(x * 2π / 4)
f0(x) = 1exp(-10(x - 1)^2) - 0.5exp(-10(x - 3)^2)
# f0(x) = 0.3exp(-10(x - 2)^2)
# f0(x) = x < 0 ? 0 : 1

p = ParamsBurger(0.001, 0, 4, 500, f0)
# p = ParamsLA(0.1, 0, 4, 500, f0)


tl = range(0, 10, 200)

sol = simul(tl, p, method = "fvm_upwind")

# plot1d(sol, tl, p.xl)
# name = "plots/burger_inviscid2.gif"
# name = "plots/ld1.gif"
# name = "plots/burger_viscid2.gif"
name = "plots/temp/anim.gif"

anim1d(sol, tl, p.xl, name)

##
x = range(0, 10, 10)
y = x .^ 2

yinterp = zeros(9)
for (i, xi) in enumerate(x[1:end-1])
    yinterp[i] = y[i+1] + (y[i] - y[i+1]) / (x[i] - x[i+1]) * (x[i] - x[i+1]) / 2
end

fig, ax, sc = scatter(x, y, label = "y")
scatter!(ax, x[1:end-1] .+ (x[2] - x[1]) / 2, yinterp, label = "yinterp")
axislegend()
display(fig)
##