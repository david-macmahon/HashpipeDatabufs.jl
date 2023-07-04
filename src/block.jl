### AbstractBlock

abstract type AbstractBlock end

### GenericBlock

struct GenericBlock <: AbstractBlock
    data::Vector{UInt8}
end

function GenericBlock(p::Ptr{Nothing}, block_size::Int64)
    data = unsafe_wrap(Array, Ptr{UInt8}(p), block_size)
    GenericBlock(data)
end
