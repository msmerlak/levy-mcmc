using DrWatson
@quickactivate

using Random, Distributions
using MCMCChains
using MLJBase, MLJXGBoostInterface, Statistics


mutable struct MCMC
    configuration
    target_density
    jump_dist
    rng
end

function mcmc(problem::MCMC; steps = 1000, burnin = 0, num_chains = 10, run_diagnostics = true)

    chains = zeros(steps - burnin, length(problem.configuration), num_chains)

    for c = 1:num_chains

        accepted_moves = 0

        for i in 1:steps
            x = problem.configuration .+ rand(problem.rng, problem.jump_dist, length(problem.configuration))
            if rand(problem.rng) < problem.target_density(x)/problem.target_density(problem.configuration)
                problem.configuration = x
                accepted_moves += 1
            end

            if i > burnin
                chains[i - burnin, :, c] .= problem.configuration
            end
        end

    end

    chains = Chains(chains)

    if run_diagnostics
        ESS_Rhat = ess_rhat(chains)
        Rstar = mean(rstar(XGBoostClassifier(), chains))
        diagnostics = (ESS_Rhat = ESS_Rhat, Rstar = Rstar)
    else
        diagnostics = nothing
    end
    
    return (samples = chains, diagnostics = diagnostics)

end

