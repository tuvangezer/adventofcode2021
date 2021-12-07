using Statistics
f = parse.(Int, split(readline("./d7/d7_input.txt"), ","))
#part 1
minimum([sum(abs.(f.-i)) for i in 0:maximum(f)])
#part 2
minimum([sum(abs.(f.-i).*(abs.(f.-i).+1) ./2) for i in 0:maximum(f)])