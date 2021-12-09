f = split.(strip.(readlines("./d8/d8_input.txt")), " | ")

p1 = sum(count.(x -> x == 2 || x == 3 || x == 4 || x == 7, map(x -> length.(split(x[2])), f)))
# Part 2
using Combinatorics, OffsetArrays
permuts = collect(permutations(['a', 'b', 'c', 'd', 'e', 'f', 'g']))
permuted(in, permutation) = String(sort(permutation[(Int.(collect(in)).-Int('`'))]))
tonum(s) = findfirst(isequal(s), OffsetVector(["abcdeg", "ab", "acdfg", "abcdf", "abef", "bcdef", "bcdefg", "abd", "abcdefg", "abcdef"], 0:9))
isnum(s) = !isnothing(tonum(s))
function solve(i, o)
    idx = findfirst(p -> all(isnum.([permuted(k, p) for k in i])), permuts)
    return parse(Int, join(tonum.([permuted(k, permuts[idx]) for k in o])))
end

sum(x -> solve(split(x[1]), split(x[2])), f)


########## LOGICAL SOLUTION ##############
# https://www.reddit.com/r/adventofcode/comments/rbj87a/2021_day_8_solutions/hnpgp65/
using Match, LinearAlgebra
function decode(o, one, four)
    len = length(o)
    @match len begin
        2 => return 1
        4 => return 4
        7 => return 8
        3 => return 7
    end
    int1 = length(intersect(o, one))
    @match (len, int1) begin
        (5, 2) => return 3
        (6, 1) => return 6
    end
    int4 = length(intersect(o, four))
    return @match (len, int4) begin
        (5, 2) => 2
        (5, 3) => 5
        (6, 4) => 9
        (6, 3) => 0
    end
end
function solve(l)
    i = collect.(split(l[1]))
    o = collect.(split(l[2]))
    one = i[findfirst(x -> length(x) == 2, i)]
    four = i[findfirst(x -> length(x) == 4, i)]
    return dot([1000 100 10 1], [decode(n, one, four) for n in o])
end
@btime sum(solve.(f))
# 745.300 μs (11205 allocations: 1.01 MiB)