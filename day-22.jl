fpath = "data/day-22.txt"

const cuboid_rx = r"(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)"

struct Cuboid
	bounds
	states

	function Cuboid(bounds, istate=false)
		states = zeros(Bool, [b[2]-b[1]+1 for b in bounds]...)
		states .= istate
		new(bounds, states)
	end
end

function Base.intersect(c1, c2)
	rv = [(max(n1[1],n2[1]), min(n1[2], n2[2])) for (n1, n2) in zip(c1, c2)]
	if any([n[2] < n[1] for n in rv])
		return nothing
	end
	return rv
end

function Base.setindex!(c::Cuboid, s, x, y, z)
	v = (s == "on")
	cinter = intersect(c.bounds, (x, y, z)) # cuboid intersection
	if !isnothing(cinter)
		c.states[[(cx[1] - bx[1] + 1):(cx[2] - bx[1] + 1) for (cx, bx) in zip(cinter, c.bounds)]...] .= v
	end
end

function parse_cuboid(s::S) where {S <: AbstractString}
	m = match(cuboid_rx, s)
	v = parse.(Ref(Int), m.captures[2:end])
	x, y, z = v[1:2], v[3:4], v[5:6]
	return (x=x, y=y, z=z, state=m.captures[1])
end

big_cuboid = Cuboid(((-50, 50), (-50, 50), (-50, 50)))

for line in readlines(fpath)
	c = parse_cuboid(line)
	big_cuboid[c.x, c.y, c.z] = c.state
end

println("Answer 1: ", sum(big_cuboid.states))

on_cuboids, off_cuboids = [], []
for line in readlines(fpath)
	c = parse_cuboid(line)
	if c.state == "on"
		push!(on_cuboids, (x=c.x, y=c.y, z=c.z))
	else
		push!(off_cuboids, (x=c.x, y=c.y, z=c.z))
	end
end

cuboids = [Cuboid((c.x, c.y, c.z), true) for c in on_cuboids]

for oc in on_cuboids
	c1 = Cuboid((oc.x, oc.y, oc.z), true)
end
