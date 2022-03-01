file_path = ARGS[1]

data = [[parse.(Ref(Int), split(s, ',')) for s in split(l, " -> ")] for l in readlines(file_path)]
N = maximum(maximum.(maximum.(data)))+1

function get_vent_points(a, b; allow_diagonal=false)
    if a[1] == b[1]
        x = a[1]
        i, j = minmax(a[2], b[2])
        return [(x+1, y+1) for y in i:j] # +1 - due to indexing from 1
    elseif a[2] == b[2]
        y = a[2]
        i, j = minmax(a[1], b[1])
        return [(x+1, y+1) for x in i:j] # +1 - due to indexing from 1
    else # only diagonal possible
        if allow_diagonal
            xstep = (a[1] > b[1]) ? -1 : 1
            ystep = (a[2] > b[2]) ? -1 : 1
            return [(x+1, y+1) for (x, y) in zip(a[1]:xstep:b[1], a[2]:ystep:b[2])] # +1 - due to indexing from 1
        end
        
        return []
    end
end

vents = zeros(Int, N, N)
for l in data
    for p in get_vent_points(l...)
        vents[p...] += 1
    end
end

println("Answer 1: ", sum(vents .>= 2))

vents = zeros(Int, N, N)
for l in data
    for p in get_vent_points(l...; allow_diagonal=true)
        vents[p...] += 1
    end
end

println("Answer 2: ", sum(vents .>= 2))