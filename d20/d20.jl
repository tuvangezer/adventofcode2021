using ImageFiltering,BenchmarkTools
fname = "d20/d20_input.txt"
alg = Int16.(collect(readline(fname)) .== '#')
inimg = reduce(hcat, map(x->Int16.(x.=='#'), collect.(readlines(fname)[3:end])))'
inimg = padarray(inimg, Fill(0,(50,50),(50,50)))
convm = centered([2^8 2^7 2^6;2^5 2^4 2^3;2^2 2^1 2^0])
step(img) = map(x->alg[x+1],imfilter(img, convm))
# Step 1
sum(step(step(inimg)))
# Step 2
@btime sum(foldl((x,y)->step(x),1:50, init=inimg))