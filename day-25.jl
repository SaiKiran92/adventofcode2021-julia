data = readlines("./data/day-25.txt")

cucumber_map = permutedims(cat(collect.(data)..., dims=2), [2,1])

const EAST, DOWN, EMPTY = '>', 'v', '.'
M,N = size(cucumber_map)

step, nmoves = 0, 1
while nmoves != 0
    nmoves = 0
    
    new_cu_map = fill(EMPTY, (M,N))
    for i in 1:M
        for j in 1:N
            c = cucumber_map[i,j]
            if c == EAST
                jj = (cucumber_map[i,(j%N)+1] == EMPTY) ? (j%N)+1 : j
                new_cu_map[i,jj] = EAST
                nmoves += (j != jj)
            elseif c == DOWN
                new_cu_map[i,j] = DOWN
            end
        end
    end
    cucumber_map = new_cu_map
    
    new_cu_map = fill(EMPTY, (M,N))
    for i in 1:M
        for j in 1:N
            c = cucumber_map[i,j]
            if c == DOWN
                ii = (cucumber_map[(i%M)+1,j] == EMPTY) ? (i%M)+1 : i
                new_cu_map[ii,j] = DOWN
                nmoves += (i != ii)
            elseif c == EAST
                new_cu_map[i,j] = EAST
            end
        end
    end
    cucumber_map = new_cu_map
    
    step += 1
end

println("Answer 1: ", step)