m = Dict{Char,Int8}('.'=>0,'>'=>1,'v'=>2)
f = Matrix(reduce(hcat, map(x-> map(x->m[x], collect(x)), readlines("d25/input.txt")))')
function checkr(f,occ)
    for i = 1:size(f,1)
        for j = 1:size(f,2)-1
            if f[i,j] == 1
                @inbounds occ[i,j] = f[i,j+1] == 0
            else
                @inbounds occ[i,j] = 0
            end
        end
    end
    j = size(f,2)
    for i = 1:size(f,1)
        if f[i,j] == 1
            @inbounds occ[i,j] = f[i,1] == 0
        else
            @inbounds occ[i,j] = 0
        end
    end
end
function checkd(f,occ)
    for i = 1:size(f,1)-1
        for j = 1:size(f,2)
            if f[i,j] == 2
                @inbounds occ[i,j] = f[i+1,j] == 0
            else
                @inbounds occ[i,j] = 0
            end
        end
    end
    i = size(f,1)
    for j = 1:size(f,2)
        if f[i,j] == 2
            @inbounds occ[i,j] = f[1,j] == 0
        else
            @inbounds occ[i,j] = 0
        end
    end
end
function step(f,occr,occd)
    i,j = size(f)
    checkr(f,occr)
    rm = findall(x->x!=0, occr)
    @inbounds f[map(x->CartesianIndex(x[1],(x[2]%j)+1),rm)] .= 1
    @inbounds f[rm] .= 0
    checkd(f,occd)
    dm = findall(x->x!=0, occd)
    @inbounds f[map(x->CartesianIndex((x[1]%i)+1,x[2]),dm)] .= 2
    @inbounds f[dm] .= 0
    return length(rm) + length(dm)
end
function p1(f)
    f = copy(f)
    occr = zeros(UInt8,(size(f,1),size(f,2)))
    occd = zeros(UInt8,(size(f,1),size(f,2)))
    steps = 0
    while true
        moved = step(f,occr,occd)
        steps+=1
        if moved == 0
            break
        end
    end
    steps
end
using BenchmarkTools
@btime p1(f)
