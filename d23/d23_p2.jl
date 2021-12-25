#############
#12.3.4.5.67#
###8#C#G#K###
###9#D#H#L###
###A#E#I#M###
###B#F#J#N###
#############
using DataStructures, Graphs, SimpleWeightedGraphs, Memoize, BenchmarkTools
function add_edge2!(g,a,b,w)
    add_edge!(g,a,b,w)
    add_edge!(g,b,a,w)
end
function build_graph()
    g = SimpleWeightedDiGraph(23)

    for i = 8:4:20
        add_edge2!(g,i,i+1,1)
        add_edge2!(g,i+1,i+2,1)
        add_edge2!(g,i+2,i+3,1)
    end
    
    add_edge2!(g,8,1,3)
    add_edge2!(g,8,2,2)
    add_edge2!(g,8,3,2)
    add_edge2!(g,8,4,4)
    add_edge2!(g,8,5,6)
    add_edge2!(g,8,6,8)
    add_edge2!(g,8,7,9)

    add_edge2!(g,12,1,5)
    add_edge2!(g,12,2,4)
    add_edge2!(g,12,3,2)
    add_edge2!(g,12,4,2)
    add_edge2!(g,12,5,4)
    add_edge2!(g,12,6,6)
    add_edge2!(g,12,7,7)

    add_edge2!(g,16,1,7)
    add_edge2!(g,16,2,6)
    add_edge2!(g,16,3,4)
    add_edge2!(g,16,4,2)
    add_edge2!(g,16,5,2)
    add_edge2!(g,16,6,4)
    add_edge2!(g,16,7,5)

    add_edge2!(g,20,1,9)
    add_edge2!(g,20,2,8)
    add_edge2!(g,20,3,6)
    add_edge2!(g,20,4,4)
    add_edge2!(g,20,5,2)
    add_edge2!(g,20,6,2)
    add_edge2!(g,20,7,3)


    obs_g = SimpleGraph(23)
    for i=1:6
        add_edge!(obs_g,i,i+1)
    end
    for i=8:2:14
        add_edge!(obs_g,i+(i-8),i/2-2)
        add_edge!(obs_g,i+(i-8),i/2-1)
    end
    for i=8:4:20
        for j=0:2
            add_edge!(obs_g,i+j,i+j+1)
        end
    end
    (g, obs_g)
end
(g, obs_g) = build_graph()
shortests = Dict{UInt8,Vector{UInt16}}([(i,dijkstra_shortest_paths(g, i).dists) for i =1:23])
cost(b) = 10^(b-0x41)
target(b) =  (b-0x41)*4+8
@memoize function h(s)
    c = 0
    for (idx, i) in enumerate(s)
        if i == 0 continue end
        t = target(i)+3
        c += cost(i) * shortests[idx][t]
    end
    c
end
function sols(s)
    s = copy(s)
    s[s.==0] .= '.' 
     s=Char.(s)
     return "#############\n#$(s[1])$(s[2]).$(s[3]).$(s[4]).$(s[5]).$(s[6])$(s[7])#\n###$(s[8])#$(s[10])#$(s[12])#$(s[14])###\n###$(s[9])#$(s[11])#$(s[13])#$(s[15])###\n#############\n"
end
issolution(s)::Bool = s[8] == 0x41 && s[12] == 0x42 && s[16] == 0x43 && s[20] == 0x44 && all(x->x==0x41, s[8:11]) && all(x->x==0x42, s[12:15]) && all(x->x==0x43, s[16:19]) && all(x->x==0x44, s[20:23])
function constructPath(cameFrom, cur)
    l = 0
    while haskey(cameFrom, cur)
        l += 1
        #println(sols(cur))
        cur = cameFrom[cur]
    end
    l
end
function aˣ(start_state)
    openSet = PriorityQueue{Vector{UInt8}, Int}()
    openSet[start_state] = 0
    gScores = DefaultDict{Vector{UInt8}, Int}(typemax(Int))
    gScores[start_state] = 0
    fScores = DefaultDict{Vector{UInt8}, Int}(typemax(Int))
    fScores[start_state] = h(start_state)
    cameFrom = Dict{Vector{UInt8},Vector{UInt8}}()
    while !isempty(openSet)
        s = dequeue!(openSet)
        if issolution(s)
            println("Solution: $(gScores[s])")
            return constructPath(cameFrom, s)
        end
        filled_spots = findall(x->x!=0, s)
        for spotidx in filled_spots
            targetlist = []
            if spotidx <= 7 # In Corridor
                targetlist = [target(s[spotidx])]
            else # In room
                tar = target(s[spotidx])
                if spotidx in tar:(tar+3)  # at correct room
                    if any(x->s[x] != s[spotidx], tar:(tar+3))
                        targetlist = [i for i in 1:7]
                    elseif (spotidx != tar+3) && ((spotidx+1) ∉ filled_spots)
                        targetlist = [spotidx+1]
                    end
                elseif spotidx ∉ tar:(tar+3) # wrong room
                    targetlist = [i for i in 1:7]
                end
            end
            for tidx in targetlist
                if !has_path(obs_g, spotidx, tidx; exclude_vertices=filter(x->x!=spotidx, filled_spots)) continue end
                n = copy(s)
                n[spotidx] = 0
                n[tidx] = s[spotidx]
                tentative_gScore = gScores[s] + cost(s[spotidx]) * shortests[spotidx][tidx]
                if tentative_gScore < gScores[n]
                    cameFrom[n] = s
                    gScores[n] = tentative_gScore
                    fScores[n] = tentative_gScore + h(n)
                    if !haskey(openSet, n)
                        openSet[n] = tentative_gScore + h(n)
                    end
                end
            end
        end
    end
end
target.(Vector{UInt8}(['A','B','C','D']))

start_state = Vector{UInt8}([0,0,0,0,0,0,0,'D','D','D','C','D','C','B','A','B','B','A','B','A','A','C','C'])

aˣ(start_state)

draw(PNG("d23/g.png", 16cm, 16cm), gplot(obs_g))