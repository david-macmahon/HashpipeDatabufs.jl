# semctl.jl
#
# Convenience functions for working with HashpipeDatabufs and the `semctl`
# system call.

function get_block_states!(h::Header, states::Vector{UInt16})
    @assert length(states) >= h.n_block "states vector is too short"
    rc = @ccall semctl(
        h.semid::Cint, 0::Cint, IPC.GETALL::Cint, states::Ptr{Cushort}
    )::Cint
    systemerror("semctl", rc != 0)
    states
end

function get_block_states(h::Header)
    get_block_states!(h, Vector{UInt16}(undef, h.n_block))
end

function get_block_states!(hdb::HashpipeDatabuf, states::Vector{UInt16})
    get_block_states!(hdb.header[], states)
end

function get_block_states(hdb::HashpipeDatabuf)
    h = hdb.header[]
    get_block_states!(h, Vector{UInt16}(undef, h.n_block))
end

function states_to_bitmask(states::Vector{UInt16})
    reduce((m,(i,f))->m|=((f!=0)<<(i-1)), enumerate(states), init=UInt64(0))
end

function monitor_block_states(h::Header, n=100, dt=0.01)
    pad = h.n_block
    prev = Vector{UInt16}(undef, h.n_block)
    curr = get_block_states(h)
    t0 = time()
    times = []
    states = []
    for i in 1:n
        sleep(dt)
        curr, prev = get_block_states!(h, prev), curr
        if curr != prev
            #bitmask = mapreduce(s->(s==0 ? '0' : '1'), *, a)
            push!(times, time()-t0)
            push!(states, copy(curr))
        end
    end
    times, reduce(hcat, states, init=Matrix{UInt16}(undef, h.n_block, 0))
end

function monitor_block_states(hdb::HashpipeDatabuf, n=100, dt=0.01)
    monitor_block_states(hdb.header[], n, dt)
end
