using ShiftedArrays
i =  parse.(Int64, collect(eachline("./d1/d1_input.txt")))
count(skipmissing(i - lag(i) .> 0))
# Part 2
count(skipmissing(i - lag(i, 3) .> 0))


# Part 2 naive
using DSP
i2 = conv(i, [1;1;1])[3:end-2]
count(skipmissing(i2 - lag(i2) .> 0))

