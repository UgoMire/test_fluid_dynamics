module FluidDynamics

using CairoMakie
using DifferentialEquations

export ParamsLA, ParamsBurger
export simul
export plot1d, anim1d

include("linear_advection.jl")
include("burger.jl")
include("plot1d.jl")

end # module FluidDynamics
