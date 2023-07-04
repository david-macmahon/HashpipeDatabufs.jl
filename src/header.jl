### Header

"""
Hashpipe databuf header structure.  This is the first thing in every Hashpipe
databuf.
"""
struct Header
    """Type of data in buffer"""
    data_type::NTuple{64, UInt8}

    """Size of each block header (bytes)"""
    header_size::Int64

    """Size of each data block (bytes)"""
    block_size::Int64

    """Number of data blocks in buffer"""
    n_block::Int32

    """ID of this shared mem segment"""
    shmid::Int32

    """ID of locking semaphore set"""
    semid::Int32
end

function Base.show(io::IO, header::Header)
    print(io, "Header")
    print(io, "(data_type=\"")
    print(io, String(UInt8[header.data_type...]))
    print(io, "\", header_size="); print(io, header.header_size)
    print(io, ", block_size=");    print(io, header.block_size)
    print(io, ", n_block=");       print(io, header.n_block)
    print(io, ", shmid=");         print(io, header.shmid)
    print(io, ", semid=");         print(io, header.semid)
    print(io, ")")
end
