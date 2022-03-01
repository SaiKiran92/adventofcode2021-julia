file_path = ARGS[1]

positions = parse.(Ref(Int), split(readline("./data/day-07.txt"), ','))
Nmin, Nmax = minimum(positions), maximum(positions)

fuels = map(Nmin:Nmax) do p
    sum(abs.(positions .- p))
end

println("Answer 1: ", minimum(fuels))

fuels2 = map(Nmin:Nmax) do p
    sum([Int(0.5 * f * (f+1)) for f in abs.(positions .- p)])
end
println("Answer 2: ", minimum(fuels2))