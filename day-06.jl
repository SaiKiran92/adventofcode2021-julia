file_path = ARGS[1]

state = parse.(Ref(Int), split(readline(file_path), ','))

function get_spawn_size_matrix(ndays, maxage)
    mat = zeros(Int, ndays+1, maxage+1)
    mat[1,:] .= 1

    for day in 2:size(mat)[1]
        mat[day,1] = mat[day-1,7] + mat[day-1,9]
        mat[day,2:end] .= mat[day-1, 1:(end-1)]
    end

    return mat[end,:]
end

mat1 = get_spawn_size_matrix(18, 8)
println("Answer 1: ", sum(mat1[state .+ 1])) # +1 due to the indexing

mat2 = get_spawn_size_matrix(256, 8)
println("Answer 2: ", sum(mat2[state .+ 1])) # +1 due to the indexing