fpath = ARGS[1]

init_state = parse.(Ref(Int), hcat(collect.(readlines(fpath))...))

state = copy(init_state)
NX, NY = size(state)
flashed = fill(false, size(state))
total_flashes = 0
for step in 1:100
    global total_flashes
    
    state .+= 1
    flashed .= false
    while true
        S = [ind.I for ind in findall((state .> 9) .& .!flashed)]
        isempty(S) && break
        
        for ind in S
            state[ind...] = 0
            flashed[ind...] = true
            state[max(ind[1]-1,1):min(ind[1]+1,NX), max(ind[2]-1,1):min(ind[2]+1,NY)] .+= 1
        end
    end
    
    state[flashed] .= 0
    total_flashes += sum(flashed)
end

println("Answer 1: ", total_flashes)

state = copy(init_state)
flashed = fill(false, size(state))
step = 0
while true
    global step
    
    step += 1
    state .+= 1
    flashed .= false
    while true
        S = [ind.I for ind in findall((state .> 9) .& .!flashed)]
        isempty(S) && break
        
        for ind in S
            state[ind...] = 0
            flashed[ind...] = true
            state[max(ind[1]-1,1):min(ind[1]+1,NX), max(ind[2]-1,1):min(ind[2]+1,NY)] .+= 1
        end
    end
    
    state[flashed] .= 0
    
    if all(flashed)
        println("Answer 2: ", step)
        break
    end
end