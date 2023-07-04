function hashpipe_keyfile()
    haskey(ENV, "HASHPIPE_KEYFILE") ? ENV["HASHPIPE_KEYFILE"] :
    haskey(ENV, "HOME") ? ENV["HOME"] : "/tmp"
end

function hashpipe_databuf_key(instance_id, databuf; keyfile=hashpipe_keyfile())
    if haskey(ENV, "HASHPIPE_DATABUF_KEY")
        return IPC.Key(parse(Int32, ENV["HASHPIPE_DATABUF_KEY"]))
    end
    basekey = IPC.Key(keyfile, (instance_id & 0x3f) | 0x80)
    IPC.Key(basekey.value + databuf - 1)
end

function hashpipe_databuf_ptr(instance_id::Integer, databuf::Integer;
                              keyfile=hashpipe_keyfile(), readonly=true)
    key = hashpipe_databuf_key(instance_id, databuf; keyfile)
    shmat(ShmId(key), readonly)
end
