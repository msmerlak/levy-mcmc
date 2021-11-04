using LinearAlgebra, StatsBase, Random, Distributions
using Graphs

mutable struct Ising
    A::Matrix{Int64}
    σ::Vector{Int64}
    T::Float64
    flips::Int64
    S::Int64
    rng::T where T <: Random.AbstractRNG
    magnetization::Float64
end

function energy(model::Ising, σ = nothing)
    if σ === nothing
        σ = model.σ 
    end
    return - 0.5*dot(σ, model.A * σ)
end


function spin_flips!(model)

    range = collect(1:model.S)
    n = min(length(model.σ), sample(model.rng, range, ProbabilityWeights(1 ./ range.*2)))

    spins_to_flip = sample(model.rng, 1:length(model.σ), n, replace = false)
    
    σ_flipped = deepcopy(model.σ)
    σ_flipped[spins_to_flip] *= -1
    
    if rand(model.rng) < exp(-(energy(model,σ_flipped) - energy(model,model.σ))/(2*model.T))
        model.σ = σ_flipped
        
        model.magnetization = sum(model.σ)/length(model.σ)
        model.flips += n
    end

    return
end

function run(model; max_flips = 1000)
    f = []
    m = []
    model.magnetization = sum(model.σ)/length(model.σ)

    step = 0
    while model.flips < max_flips
        step += 1
        spin_flips!(model)
        push!(f, model.flips)
        push!(m, model.magnetization)
    end
    return (flips = f, magnetization = m)
end


