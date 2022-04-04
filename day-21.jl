import Pkg; Pkg.activate(".")

using AxisArrays

struct Position
	i::Int
end

function Base.:+(p::Position, i::Integer)
	j = p.i + i
	if j > 10
		j -= 10
	end
	return Position(j)
end

struct Score
	i::Int
end

Base.:+(s::Score, p::Position) = Score(s.i + p.i)

struct Turn
	i::Int
end

struct GameState
	positions::Tuple{Int,Int}
	scores::Tuple{Int,Int}
	turn::Int
end

getposition(state::GameState, player::Integer) = state.positions[player]
getscore(state::GameState, player::Integer) = state.scores[player]
getturn(state::GameState) = state.turn

const NTURNS, NPOSITIONS, MAXSCORE = 2, 10, 21

const scoredict = begin
	tmp = sum.(Iterators.product(1:3, 1:3, 1:3))
	Dict(i => sum(tmp .== i) for i in 3:9) # min score for (1,1,1) & max score for (3,3,3)
end

wins_array1 = AxisArray(
				zeros(Int, NPOSITIONS, MAXSCORE, NPOSITIONS, MAXSCORE, NTURNS);
				position1=Position.(1:10),
				score1=Score.(0:20),
				position2=Position.(1:10),
				score2=Score.(0:20),
				turn=Turn.([1,2])
			  );
wins_array2 = copy(wins_array1);

# computations are all done in the right order of the indices.
for s1 in Score.(20:-1:0), s2 in Score.(20:-1:0)
	for t in Turn.([2, 1])
		for p1 in Position.(1:10), p2 in Position.(1:10)
			for (k,v) in pairs(scoredict)
				if t == Turn(1)
					newp1 = p1 + k
					news1 = s1 + newp1

					wins_array1[p1, s1, p2, s2, t] += v * ((news1.i ≥ 21) ? 1 : wins_array1[newp1, news1, p2, s2, Turn(2)])
					wins_array2[p1, s1, p2, s2, t] += v * ((news1.i ≥ 21) ? 0 : wins_array2[newp1, news1, p2, s2, Turn(2)])
				else # t == Turn(2)
					newp2 = p2 + k
					news2 = s2 + newp2

					wins_array2[p1, s1, p2, s2, t] += v * ((news2.i ≥ 21) ? 1 : wins_array2[p1, s1, newp2, news2, Turn(1)])
					wins_array1[p1, s1, p2, s2, t] += v * ((news2.i ≥ 21) ? 0 : wins_array1[p1, s1, newp2, news2, Turn(1)])
				end
			end
		end
	end
end

inds = [Position(6), Score(0), Position(3), Score(0), Turn(1)]
println("Answer 2: ", max(wins_array1[inds...], wins_array2[inds...]))