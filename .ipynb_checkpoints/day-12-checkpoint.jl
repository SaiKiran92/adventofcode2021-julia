fpath = ARGS[1]

data = [split(l, '-') for l in readlines(fpath)]

conns = Dict()
for (x, y) in data
    conns[x] = push!(get(conns, x, []), y)
    conns[y] = push!(get(conns, y, []), x)
end
sizedict = Dict(k => all(islowercase.(collect(k))) ? "small" : "large" for k in keys(conns))

paths = []
S = Set([["start"]])
while !isempty(S)
    p = pop!(S)
    for n in conns[p[end]]
        if (sizedict[n] == "large") || !(n in p)
            nxtp = push!(copy(p), n)
            push!((n == "end") ? paths : S, nxtp)
        end
    end
end
println("Answer 1: ", length(paths))

paths = []
S = Set([Any[["start"], nothing]])
while !isempty(S)
    p, c = pop!(S)
    for n in conns[p[end]]
        if (sizedict[n] == "large") || !(n in p)
            nxtp = push!(copy(p), n)
            if n == "end"
                push!(paths, nxtp)
            else
                push!(S, [nxtp, c])
            end
        elseif (isnothing(c) && (n != "start")) || ((n == c) && (sum(n .== p) == 1))
            nxtp = push!(copy(p), n)
            push!(S, [nxtp, n])
        end
    end
end
println("Answer 2: ", length(paths))