include("utils.jl")

const HEXDICT = Dict(k => collect(bitstring(i-1)[(end-3):end]) .== '1' for (i,k) in enumerate(vcat('0':'9', 'A':'F')));
const OPDICT = Dict(0 => +, 1 => *, 2 => min, 3 => max, 5 => >, 6 => <, 7 => ==)

version(packet; start=1)      = bin2int(packet[start:(start+2)])
typeID(packet; start=1)       = bin2int(packet[(start+3):(start+5)])
header(packet; start=1)       = (version(packet; start=start), typeID(packet; start=start))
lengthtypeID(packet; start=1) = packet[start+6] # unused
subpacklen(packet; start=1)   = bin2int(packet[(start+7):(start+21)])
subpacknum(packet; start=1)   = bin2int(packet[(start+7):(start+17)])

function evaluate_packet(packet::BitVector; start=1)
    ver, tid = header(packet; start=start) # version & type ID
    
    if tid == 4 # literal
        at = start+6
        lit = BitVector([])
        while true
            group = packet[at:(at+4)]
            append!(lit, group[2:end])
            at += 5
            if !group[1] # last group
                break
            end
        end
        
        return ver, bin2int(lit), at
    else # operation
        totver, subvals = ver, Int[]
        if lengthtypeID(packet; start=start)
            # next 11 bits -> number of subpackets
            at = start+18
            for _ in 1:subpacknum(packet; start=start)
                subver, subval, at = evaluate_packet(packet; start=at)
                totver += subver
                push!(subvals, subval)
            end
        else
            # next 15 bits -> total length in bits
            blen = subpacklen(packet; start=start)
            at = start+22
            while at < blen + (start+21)
                subver, subval, at = evaluate_packet(packet; start=at)
                totver += subver
                push!(subvals, subval)
            end
        end
        
        val = OPDICT[tid](subvals...)
        
        return totver, val, at
    end
end

data = readlines(ARGS[1])

packethex = data[1]
packetbin = vcat([HEXDICT[c] for c in packethex]...);

res = evaluate_packet(packetbin)

println("Answer 1: ", res[1])
println("Answer 2: ", res[2])