xt = (119,176)
yt = (-141,-84)
#x=119..176, y=-141..-84
function changev!(v::Vector{Int16})
    if v[1] > 0
        v[1] -= 1
    end
    v[2] -= 1
end
function trace(v::Vector{Int16})
    p::Vector{Int16} = [0,0]
    v = copy(v)
    while p[1] < xt[2] && p[2] > yt[1]
       p += v
       if p[1] in xt[1]:xt[2] && p[2] in yt[1]:yt[2]
            return true
       end
       changev!(v)
    end
    return false
end
searchspace = [Int16.([i, j]) for i in 0:xt[2] for j in yt[1]:200]

searchspace[argmax(trace.(searchspace))]

count(trace.(searchspace))
trace.(searchspace)