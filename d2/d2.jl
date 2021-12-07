# part 1
fwd = 0; dpth = 0
for l in eachline("./d2/d2_input.txt")
    d, v = split(l, " ")
    v = parse(Int, v)
    if d == "up" dpth -= v
    elseif d == "down"  dpth += v
    elseif d == "forward" fwd += v
    end
end
fwd * dpth
# part 2
fwd = 0; aim = 0; dpth = 0
for l in eachline("./d2/d2_input.txt")
    d, v = split(l, " ")
    v = parse(Int, v)
    if d == "up" aim -= v
    elseif d == "down"  aim += v
    elseif d == "forward" fwd += v; dpth += aim * v
    end
end
fwd * dpth

# file parse alternative
function parse_line(l)
    d, v = split(l, " ") 
    return Symbol(d), parse(Int, v)
end

parse_line.(eachline("./d2/d2_input.txt"))
