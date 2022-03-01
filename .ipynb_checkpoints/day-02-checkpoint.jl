file_path = ARGS[1]

data = [(t[1], parse(Int, t[2])) for t in split.(readlines(file_path))]
position, depth = 0, 0
for (command, X) in data
    global position, depth
    if command == "forward"
        position += X
    elseif command == "down"
        depth += X
    elseif command == "up"
        depth -= X
    end
end

println("Answer 1: ", position * depth)

position, depth, aim = 0, 0, 0
for (command, X) in data
    global position, depth, aim
    if command == "forward"
        position += X
        depth += aim * X
    elseif command == "down"
        aim += X
    elseif command == "up"
        aim -= X
    end
end

println("Answer 2: ", position * depth)