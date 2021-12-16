function hex2bits(h)
    m = Dict([('0', "0000"), ('1', "0001"), ('2', "0010"), ('3', "0011"), ('4', "0100"), ('5', "0101"), ('6', "0110"), ('7', "0111"), ('8', "1000"), ('9', "1001"), ('A', "1010"), ('B', "1011"), ('C', "1100"), ('D', "1101"), ('E', "1110"), ('F', "1111")])
    return join(map(x -> m[x], collect(h)))
end
ops = Dict([("000", sum), ("001", prod), ("010", minimum), ("011", maximum), ("101", x->Int(x[1]>x[2])), ("110", x->Int(x[1]<x[2])), ("111", x->Int(x[1]==x[2]))])
function parseliteral(b)
    i = 7
    chunk = b[i:i+4]
    val = chunk[2:5]
    while chunk[1] == '1'
        i += 5
        chunk = b[i:i+4]
        val = val * chunk[2:5]
    end
    return (parse(Int, val, base=2), i + 4)
end
function parseop(op,b)
    lid = b[7]
    vals = []
    if lid == '0'
        len = parse(UInt16, b[8:22], base = 2)
        s = 23
        while s - 23 < len
            v, e = parsepacket(b[s:end])
            push!(vals, v)
            s += e
        end
        return (ops[op](vals), s - 1)
    else
        len = parse(UInt16, b[8:18], base = 2)
        s = 19
        for _ = 1:len
            v, e = parsepacket(b[s:end])
            push!(vals, v)
            s += e
        end
        return (ops[op](vals), s - 1)
    end
end
versions = []
function parsepacket(b)
    version = b[1:3]
    push!(versions, version)
    type = b[4:6]
    if type == "100"
        return parseliteral(b)
    else
        return parseop(type, b)
    end
end
parsepacket(hex2bits(readline("d16/d16_input.txt")))
sum(parse.(Int,versions,base=2))

using BenchmarkTools
inp = hex2bits(readline("d16/d16_input.txt"))
@btime parsepacket(inp)