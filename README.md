# HashpipeDatabufs

Live access to the Hashpipe shared memory buffers.

These Julia structs contain Arrays that are backed by the "live" shared memory
buffers.  Changes to the contents of these buffers by other processes (e.g. an
active `hashpipe` pipeline) is active, will be visible to these Arrays.
Non-array elements are wrapped in a 0-dimensioned Array.

This package provides basic access to Hashpipe data buffers using a `Header`
struct for the header that is at the start of every Hashpipe databuf and a
`GenericBlock` struct for the data blocks that follow.  Application specific
packages (e.g. `HpguppiDatabufs.jl` and `HeraDatabufs.jl`) provide subtypes
of `AbstractBlock` that can be used with `HashpipeDatabuf` for more user
friendly access to the application specific data blcoks.

## Installation

This package is not yet in the General package registry so it must be installed
from GitHub directly. . This can be done using `Pkg` functions or using the
`Pkg`-mode of the Julia REPL.

### Using `Pkg` functions

```julia
using Pkg
Pkg.add("https://github.com/david-macmahon/HashpipeDatabufs.jl")
```

### Using `Pkg`-mode of the Julia REPL

In the Julia REPL, pressing `]` at the start of the line will switch the REPL
to `Pkg`-mode. . The prompe will change from `julia>` to `([env]) pkg>`, where
`[env]` is the name of the currently active environment (e.g. `@v1.9`).

```julia
julia> ]
(@v1.9) pkg> # Prompt changes immediately upon pressing `]`
(@v1.9) pkg> add https://github.com/david-macmahon/HashpipeDatabufs.jl
```

Press backspace at the start of a line to switch back to the normal REPL mode.

## Using HashpipeDatabufs

The `HashpipeDatabuf` structure represents a Hashpipe data buffer.  The type and
its constructors accept a type parameter specifying the `AbstractBlock` subtype
that should be used to wrap the data blocks of the Hashpipe data buffer.  The
most frequently used `HashpipeDatabuf` constructor has this method signature:

```julia
HashpipeDatabuf{B}(
    instance_id::Integer, databuf::Integer;
    keyfile=hashpipe_keyfile(), readonly=true
) where {B<:AbstractBlock}
```

- `B` is the AbstractBlock subtype that will be used to wrap the data blocks.
  If `B` is not given, `GenericBlock` will be used.  `GenericBlock` has a `data`
  field that is a `Vector{UInt8}` wrapping the data block memory.

- `instance_id` is the Hashpipe *instance* number whose data buffer will be
    attached.  On the `hashpipe` command line the instance number is specified
    as an argument to the `-I` option (e.g. `hashpipe -I 2 ...` uses instance
    number 2).

- `databuf_id` is the data buffer index within the Hashpipe pipeline.  The first
  data buffer in the Hashpipe pipline is 1.  There is no 0 data buffer.

- `keyfile` is the name of the "key file" used to generate shared memory IDs.
  The default value uses `hashpipe_keyfile()` to determine which name to use for
  the key file.  The value of `ENV["HASHPIPE_KEYFILE"]` will be used if it is
  defined, otherwise the value of `ENV["HOME"]` will be used if it is defined,
  otherwise `/tmp` will be used.

- `readonly` is a boolean flag indicating whether to attach to the shared memory
  regions for read only.  `HashpipeDatabufs.jl` does not yet have the semaphore
  functionality to know when to safely write into the shared memory buffer, so
  it is recommended to always use the default value of `true`.

## Databuf layouts

The `HashpipeDatabuf` struct has two fields: `header` and `block`.

The `header` field wraps the Hashpipe data buffer header as a 0-dimensional
Array containing a `Header` object.  To access the `Header` object itself, the
`header` field can be indexed using an empty indexing:

```julia
# Create HashpipeDatabuf structure for instance 0, data buffer 1
hdb = HashpipeDatabuf(0, 1)

# Determine the number of blocks in this data buffer
n_block = hdb.header[].n_block
```

The `block` field is a Vector of `AbstractBlock` subtypes.  The very basic
`GenericBlock`, used when no other type is given, represents the data in the
data block as an `Vector{UInt8}`.  Most users will opt to provide a suitable
application specific type.

Here is how to see the first four words of the last data block in the first data
buffer using `GenericBlock`:

```julia
ENV["HASHPIPE_KEYFILE"] = "/home/obs"

hdb = HashpipeDatabuf(0, 1)

hdb.block[end].data[1:4]
4-element Vector{UInt8}:
 0x45
 0x4e
 0x44
 0x20
```
