# HashpipeDatabufs

Live access to the Hashpipe shared memory buffers.

These Julia structs contain Arrays that are backed by the "live" shared memory
buffers.  Changes to the contents of these buffers by other processes (e.g. an
active `hashpipe` pipeline) is active, will be visible to these Arrays.
Non-array elements are wrapped in a 0-dimensioned Array.

This package provides basic access to the Hashpipe databuf header object that is
at the start of every Hashpipe databuf.  Access to the application specific
portions of the Hashpipe databuf is provided by other application specific
packages (e.g. `HpguppiDatabufs.jl` and `HeraDatabufs.jl`).

## Installation

Both this package and [`InterProcessCommunication.jl`](
https://github.com/emmt/InterProcessCommunication.jl.git) are not (yet?) in the
General package registry so the must be installed from GitHub directly. . This
can be done using `Pkg` functions or using the `Pkg`-mode of the Julia REPL.

### Using `Pkg` functions

```
using Pkg
Pkg.add("https://github.com/emmt/InterProcessCommunication.jl")
Pkg.add("https://github.com/david-macmahon/HashpipeDatabufs.jl")
```

### Using `Pkg`-mode of the Julia REPL

In the Julia REPL, pressing `]` at the start of the line will switch the REPL
to `Pkg`-mode. . The prompe will change from `julia>` to `([env]) pkg>`, where
`[env]` is the name of the currently active environment (e.g. `@v1.9`).

```
julia> ]
(@v1.9) pkg> # Prompt changes immediately upon pressing `]`
(@v1.9) pkg> add https://github.com/emmt/InterProcessCommunication.jl
(@v1.9) pkg> add https://github.com/david-macmahon/HashpipeDatabufs.jl
```

Press backspace at the start of a line to switch back to the normal REPL mode.

## Using HashpipeDatabufs

TODO

## Databuf layouts

TODO
