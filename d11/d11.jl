f = reduce(hcat, map.(x->Int8(x)-Int8('0'), collect.(readlines("./d11/d11_input.txt"))))'
dirs = [(-1,-1),(-1,1),(-1,0),(1,1),(1,-1),(1,0),(0,1),(0,-1)]
function flash_point(f, i, j)
    f[i,j] = -1
    for (i2,j2) in dirs
        i2 += i
        j2 += j
        if i2 in 1:10 && j2 in 1:10 && f[i2,j2] != -1
            f[i2,j2] += 1
            if f[i2, j2] == 10 
                flash_point(f,i2,j2)
            end
        end
    end
end
function step_forward(f)
    f .+= 1
    flashers = findall(f.==10)
    for flasher in flashers
        flash_point(f,flasher[1],flasher[2])
    end
    flash_final = f.==-1
    f[flash_final] .= 0
    return count(flash_final)
end
# part 1
@btime sum(_->step_forward(f), 1:100)
# part 2 need to recreate f
findfirst(_->step_forward(f) == 100, 1:1000)
