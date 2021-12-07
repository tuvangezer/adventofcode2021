# Setup
f = collect(eachline("./d4/d4_input.txt"))
bingos = [reduce(hcat, map(x -> parse.(Int, x), split.(f[b:b+4]))) for b = 3:6:size(f, 1)-1]
pulls = parse.(Int, split(f[1], ','))
isbingo(b) = any(sum(b, dims = 2) .== -5) || any(sum(b, dims = 1) .== -5)
pullnumber(b, n) = b[b.==n] .= -1
# Part 1
while true
    global pulled = popfirst!(pulls)
    pullnumber.(bingos, pulled)
    global winners = filter(isbingo, bingos)
    length(winners) < 1 || break
end
sum(filter(x -> x > 0, winners[1])) * pulled

# Part 2, need to run setup again
while true
    global pulled = popfirst!(pulls)
    pullnumber.(bingos, pulled)
    global winners = filter!(!isbingo, bingos)
    length(bingos) > 1 || break
end
while !isbingo(bingos[1])
    global pulled = popfirst!(pulls)
    pullnumber(bingos[1], pulled)
end
sum(filter(x -> x > 0, bingos[1])) * pulled

####
using LoopVectorization
a = zeros(100_000_000)

@time Threads.@threads for i = 1:100000000
    a[i] = Threads.threadid()
end

@time for i = 1:100000000
    a[i] = Threads.threadid()
end

@time @turbo for i = 1:100000000
    a[i] = Threads.threadid()
end

a = rand(5, 5)
F = LinearAlgebra.lu(a, check = true)
F.L * F.U

a[F.p, :]
F.L
cdist(x, y) = 1 - dot(x, y) / (norm(x) * norm(y))
cossim(x, y) = dot(x, y) / (norm(x) * norm(y))

a = rand(500, 50)
a[:, 12] = a[:, 1] #+ rand(500) / 100
F = svd(a)
F.U #* Diagonal(F.S) * F.Vt 
F.U * Diagonal(F.S) #* F.Vt
Diagonal(F.S)
cossim(abs.(F.Vt[:, 1]), abs.(F.Vt[:, 12]))

norm(F.Vt[:, 12])
cdist(abs.(F.Vt[:, 12]), abs.(F.Vt[:, 1]))
