file_path = ARGS[1]

data = parse.(Ref(Int), readlines(file_path));
println("Answer 1: ", sum(data[1:(end-1)] .< data[2:end]))

slide_size = 3
sliding_data = sum([data[i:(end - slide_size + i)] for i in 1:slide_size]);
println("Answer 2: ", sum(sliding_data[1:(end-1)] .< sliding_data[2:end]))