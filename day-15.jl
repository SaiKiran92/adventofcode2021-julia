import Pkg; Pkg.activate(".")
using DataStructures

fpath = ARGS[1]
risks = parse.(Ref(Int), hcat(map(l -> split(l, ""), readlines(fpath))...))
N = size(risks, 1)

function get_neighbors(i, s) # index, size of the matrix
    rv = Tuple{Int,Int}[]
    if i[1] != 1
        push!(rv, (i[1]-1, i[2]))
    end
    if i[1] != s[1]
        push!(rv, (i[1]+1,i[2]))
    end
    
    if i[2] != 1
        push!(rv, (i[1], i[2]-1))
    end
    if i[2] != s[2]
        push!(rv, (i[1], i[2]+1))
    end
    
    return rv
end

function get_lowest_total_risks(risks)
    N = size(risks, 1)
    lowest_risks = fill(typemax(Int), N, N)

    pq = PriorityQueue((N, N) => 0)
    while !isempty(pq)
        (i,j), r = dequeue_pair!(pq)
        lowest_risks[i,j] = r
        r += risks[i,j]

        neighs = get_neighbors((i,j), (N,N))
        for n in neighs
            t = min(get(pq, n, typemax(Int)), r)
            if lowest_risks[n...] > t
                pq[n] = t
            end
        end
    end
    
    return lowest_risks
end

lrisks = get_lowest_total_risks(risks)
println("Answer 1: ", lrisks[1,1])

risks_expanded = repeat(risks, 5, 5)
for i in 1:N:5N
    for j in 1:N:5N
        risks_expanded[i:(i+N-1),j:(j+N-1)] .+= floor(Int, (i-1)/N) + floor(Int, (j-1)/N)
        # risks_expanded[i:(i+N-1),j:(j+N-1)] .%= 10
        # println("$i\t$j\t$(risks_expanded[i:(i+N-1),j:(j+N-1)])\t$(floor(Int, (i)/N) + floor(Int, j/N))")
    end
end

mask = risks_expanded .> 9
risks_expanded[mask] .-= 9

lrisks2 = get_lowest_total_risks(risks_expanded)
println("Answer 2: ", lrisks2[1,1])