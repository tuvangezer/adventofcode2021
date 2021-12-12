using DataStructures
ways = Dict()
function addNeighbor(s, d)
    if haskey(ways, s)
        push!(ways[s], d)
    else
        ways[s] = [d]
    end
end
for l in readlines("./d12/d12_input.txt")
    n1,n2 = String.(split(l, '-'))
    addNeighbor(n1, n2)
    addNeighbor(n2, n1)
end
solutions = []
function canvisit(visited, n) 
    #part 1 return !(lowercase(n) == n && n in visited)
    if n == "start" 
        return false
    end
    scounts = sort(collect(counter(filter(x-> lowercase(x) == x, visited))), by=x->x[2], rev=true)
    if length(scounts) > 0 && scounts[1][2] == 2 
        return !(lowercase(n) == n && n in visited)
    end
    return true 
end
function walk(visited, st)
    visited = copy(visited)
    push!(visited, st) 
    if st == "end"
        push!(solutions, join(visited, ','))
        return
    end
    for n in ways[st]
        if canvisit(visited, n)
        walk(visited, n)
        end
    end
end
@btime begin 
    solutions = []
    walk([],"start")
end

solutions

# map(enumerate(unique(reduce(vcat,split.(readlines("./d12/d12_input.txt"), '-'))))) do (i, v)
#     (v, i + (-20 * (lowercase(v) == v)))
# end