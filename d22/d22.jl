using DataStructures
lines = readlines("d22/input.txt")
ranges = map(s->SubString.(s, findall(r"(\-?\d+\.\.\-?\d+)",s)), lines)
ranges = map(r->map(x->Tuple(parse.(Int, x)), split.(r, "..")), ranges)
commands = map(x-> x>0 ? 1 : -1, startswith.(lines, "on"))
vol(c) = prod(x->(x[2]-x[1]+1),c)
overlaps(x,y) = x[1] <= y[2] && y[1] <= x[2]
#filter!(x-> overlaps(x[1], (-50,50))&&overlaps(x[2], (-50,50))&&overlaps(x[3], (-50,50)),ranges)
function p2()
    cubes = Accumulator{Vector{Tuple{Int,Int}}, Int}()
    for i in 1:length(ranges)
        upacc = Accumulator{Vector{Tuple{Int,Int}}, Int}()
        nx = ranges[i][1];ny = ranges[i][2];nz = ranges[i][3];
        for (e, ev) in cubes
            ex = e[1];ey = e[2];ez = e[3];
            ix = (max(ex[1],nx[1]), min(ex[2],nx[2]))
            iy = (max(ey[1],ny[1]), min(ey[2],ny[2]))
            iz = (max(ez[1],nz[1]), min(ez[2],nz[2]))
            if ix[1] <= ix[2] && iy[1] <= iy[2] && iz[1] <= iz[2]
                upacc[[ix,iy,iz]] -= ev
            end
        end
        if commands[i] > 0
            upacc[[nx,ny,nz]] += commands[i]
        end
        merge!(cubes, upacc)
    end
    s = 0
    for (e, ev) in cubes
        s += vol(e) * ev
    end
    s
end
p2()
