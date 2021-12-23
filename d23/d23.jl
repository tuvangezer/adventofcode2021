#############
#12.3.4.5.67#
###8#A#C#E###
###9#B#D#F###
#############
using DataStructures
function create_paths()
   paths = Dict{UInt8,Vector{Tuple{UInt8,UInt8}}}();
   paths[1] = [(2,1)];
   paths[2] = [(1,1),(3,2),(8,2)];
   paths[3] = [(2,2),(4,2),(8,2),(10,2)];
   paths[4] = [(3,2),(5,2),(10,2),(12,2)];
   paths[5] = [(4,2),(6,2),(12,2),(14,2)];
   paths[6] = [(5,2),(7,1),(14,2)];
   paths[7] = [(6,1)];
   paths[8] = [(2,2),(3,2),(9,1)];
   paths[9] = [(8,1)];
   paths[10] = [(3,2),(4,2),(11,1)];
   paths[11] = [(10,1)];
   paths[12] = [(4,2),(5,2),(13,1)];
   paths[13] = [(12,1)];
   paths[14] = [(5,2),(6,2),(15,1)];
   paths[15] = [(14,1)];
   paths
end
paths = create_paths()
state = Vector{UInt8}([0,0,0,0,0,0,0,'D','C','D','A','B','B','A','C'])
#state = Vector{UInt8}([0,0,0,0,0,0,0,'A','A','B','B','C','C','D','D'])
cost(c)::UInt = 10^(c-0x41)
issolution(s)::Bool = s[8] == 0x41 && s[10] == 0x42 && s[12] == 0x43 && s[14] == 0x44 && s[8] == s[9] && s[10] == s[11] && s[12] == s[13] && s[14] == s[15]
bests = DefaultDict{Vector{UInt8},UInt}(typemax(UInt));
from = Dict{Vector{UInt8},Vector{UInt8}}();
jobs = PriorityQueue([(state,0)]);
bestcost = typemax(UInt);

function update_bests(s,c)
    if c >= bests[s] 
        return
    else
        bests[s] = c 
    end
    for (i,v) in enumerate(s)
        if v == 0 continue end
        for (n, pcost) in paths[i]
            if s[n] != 0 continue end
            s_new = copy(s)
            s_new[i] = 0
            s_new[n] = v
            cost_new = c + cost(v)*pcost
            if (cost_new > bestcost) || (cost_new >= bests[s_new]) continue end
            #bests[s_new] = cost_new
            from[s_new] = copy(s)
            if haskey(jobs, s_new) 
                if jobs[s_new] > cost_new
                    jobs[s_new] = cost_new
                end
            else
                jobs[s_new] = cost_new
            end
            if issolution(s_new)
                if cost_new < bestcost
                    global bestcost = cost_new
                    global bestsolution = s_new
                end
                println("Found solution")
            end
            #update_bests(s_new)
            #println("New state: $s_new, cost:$cost_new, moving: $v")
        end
    end
end
done = 0
while !isempty(jobs)
    (j,c) = dequeue_pair!(jobs)
    update_bests(j,c)
    done += 1
    if done % 10000 == 0 
        println("$done Completed, $(length(jobs)) in queue...")
    end
    if bestcost < typemax(UInt)
        break
    end
end
Int(bestcost)
@show Char.(bestsolution)

function sols(s)
    s = copy(s)
    s[s.==0] .= '.' 
     s=Char.(s)
     return "#############\n#$(s[1])$(s[2]).$(s[3]).$(s[4]).$(s[5]).$(s[6])$(s[7])#\n###$(s[8])#$(s[10])#$(s[12])#$(s[14])###\n###$(s[9])#$(s[11])#$(s[13])#$(s[15])###\n#############\n"
end
b = bestsolution
while b != state
    println("Cost:$(bests[b])\n$(sols(b))")
    b = from[b]
end
println("Cost:$(bests[b])\n$(sols(b))")
from[b]
println(sols(bestsolution))

# partial solution. Something is broken with cost calculation