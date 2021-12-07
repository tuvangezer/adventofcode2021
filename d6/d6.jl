f = parse.(Int, split(readline("./d6/d6_input.txt"), ","))
fish = [count(f .== i) for i in 0:8]
function passday!(d)
    z = d[1]
    d[:] = circshift(d, -1)
    d[7] += z
end
for _ = 1:256 passday!(fish) end
sum(fish)


