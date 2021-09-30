# libxlsxwriter

Bindings to the [libxlsxwriter](https://github.com/jmcnamara/libxlsxwriter) C library ([official site](https://libxlsxwriter.github.io)).

From the limited information available, the C library seems to be the fastest open-source library for writing XLSX files supporting constant memory streaming. These bindings will be useful to learn about the performance characteristics of the streaming xlsx writer written in pure Haskell at [xlsx](https://github.com/SupercedeTech/xlsx). In particular, this will help decide on the next steps to improve that library's performance (whether that's using this library there, using this library alone, or continuing to improve the pure Haskell version alone)

# Development

The bindings use [c2hs](https://github.com/haskell/c2hs). Run `nix-shell` to get a shell with required dependencies. Running `cabal v2-build` will automatically call `c2hs` appropriately to convert the `.chs` files in this repo.
