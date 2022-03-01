file_path = ARGS[1]

data = readlines(file_path)
open2close = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')
close2open = Dict(v => k for (k,v) in pairs(open2close))

scoredict = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)

ans1 = 0
for l in data
    trac = Char[]
    for c in l
        global ans1
        if c in keys(open2close) #['(', '[', '{', '<']
            push!(trac, c)
        else
            if trac[end] == close2open[c]
                pop!(trac)
            else
                ans1 += scoredict[c]
                break
            end
        end
    end
end

println("Answer 1: ", ans1)

scoredict2 = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)

res2 = map(data) do l
    trac = Char[]
    corrupted = false
    for c in l
        if c in keys(open2close)
            push!(trac, c)
        else
            if trac[end] == close2open[c]
                pop!(trac)
            else
                corrupted = true
                break
            end
        end
    end
    
    ans = nothing
    if !corrupted
        ans = 0
        for c in trac[end:-1:1]
            ans *= 5
            ans += scoredict2[open2close[c]]
        end
    end
    ans
end
res2 = res2[.!isnothing.(res2)]
sort!(res2)

println("Answer 2: ", res2[ceil(Int, length(res2)/2)])