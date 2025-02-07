# zlshm

A simple shared library for reading from shared memory on Windows. Support for Linux is planned in the future.

## Usage

Use the provided `.dll` library, which can be found in the releases seciton.

This library was originally written for use
with Deno's _ffi_ functionality, but can be used with any language that supports loading shared lirbaries.

## Symbols

The library exports a single function, `read`, which takes three arguments:

1. A UTF-8 encoded string containing the path/name/key of the shared memory file.

2. A pointer to a buffer to read the data into.

3. The number of bytes to read. This must be less than or equal to the length of the read-buffer.

## Building

This library is written and built using Zig version _0.14.0-dev.2577+271452d22_ (_2024.11.0-mach_).
Run `zig build` to build the library locally (requires Zig to be installed). If you are not using Windows,
you should add `-Dtarget=x86_64-windows` to the build command (Obviously you will require Windows to use the library).

## License

This library is licensed under the Unlicense (Hooray!). See the `UNLICENSE` file for more information.
