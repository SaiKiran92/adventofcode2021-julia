file_path = ARGS[1] #"data/day-17.txt"
data = readline(file_path)

m = match(r"target area: x=(\d+)..(\d+), y=(-\d+)..(-\d+)", data)
const xa, xb, ya, yb = parse.(Ref(Int), m.captures) # x-values > 0; y-values < 0 - always.

tmin, tmax = 1, -2ya # tmax - from formulas

xmin, xmax = ceil(Int, xa/tmax), floor(Int, xb/tmin)
ymin, ymax = ceil(Int, ya/tmin), floor(Int, 0.5 * (tmax-1))

S = (xmax - xmin + 1), (ymax - ymin + 1)

function check_velocity(x0, y0)
	x, y = x0, y0
	px, py = 0, 0
	v, b = 0, false
	while (px ≤ xb) && (py ≥ ya)
		px += x
		py += y

		v = max(v, py)
		b |= (xa ≤ px ≤ xb) && (ya ≤ py ≤ yb)

		x = max(0, x-1)
		y -= 1
	end

	return v, b
end

tmp = [check_velocity(x0, y0) for x0 in xmin:xmax, y0 in ymin:ymax]

println("Answer 1: ", maximum([ti[1] for ti in tmp]))
println("Answer 2: ", sum([ti[2] for ti in tmp]))