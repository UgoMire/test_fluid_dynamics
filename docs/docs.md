# Simulation of fluid dynamics equations

## Linear Advection Equation

The most simple example of fluid dynamics equation discribing advection (ie a quantity which is carried by the fluid) is the linear advection equation and reads 
$$
\partial_t u(t, x) + v \partial_x u(t, x) = 0 \; .
$$

We know the solution to this equation which is simply given by
$$
u(x, t) = f(x - vt)
$$
which mean that, for example, the initial condition will be carried along at velocity. We show this behavior in the next Figure for two Gaussian profiles.

![My cool Picture](../plots/ld1.mp4)

## Bv

## Burger Equation

The equation reads
$$
\partial_t u + u \partial_x u = \nu \partial^2_x u
$$

<video src='..\plots\anim.mp4' width=180/></video>