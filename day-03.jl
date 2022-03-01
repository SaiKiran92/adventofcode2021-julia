file_path = ARGS[1]

data = hcat([collect(b) .== '1' for b in readlines(file_path)]...)

get_bit_props(mat::BitMatrix) = sum(mat, dims=2)[:,1] ./ size(mat)[2]
bitvector_to_int(v::BitVector) = sum([b*(2 ^ (i-1)) for (i,b) in enumerate(v[end:-1:1])])

proportions = get_bit_props(data)
gamma_rate = bitvector_to_int(proportions .> 0.5)
epsilon_rate = bitvector_to_int(proportions .< 0.5)

println("Answer 1: ", gamma_rate * epsilon_rate)

oxygen_generator_rating = nothing
cdata = copy(data)
for i in 1:size(data)[1]
    global cdata
    N = size(cdata)[2]
    if N == 1
        break
    end
    p = sum(cdata[i,:])/N
    if p ≥ 0.5
        cdata = cdata[:, cdata[i,:]]
    else
        cdata = cdata[:, .!(cdata[i,:])]
    end
end
oxygen_generator_rating = bitvector_to_int(cdata[:,1])

co2_scrubber_rating = nothing
cdata = copy(data)
for i in 1:size(data)[1]
    global cdata
    N = size(cdata)[2]
    if N == 1
        break
    end
    p = sum(cdata[i,:])/N
    if p ≥ 0.5
        cdata = cdata[:, .!(cdata[i,:])]
    else
        cdata = cdata[:, cdata[i,:]]
    end
end
co2_scrubber_rating = bitvector_to_int(cdata[:,1])

println("Answer 2: ", oxygen_generator_rating * co2_scrubber_rating)