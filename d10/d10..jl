using DataStructures
f = readlines("./d10/d10_input.txt")
points = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
lookup = Dict('(' => ')', '{' => '}', '[' => ']', '<' => '>')
function illegal(instr)
    s = Stack{Char}()
    for c in instr
        if c in "([{<"
            push!(s, c)
        else
            if length(s) < 1 || lookup[pop!(s)] != c
                return c
            end
        end
    end
end

sum(x -> points[x], filter(!isnothing, illegal.(f)))
####### PART 2 #########
using Statistics, DataStructures, BenchmarkTools
f = readlines("./d10/d10_input.txt")
points2 = Dict('(' => 1, '[' => 2, '{' => 3, '<' => 4)
lookup = Dict('(' => ')', '{' => '}', '[' => ']', '<' => '>')
getpoint(x) = sum([points2[v] * 5^(i - 1) for (i, v) in enumerate(reverse(x))])
function p2(instr)
    s = Stack{Char}()
    for c in instr
        if c in "([{<"
            push!(s, c)
        else
            if length(s) < 1 || lookup[pop!(s)] != c
                return 0
            end
        end
    end
    return getpoint(collect(s))
end
@btime median(filter(x -> x > 0, p2.(f)))

