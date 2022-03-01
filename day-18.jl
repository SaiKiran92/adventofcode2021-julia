OPEN, CLOSE = '[', ']';

mutable struct SnailNumber
    data::Vector
end

function SnailNumber(s::String)
    SnailNumber(map(c -> (c in [OPEN, CLOSE]) ? c : (c-'0'), filter(c -> c != ',', collect(s))))
end

function reduce!(n::SnailNumber)
    reduced = false
    
    while !reduced
        dat, reduced = n.data, true
        
        # check explode
        tracs = cumsum(map(c -> (c == OPEN) ? 1 : (c == CLOSE) ? -1 : 0, dat))
        i = findfirst(t -> t > 4, tracs)
        if !isnothing(i)
            a, b = dat[(i+1):(i+2)]
            ii = findlast(c -> c isa Int, dat[1:i])
            if !isnothing(ii)
                dat[ii] += a
            end
            jj = findfirst(c -> c isa Int, dat[(i+4):end])
            if !isnothing(jj)
                dat[jj + i+3] += b
            end
            n.data = vcat(dat[1:(i-1)], 0, dat[(i+4):end])
            reduced = false
        else # check split
            digs = map(c -> (c isa Int) && (c > 9), dat)
            i = findfirst(digs)
            if !isnothing(i)
                a = floor(Int, dat[i]/2)
                n.data = vcat(dat[1:(i-1)], [OPEN, a, dat[i]-a, CLOSE], dat[(i+1):end])
                reduced = false
            end
        end
    end
    
    return n
end

magnitude(n::SnailNumber) = magnitude(n.data)
function magnitude(v::Vector)
    if length(v) == 1
        return v[1]
    end
    
    tracs = cumsum(map(c -> (c == OPEN) ? 1 : (c == CLOSE) ? -1 : 0, v))
    i = findfirst(t -> t == 1, tracs[2:(end-1)])
    return 3 * magnitude(v[2:(i+1)]) + 2 * magnitude(v[(i+2):(end-1)])
end

Base.:+(n1::SnailNumber, n2::SnailNumber) = SnailNumber(vcat(OPEN, n1.data, n2.data, CLOSE))
Base.:+(n1::SnailNumber, n2::Int) = SnailNumber(vcat(OPEN, n1.data, n2, CLOSE))
Base.:+(n1::Int, n2::SnailNumber) = SnailNumber(vcat(OPEN, n1, n2.data, CLOSE))

data = readlines("./data/day-18.txt")
nums = SnailNumber.(data);

n = deepcopy(nums[1])
for n2 in nums[2:end]
    n += n2
    reduce!(n)
end

println("Answer 1: ", magnitude(n))

ans2 = typemin(Int)
for i in 1:length(nums)
    for j in 1:length(nums)
        if i != j
            mag = magnitude(reduce!(nums[i] + nums[j]))
            if mag > ans2
                ans2 = mag
            end
        end
    end
end

println("Answer 2: ", ans2)