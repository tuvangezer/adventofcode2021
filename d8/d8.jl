f = split.(strip.(readlines("./d8/d8_input.txt")), " | ")

p1 = sum(count.(x-> x == 2 || x == 3 || x == 4 || x == 7, map(x->length.(split(x[2])), f)))
# Part 2
using Combinatorics, OffsetArrays
permuts = collect(permutations(['a','b','c','d','e','f','g']))
permuted(in, permutation) = String(sort(permutation[(Int.(collect(in)) .- Int('`'))]))
tonum(s) = findfirst(isequal(s), OffsetVector(["abcdeg", "ab", "acdfg", "abcdf", "abef", "bcdef", "bcdefg", "abd", "abcdefg", "abcdef"], 0:9))
isnum(s) = !isnothing(tonum(s))
function solve(i, o)
    idx = findfirst(p->all(isnum.([permuted(k,p) for k in i])), permuts)
    return parse(Int, join(tonum.([permuted(k, permuts[idx]) for k in o])))
end

sum(x->solve(split(x[1]),split(x[2])), f)