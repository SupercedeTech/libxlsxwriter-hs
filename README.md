# libxlsxwriter-hs

Haskell bindings to the [libxlsxwriter](https://github.com/jmcnamara/libxlsxwriter) C library ([official site](https://libxlsxwriter.github.io)).

## Performance

From the limited information available, the C library seems to be the fastest open-source library for writing XLSX files in memory-constant way.

These bindings were developed with an eye to learning about the performance characteristics of the streaming xlsx writer written in pure Haskell at [xlsx](https://github.com/SupercedeTech/xlsx). Proper comparisons could not be made, but it became clear that this library is significantly faster. In the future, this library could be used as an internal detail for the other library.

## Development

The bindings use [c2hs](https://github.com/haskell/c2hs). Run `nix-shell` to get a shell with required dependencies. Running `cabal v2-build` will automatically call `c2hs` appropriately to convert the `.chs` files in this repo.
