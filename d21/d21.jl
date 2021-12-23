using Memoize, BenchmarkTools
@memoize function p2(p1pos, p2pos, p1s, p2s)
    if p2s >= 21 return (0, 1) end    
    wins1, wins2 = (0, 0)
    for (roll, times) in [(3,1),(4,3),(5,6),(6,7),(7,6),(8,3),(9,1)]
        pos1_ = (p1pos + roll - 1) % 10 + 1
        w2, w1 = p2(p2pos, pos1_, p2s, p1s + pos1_)
        wins1, wins2 = wins1 + times*w1, wins2 + times*w2
    end
    return wins1, wins2
end

@btime p2(2,5,0,0) setup=(empty!(memoize_cache(p2)))