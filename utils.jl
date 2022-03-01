function bin2int(v::AbstractVector{Bool})#Union{AbstractVector{Bool}, BitVector})
    sum([b*2^(i-1) for (i,b) in enumerate(v[end:-1:1])])
end