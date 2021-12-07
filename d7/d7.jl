f = parse.(Int, split(readline("./d7/d7_input.txt"), ","))
#part 1
minimum(i -> sum(abs.(f.-i)), 0:maximum(f))
#part 2
minimum(i -> sum(p -> sum(1:abs(p-i)), f), 0:maximum(f))