using MCMCDiagnostics

include("../src/mcmc.jl")

function gelman_rubin(g, dist, bounds; steps = 1000, burnin = 0, m = 100)
    chains = []
    for i=1:m
        problem = MCMC(1, rand(Uniform(bounds...)), g, dist, MersenneTwister())
        push!(chains, mcmc(problem; steps = steps, burnin = burnin).samples)
    end
    return potential_scale_reduction(
        map(chain -> reduce(vcat, chain), chains)...)
end