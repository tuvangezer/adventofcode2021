f = map.(x -> parse(Int, x)+1, split.(replace.(collect(eachline("./d5/d5_input.txt")), " -> " => ","), ","))
inpoints(p) = [CartesianIndex.(i,j) for i in p[1]:ifelse(p[3]>p[1], 1, -1):p[3] for j in p[2]:ifelse(p[4]>p[2], 1, -1):p[4]]
inpointsdiag(p) = [CartesianIndex.(p[1] + i, p[2] + abs(i) * ifelse(p[4]>p[2], 1, -1)) for i in 0:ifelse(p[3]>p[1], 1, -1):p[3]-p[1]]
grid = zeros(maximum(maximum.(f)), maximum(maximum.(f)))
foreach(x->grid[inpoints(x)] .+= 1, filter(x->x[1] == x[3] || x[2] == x[4], f))
sum(grid .> 1)

# Part 2
f = map.(x -> parse(Int, x)+1, split.(replace.(collect(eachline("./d5/d5_input.txt")), " -> " => ","), ","))
grid = zeros(maximum(maximum.(f)), maximum(maximum.(f)))
foreach(x->grid[inpoints(x)] .+= 1, filter(x->x[1] == x[3] || x[2] == x[4], f))
foreach(x->grid[inpointsdiag(x)] .+= 1, filter(x->x[1] != x[3] && x[2] != x[4], f))
sum(grid .> 1)
