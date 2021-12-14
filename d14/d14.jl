using DataStructures, BenchmarkTools
f = readlines("d14/d14_input.txt")
instr = strip(f[1])
inmap = Dict(map(x -> (collect(String(instr[x:x+1])), 1), 1:length(instr)-1))
repmap = Dict(map(x -> (collect(String(x[1])), Char(x[2][1])), split.(f[3:end], " -> ")))
# Define power of function because why not
function (^)(f::Function, i::Int)
    function inner(x)
       for ii in i:-1:1
          x=f(x)
       end
    x
    end
end
function step(m)
    o = DefaultDict{Vector{Char},Int64}(0)
    for (k, v) in collect(m)
            mid = repmap[[k[1], k[2]]]
            o[[k[1], mid]] += v
            o[[mid, k[2]]] += v
    end
    o
end
function result(m)
    c = DefaultDict{Char,Int64}(0)
    for (k, v) in collect(m)
        c[k[1]] += v 
    end
    c[instr[end]] += 1
    s = sort(collect(c); by=x->x[2], rev=true)
    s[1][2]-s[end][2]
end
@btime result((step^40)(inmap))