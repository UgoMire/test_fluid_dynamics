using FluidDynamics

f0(x) = -0.1sin(x * 2π / 4)
# f0(x) = 0.1exp(-15(x - 0.5)^2) - 0.1exp(-15(x + 0.5)^2)
# f0(x) = x < 0 ? 0 : 1

p = ParamsBurger(0.5, -2, 2, 50, f0)
# p = ParamsLA(0.5, -1, 1, 100, f0)


tl = range(0, 7, 100)

sol = simul(tl, p)

# plot1d(sol, tl, p.xl)
anim1d(sol, tl, p.xl)