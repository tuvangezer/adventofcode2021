function flatteninput(i)
    d = -1
    o = []
    for c in collect(i)
        if c == '['
            d += 1
        elseif c == ']'
            d -= 1
        elseif isnumeric(c)
            push!(o, (parse(Int, c), d))
        end
    end
    o
end
function explode!(idx, i)
    if idx > 1
        i[idx-1] = (i[idx-1][1] + i[idx][1], i[idx-1][2])
    end
    if idx + 1 < length(i)
        i[idx+2] = (i[idx+2][1] + i[idx+1][1], i[idx+2][2])
    end
    insert!(i, idx, (0, i[idx][2]-1))
    deleteat!(i, idx+1)
    deleteat!(i, idx+1)
end
function split!(idx, i)
    d = i[idx][2] + 1
    v = i[idx][1]
    deleteat!(i, idx)
    insert!(i, idx, (floor(Int, v/2),d))
    insert!(i, idx+1, (ceil(Int, v/2),d))
end
function step!(i)
    idx = findfirst(x->x[2] == 4, i)
    if !isnothing(idx)
        explode!(idx, i)
        return true
    end
    idx = findfirst(x->x[1] >= 10, i)
    if !isnothing(idx)
        split!(idx, i)
        return true
    end
    return false
end
function reducelist!(i)
    while step!(i)
    end
    return i
end
function addlists(i1,i2)
    return append!(map(x->(x[1],x[2]+1),i1), map(x->(x[1],x[2]+1),i2))
end
function magnitude!(f)
    while length(f) > 1 
        d = maximum(x->x[2], f)
        idx = findfirst(x->x[2] == d, f)
        insert!(f, idx, (3*f[idx][1] + 2*f[idx+1][1], f[idx][2]-1))
        deleteat!(f, (idx+1, idx+2))
    end
    return f[1][1]
end
# part 1
f = reduce((a,b)-> reducelist!(addlists(a,b)), flatteninput.(readlines("d18/d18_input.txt")))
magnitude!(f) 
# part 2
using Combinatorics
maximum(c-> max(magnitude!(reducelist!(addlists(c[2],c[1]))),magnitude!(reducelist!(addlists(c[1],c[2])))), collect(combinations(flatteninput.(readlines("d18/d18_input.txt")), 2)))
