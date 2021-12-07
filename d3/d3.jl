i = vcat([x' for x in map(x -> parse.(Int, x),collect.(collect(eachline("./d3/d3_input.txt"))))]...)
γ = (sum(i, dims=1) .> 500) * [2^(i-1) for i in 12:-1:1]
ϵ = (sum(i, dims=1) .< 500) * [2^(i-1) for i in 12:-1:1]
γ .* ϵ

# Part 2
i2 = copy(i)
for c in 1:12
 if size(i,1) > 1 i = i[i[:,c] .== (sum(i[:,c], dims=1) .>= size(i,1) / 2),:] end
 if size(i2,1) > 1 i2 = i2[i2[:,c] .!= (sum(i2[:,c], dims=1) .>= size(i2,1) / 2),:] end
end
o2  = i * [2^(i-1) for i in 12:-1:1]
co2 = i2 * [2^(i2-1) for i2 in 12:-1:1]
o2 .* co2