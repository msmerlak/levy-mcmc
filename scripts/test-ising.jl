using DrWatson
@quickactivate

include(srcdir("ising.jl"))
include(srcdir("utils.jl"))

using Graphs, GraphPlot
using Plots

lattice = Graphs.grid([20, 20], periodic = false)

A=adjacency_matrix(lattice)
L = size(A)[1]

σ₀ = ones(L)

T = 1.5
S = 1
max_flips = 5000

begin
    single_flip = Ising(
    A,
    σ₀,
    T,
    0,
    1,
    MersenneTwister(),
    0.
)

zipf_flip = Ising(
    A,
    σ₀,
    T,
    0,
    S,
    MersenneTwister(),
    0.
)

    simple_mcmc = run(single_flip, max_flips = max_flips)
    

    zipf_mcmc = run(zipf_flip, max_flips = max_flips)
end

plt = plot(simple_mcmc.flips, abs.(time_avg(simple_mcmc.magnetization)), label = "single spin flips", xlabel = "spin flips", ylabel = "magnetization")
plot!(plt, zipf_mcmc.flips, abs.(time_avg(zipf_mcmc.magnetization)), label = "zipfian spin flips")

savefig(plt, plotsdir("zipf-ising.pdf"))