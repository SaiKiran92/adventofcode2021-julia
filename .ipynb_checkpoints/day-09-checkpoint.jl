file_path = ARGS[1]

data = hcat(map(l -> parse.(Ref(Int), collect(l)), readlines(file_path))...)'

low_points = fill(true, size(data)...)
NX, NY = size(data)
for dir in [:up, :down, :left, :right]
    if dir == :up
        low_points[2:end,:] .&= (data[2:end,:] .< data[1:(end-1),:])
    elseif dir == :down
        low_points[1:(end-1),:] .&= (data[1:(end-1),:] .< data[2:end,:])
    elseif dir == :left
        low_points[:,2:end] .&= (data[:,2:end] .< data[:,1:(end-1)])
    else # dir == :right
        low_points[:,1:(end-1)] .&= (data[:,1:(end-1)] .< data[:,2:end])
    end
end

println("Answer 1: ", sum(data[low_points] .+ 1))

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

basin_count, SZ = 0, size(data)
basins = fill(0, size(data)...)
for ind in findall(low_points)
    global basin_count
    if basins[ind] == 0
        basin_count += 1
        S = Set([ind.I])
        while !isempty(S)
            i = pop!(S)
            basins[i...] = basin_count
            for n in get_neighbors(i, SZ)
                if (basins[n...] == 0) && (data[n...] != 9)
                    push!(S, n)
                end
            end
        end
    end
end

nbasins = maximum(basins)
basin_sizes = [sum(basins .== b) for b in 1:nbasins]
println("Answer 2: ", prod(sort(basin_sizes)[(end-2):end]))