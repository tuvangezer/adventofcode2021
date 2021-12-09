using ImageFiltering
f = reduce(hcat, map(x->parse.(Int,x), collect.(readlines("./d9/d9_input.txt"))))'
pf = padarray(f, Fill(10,(1,1),(1,1)))
tw(x) = x[2,2] < x[2,1] && x[2,2] < x[2,3] && x[2,2] < x[1,2] && x[2,2] < x[3,2]
p1 = mapwindow(tw, pf, (3,3))
sum(pf[p1] .+ 1)

function recwalk(i,j)
    f[i,j] = 10
    n = 1
    for d in ((-1,0),(1,0),(0,1),(0,-1))
        ni = i+d[1]
        nj = j+d[2]
        if ni in 1:size(f,1) && nj in 1:size(f,2) && f[ni,nj] < 9
            n += recwalk(ni,nj)
        end
    end
    return n
end
reduce((a,b) -> a*b, sort(map(x->recwalk(x[1],x[2]), findall(p1));rev=true)[1:3])
