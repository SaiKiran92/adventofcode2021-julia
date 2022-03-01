file_path = ARGS[1]

struct BingoBoard
    board::Matrix{Int}
    found::BitMatrix
end

function BingoBoard(mat::Matrix{Int})
    BingoBoard(mat, Bool.(zero(mat)))
end

function update!(b::BingoBoard, n::Int)
    b.found .|= (b.board .== n)
end

function check(b::BingoBoard)
    tmp = sum(b.found, dims=2)[:,1]
    r = findfirst(tmp .== 5)
    if !isnothing(r)
        return (1, r)
    end
    
    tmp = sum(b.found, dims=1)[1,:]
    c = findfirst(tmp .== 5)
    if !isnothing(c)
        return (2, c)
    end
    
    return nothing
end

data = split(readchomp(file_path), "\n\n")

numbers = parse.(Ref(Int), split(data[1], ','))
boards = map(data[2:end]) do s
    mat = collect(hcat([[parse(Int, m.match) for m in eachmatch(r"[0-9]+", s)] for s in split(s, '\n')]...)')
    BingoBoard(mat)
end

for n in numbers
    update!.(boards, n)
    r = check.(boards)
    if !all(isnothing.(r))
        i = findfirst(!isnothing, r)
        println("Answer 1: ", sum(boards[i].board .* .!(boards[i].found)) * n)
        break
    end
end

won = fill(false, length(boards))
for n in numbers
    update!.(boards, n)
    r = check.(boards)
    
    v = 0
    for i in 1:length(boards)
        if !won[i] && !isnothing(r[i])
            v = sum(boards[i].board .* .!(boards[i].found)) * n
            won[i] = true
        end
    end
    
    if all(won)
        println("Answer 2: ", v)
        break
    end
end