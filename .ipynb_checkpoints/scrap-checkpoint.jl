
# function get_version_sum(packet::BitVector; start=1)
#     (start > length(packet)) && return 0
    
#     v, t = version(packet; start=start), typeID(packet; start=start)
#     if t == 4 # literal packet
#         at = start+6
#         lastgroup = false
#         while !lastgroup
#             if !packet[at]
#                 lastgroup = true
#             end
#             at += 5
#         end
#         return v, at
#     else # operation packet
#         at = -1
#         if lengthtypeID(packet; start=start) # length type ID
#             # next 11 bits -> number of subpackets
#             nsubpacks = subpacknum(packet; start=start)
#             at = start+18
#             for _ in 1:nsubpacks
#                 subv, at = get_version_sum(packet; start=at)
#                 v += subv
#             end
#         else
#             # next 15 bits -> total length in bits
#             blen = subpacklen(packet; start=start)
#             at = start+22
#             while at < start + 21 + blen
#                 subv, at = get_version_sum(packet; start=at)
#                 v += subv
#             end
#         end
#         return v, at
#     end
# end