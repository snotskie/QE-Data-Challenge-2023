#!/usr/bin/env -S ${HOME}/.local/bin/julia-1.8

println("Importing...")
using EpistemicNetworkAnalysis
using CSV
using DataFrames
using Plots
using Colors
using Statistics
using HypothesisTests
using JSON

# Helpers
function split_codes_by_variance(data, all_codes; threshold=0.01)

    ## Store variance for each feature in a dictionary and sum them
    variance_dict = Dict(
        feature => var(data[!, feature])
        for feature in all_codes
    )

    total_variance = sum(values(variance_dict))

    ## Divide each variance by the sum, and put each feature
    ## either into a drop list or a keep list
    drop_codes = Symbol[]
    keep_codes = Symbol[]
    for feature in keys(variance_dict)
        variance_dict[feature] /= total_variance
        if variance_dict[feature] < threshold
            push!(drop_codes, feature)
        else
            push!(keep_codes, feature)
        end
    end

    return drop_codes, keep_codes, variance_dict
end

let # local scope for the "main"

println("Loading Data...")
data = DataFrame(CSV.File("data/processed/data.csv", missingstring="NULL"))

println("Selecting codes...")
all_codes = [
    :PosEmoji,
    :NegEmoji,
    :PosEmph,
    :NegEmph,
    :NeuEmph,
    :PosWeather,
    :NegWeather,
    :Locals,
    :Work,
    :Friends,
    :Stranger,
    :Healthcare,
    :Family,
    :Dating,
    :Anxiety,
    :Dysphoria,
    :Boundaries,
    :SelfBlame,
    :Play,
    :Humor,
    :Gratitude,
    :Forward,
    :SelfCare,
    :Identity
]

drop_codes, keep_codes, variance_dict = split_codes_by_variance(data, all_codes, threshold=0.05)
println(variance_dict)

println("Defining basic model...")
conversations = [:All]
units = [:Date]
codes = keep_codes

windowSize = 12 # 4 days * 3 panels

println("Running linear model...")
myENA = ENAModel(
    data, codes, conversations, units,
    windowSize=windowSize
)

println("Plotting plain...")
p = plot(myENA, leg=false)
savefig(p, "public/figs/plain.svg")
savefig(plot(p.subplots[1], size=(600, 600)), "public/figs/plain_1.svg")
savefig(plot(p.subplots[2], size=(600, 600)), "public/figs/plain_2.svg")
savefig(plot(p.subplots[3], size=(600, 600)), "public/figs/plain_3.svg")
display(p)

println("Plotting with spectral colors...")
p = plot(myENA, spectralColorBy=:DateFloat, leg=false)
savefig(p, "public/figs/spectral.svg")
savefig(plot(p.subplots[1], size=(600, 600)), "public/figs/spectral_1.svg")
savefig(plot(p.subplots[2], size=(600, 600)), "public/figs/spectral_2.svg")
savefig(plot(p.subplots[3], size=(600, 600)), "public/figs/spectral_3.svg")
display(p)

println("Plotting with trajectory line...")
p = plot(myENA, showTrajectoryBy=:EpochInt, leg=false, showUnits=false)
savefig(p, "public/figs/trajectory.svg")
savefig(plot(p.subplots[1], size=(600, 600)), "public/figs/trajectory_1.svg")
savefig(plot(p.subplots[2], size=(600, 600)), "public/figs/trajectory_2.svg")
savefig(plot(p.subplots[3], size=(600, 600)), "public/figs/trajectory_3.svg")
display(p)

results = (
    figs=(
        plain=(
            all="figs/plain.svg",
            a="figs/plain_1.svg",
            b="figs/plain_2.svg",
            c="figs/plain_3.svg",
        ),
        spectral=(
            all="figs/spectral.svg",
            a="figs/spectral_1.svg",
            b="figs/spectral_2.svg",
            c="figs/spectral_3.svg",
        ),
        trajectory=(
            all="figs/trajectory.svg",
            a="figs/trajectory_1.svg",
            b="figs/trajectory_2.svg",
            c="figs/trajectory_3.svg",
        )
    ),
    variance=variance_dict
)

println("Saving results...")
open("data/output/results.json","w") do f
    JSON.print(f, results)
end

println("Done!")

end # let