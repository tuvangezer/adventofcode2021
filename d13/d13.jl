using BenchmarkTools

function createbitmatrix(fn)
    f = map(x -> parse.(Int, x), split.(readlines(fn), ','))
    m = BitArray(undef, maximum(x -> x[2], f) + 1, maximum(x -> x[1], f) + 1)
    fill!(m, 0)
    for n in f
        m[n[2]+1, n[1]+1] = 1
    end
    return m
end
function foldh(m)
    i, j = size(m)
    fp = floor(Int, i/2)
    m[end:-1:fp+2,:] .| m[1:fp,:]
end
function foldv(m)
    i, j = size(m)
    fp = floor(Int, j/2)
    m[:, end:-1:fp+2] .| m[:, 1:fp]
end
m = createbitmatrix("d13/d13_input.txt")
sum(foldv(m)) # part 1
@btime begin 
    global mw = copy(m)
    mw = foldv(mw)
    mw = foldh(mw)
    mw = foldv(mw)
    mw = foldh(mw)
    mw = foldv(mw)
    mw = foldh(mw)
    mw = foldv(mw)
    mw = foldh(mw)
    mw = foldv(mw)
    mw = foldh(mw)
    mw = foldh(mw)
    mw = foldh(mw)
end

using Plots
backend(:plotly)
p = heatmap(mw[end:-1:1,:])