using FluidDynamics

# f0(x) = 0.5 / (x + 1) * sin(x * 2π / 4)
# f0(x) = 1exp(-10(x - 0.5)^2) - 0.5exp(-10(x - 3.5)^2)
f0(x) = 0.3exp(-10(x - 1)^2)
# f0(x) = x < 0 ? 0 : 1

p = ParamsBurger(0.2, 0, 4, 1000, f0)
# p = ParamsLA(0.3, 0, 4, 200, f0)


tl = range(0, 10, 300)

sol = simul(tl, p)

# plot1d(sol, tl, p.xl)
# name = "plots/burger_inviscid2.gif"
# name = "plots/ld1.gif"
# name = "plots/burger_viscid2.gif"
name = "plots/anim.mp4"

anim1d(sol, tl, p.xl, name)