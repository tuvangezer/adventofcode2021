using Rotations, DataStructures, LinearAlgebra, Combinatorics, BenchmarkTools
function readinput(instr)
    scanners = Dict{String,Vector{Vector{Int64}}}()
    s = "-"
    for line in readlines(instr)
        if length(line) > 1
            if startswith(line, "---")
                s = line
                scanners[s] = []
            else
                push!(scanners[s], parse.(Int, split(line, ',')))
            end
        end
    end
    scanners
end
function genrotmatrices()
rots = []
for x in [-1 1]
    for y in [-1 1]
        for z in [-1 1]
            for q in permutations([[x 0 0], [0 y 0], [0 0 z]])
                m = reduce(vcat, q)
                if det(m) == 1
                    push!(rots, m)
                end
            end
        end
    end
end
return rots
end
function extractpoints(fname)
    scanners = readinput(fname)
    rots = genrotmatrices()
    id = [1 0 0; 0 1 0; 0 0 1]
    r0 = [i' * id for i in scanners["--- scanner 0 ---"]]
    jobs = filter(x -> x != "--- scanner 0 ---", keys(scanners))
    offsets = [[0 0 0]]
    while length(jobs) > 0
        for job in jobs
            for ri in rots
                r1 = [i' * ri for i in scanners[job]]
                counts = sort(collect(counter([j - i for i in r1 for j in r0])); by = x -> x[2], rev = true)
                if counts[1][2] >= 12
                    append!(r0, [i + counts[1][1] for i in r1])
                    filter!(x -> x != job, jobs)
                    push!(offsets, counts[1][1])
                    #append!(beacons, [i + counts[1][1] for i in r1])
                    break
                end
            end
        end
    end
    println("Largest distance $(maximum([sum(abs.(i-j)) for i in offsets for j in offsets]))")
    return unique(r0)
end
@btime extractpoints("d19/d19_input.txt")
