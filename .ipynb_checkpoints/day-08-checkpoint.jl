file_path = ARGS[1]

data = map(readlines(file_path)) do l
    digs1, digs2 = split(l, " | ")
    split(digs1, " "), split(digs2, " ")
end

println("Answer 1: ", sum([sum([length(d) in [2, 4, 3, 7] for d in digs[2]]) for digs in data]))

TRUE_DIGITS = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"] # not really used here

function get_digit_dict(x::Vector) # x -- given digits
    digs = Vector{Union{String, Missing}}(fill(missing, 10))

    digs[2] = x[findfirst(s -> length(s) == 2, x)]
    digs[5] = x[findfirst(s -> length(s) == 4, x)]
    digs[8] = x[findfirst(s -> length(s) == 3, x)]
    digs[9] = x[findfirst(s -> length(s) == 7, x)];

    f = first(intersect(digs[2], filter(s -> length(s) == 6, x)...))
    c = first(setdiff(Set(digs[2]), Set([f])))

    digs[3] = x[findfirst(s -> (length(s) == 5) && (c in s) && !(f in s), x)]
    digs[4] = x[findfirst(s -> (length(s) == 5) && (c in s) && (f in s), x)]
    digs[6] = x[findfirst(s -> (length(s) == 5) && !(c in s) && (f in s), x)]

    digs[7] = x[findfirst(s -> (length(s) == 6) && (length(setdiff(s, digs[6])) == 1) && !(c in s), x)]
    digs[10] = x[findfirst(s -> (length(s) == 6) && (setdiff(s, digs[6]) == [c]), x)]
    digs[1] = x[findfirst(s -> (length(s) == 6) && (length(setdiff(s, digs[6])) == 2), x)]
    
    return Dict(String(sort(collect(dig))) => i-1 for (i,dig) in enumerate(digs))
end

res = map(data) do (x, out)
    ddict = get_digit_dict(x)
    sum([ddict[String(sort(collect(d)))] * (10 ^ (4-i)) for (i,d) in enumerate(out)])
end

println("Answer 2: ", sum(res))