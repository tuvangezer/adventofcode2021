using BenchmarkTools, DataStructures
dirs = CartesianIndex.([(0, 1), (0, -1), (1, 0), (-1, 0)])
function repeat_input(infile)
    f = reduce(hcat, map(x -> parse.(Int8, x), collect.(readlines(infile))))'
    m = copy(f)
    for i in 1:4
        m = hcat(m, (f.+i).%9)
    end
    mr = copy(m)
    for i in 1:4
        m = vcat(m, (mr.+i).%9)
    end
    m[m .== 0] .= 9
    Int8.(m)
    end
function setup(fname)
    global f = repeat_input(fname)
end
# https://en.wikipedia.org/wiki/A*_search_algorithm
function constructPath(cameFrom, cur)
    l = 0
    while haskey(cameFrom, cur)
        l += f[cur]
        cur = cameFrom[cur]
    end
    l
end
function aˣ()
    ni, nj = size(f)
    h(x::CartesianIndex{2}) = ni - x[1] + nj - x[2] # Heuristic Function
    openSet = PriorityQueue{CartesianIndex{2}, Int}()
    openSet[CartesianIndex(1,1)] = 0
    gScores = DefaultDict{CartesianIndex{2}, Int}(typemax(Int))
    gScores[CartesianIndex(1,1)] = 0
    fScores = DefaultDict{CartesianIndex{2}, Int}(typemax(Int))
    fScores[CartesianIndex(1,1)] = h(CartesianIndex(1,1))
    cameFrom = Dict{CartesianIndex{2},CartesianIndex{2}}()
    while !isempty(openSet)
        current = dequeue!(openSet)
        if current[1] == ni && current[2] == nj #Goal check
            return constructPath(cameFrom, current)
        end
        for d in dirs
            n = d + current
            if checkbounds(Bool, f, n[1], n[2])
                tentative_gScore = gScores[current] + f[n]
                if tentative_gScore < gScores[n]
                    cameFrom[n] = current
                    gScores[n] = tentative_gScore
                    fScores[n] = tentative_gScore + h(n)
                    if !haskey(openSet, n)
                        openSet[n] = tentative_gScore + h(n)
                    end
                end
            end
        end
    end
    println("Failed to build path!")
end
setup("d15/d15_input.txt")
@btime aˣ()
