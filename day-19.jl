# fpath = "data/tmp.txt" #"data/day-19.txt"
fpath = "data/day-19.txt"
lines = readlines(fpath)

# data = Vector{NTuple{3,Int}}[]
data = Vector{Vector{Int}}[]
for l in lines
	if !isnothing(match(r"--- scanner", l))
		push!(data, [])
		continue
	end

	m = match(r"(-?\d+),(-?\d+),(-?\d+)", l)
	isnothing(m) && continue
	# push!(data[end], Tuple(parse.(Ref(Int),m.captures)))
	push!(data[end], parse.(Ref(Int),m.captures))
end

tmp = [1 0 0; 0 1 0; 0 0 1]
tmp1 = [tmp[[1,2,3],:], tmp[[2,3,1],:], tmp[[3,1,2],:]]
tmp2 = [[(b == '1') ? -1 : 1 for b in bitstring(i)[(end-2):end]] for i in 0:7]
const TMATS = vec([a .* b for a in tmp1, b in tmp2]) # transformer matrices

function transform_data(data, i)
	M = TMATS[i]
	return [M * d for d in data]
end

function check_positions(data1, data2)
	rv = []
	for t in 1:24
		tdata2 = transform_data(data2, t)
		for i in 1:length(data1), j in 1:length(data2)
			d =  data1[i] .- tdata2[j]
			tmp = [td .+ d for td in tdata2]
			S = intersect(tmp, data1)

			if length(S) ≥ 12
				push!(rv, (t, S))
				break
			end
		end
	end

	return rv
end

results = [(i ≥ j) ? [] : check_positions(data[i], data[j]) for i in 1:length(data), j in 1:length(data)];