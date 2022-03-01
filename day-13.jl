fpath = ARGS[1]
data = readlines(fpath)

coordinates = Tuple{Int,Int}[]
folds = Tuple{Int,Int}[]

map(data) do l
    m = match(r"(\d+),(\d+)", l)
    if !isnothing(m)
        push!(coordinates, Tuple(parse.(Ref(Int), m.captures)))
    else
        m = match(r"fold along x=(\d+)", l)
        if !isnothing(m)
            push!(folds, (1, parse(Int, m.captures[1])))
        else
            m = match(r"fold along y=(\d+)", l)
            if !isnothing(m)
                push!(folds, (2, parse(Int, m.captures[1])))
            end
        end
    end
end

NX, NY = maximum(c -> c[1], coordinates), maximum(c -> c[2], coordinates)

dots = fill(false, NX+1, NY+1)
for c in coordinates
    dots[c[1]+1,c[2]+1] = true
end

function fold_paper(dots, fold)
    dir, loc = fold
    if dir == 2
        if loc < size(dots, 2)/2
            dots[:,(loc+2):(2loc+1)] .|= dots[:,loc:-1:1]
            dots = dots[:,(loc+2):end]
        else
            dots[:,(end-2*(NY - loc)):loc] .|= dots[:,end:-1:(loc+2)]
            dots = dots[:,1:loc]
        end
    else # dir == 1
        if loc < size(dots, 1)/2
            dots[(loc+2):(2loc+1),:] .|= dots[loc:-1:1,:]
            dots = dots[(loc+2):end,:]
        else
            dots[(end-2*(NX - loc)):loc,:] .|= dots[end:-1:(loc+2),:]
            dots = dots[1:loc,:]
        end
    end
    return dots
end

dots = fold_paper(dots, folds[1])

println("Answer 1: ", sum(dots))

for fold in folds[2:end]
    global dots
    dots = fold_paper(dots, fold)
end

## need to manually check the answer with this code
# x = (dots')[end:-1:1,end:-1:1];
# j = [[from 1 to 8]]
# i = (j-1)*5 + 1
# x[:,i:(i+4)]

println("Answer 2: UEFZCUCJ")