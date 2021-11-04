using Distributed
addprocs(Sys.CPU_THREADS-1)
@everywhere begin
    include("../src/mcmc.jl")
    include("../src/utils.jl")
    include("../src/diagnostics.jl")
end


using Plots, StatsPlots, MCMCChains
#using LinearAlgebra
using KernelDensity


@everywhere begin
    using Cubature
    function f(x)
        return sum(x.^4 - 200x.^2)
    end
    g(x) = exp(-f(x)/100)
end

### scalar chain
bounds = (-20, 20)


Z, err = hcubature(g, -20, 20)
p(x) = g(x)/Z
plot(p, xlims = bounds)

begin 
    plts = []
    for dist in (Normal(0.,20.), Cauchy(0., 1.))
        chains =  mcmc(
            MCMC(rand(Uniform(bounds...), 4), g, dist, MersenneTwister()),
            steps = 5000, run_diagnostics = false
            )
        push!(plts, plot(chains.samples))
        #println(chains.diagnostics.Rstar)
    end
    plot(plts...)
end