include("header.jl")
include("block.jl")

### HashpipeDatabuf

"""
Hashpipe databuf structure.  This is low-level HashpipeDatabuf that just wraps
the Header object at that start of every Hashpipe databuf.
Typical use of HashpipeDatabufs will be through application specific
structs that will include the Header as part of their overall
structure, so use of the application agnostic `HashpipeDatabuf` will be rare.
"""
struct HashpipeDatabuf{B<:AbstractBlock}
    header::Array{Header, 0}
    block::Vector{B}
end

function HashpipeDatabuf{B}(p::Ptr{Nothing}) where {B<:AbstractBlock}
    header = unsafe_wrap(Array, Ptr{Header}(p), ())
    p += header[].header_size
    block_size = header[].block_size
    n = header[].n_block
    block = [B(b, block_size) for b in range(p, step=block_size, length=n)]
    HashpipeDatabuf(header, block)
end

function HashpipeDatabuf(p::Ptr{Nothing})
    HashpipeDatabuf{GenericBlock}(p)
end

function HashpipeDatabuf{B}(
    instance_id::Integer, databuf::Integer;
    keyfile=hashpipe_keyfile(), readonly=true
) where {B<:AbstractBlock}
    p = hashpipe_databuf_ptr(instance_id, databuf; keyfile, readonly)
    HashpipeDatabuf{B}(p)
end

function HashpipeDatabuf(
    instance_id::Integer, databuf::Integer;
    keyfile=hashpipe_keyfile(), readonly=true
)
    HashpipeDatabuf{GenericBlock}(instance_id, databuf; keyfile, readonly)
end

function Base.sizeof(h::HashpipeDatabuf)
    sizeof(h.header)
end

function Base.show(io::IO, hdb::HashpipeDatabuf)
    header = hdb.header[]
    print(io, typeof(hdb))
    print(io, "(\"")
    print(io, String(UInt8[header.data_type...]))
    print(io, "\", hsize="); print(io, header.header_size)
    print(io, ", bsize=");   print(io, header.block_size)
    print(io, ", nblock=");  print(io, header.n_block)
    print(io, ", shmid=");   print(io, header.shmid)
    print(io, ", semid=");   print(io, header.semid)
    print(io, ")")
end
