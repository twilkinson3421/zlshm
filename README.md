# zlshm

A simple shared library for reading from shared memory on Windows. Support for Linux is planned in the future.

## Usage

Use the provided `.dll` library, which can be found in the releases seciton.

This library was originally written for use
with Deno's _ffi_ functionality, but can be used with any language that supports loading shared lirbaries.

## Symbols

### `open`

Opens a shared memory file. Returns a windows `HANDLE` to the file.

| Argument | Type   | Description                                                                        |
| -------- | ------ | ---------------------------------------------------------------------------------- |
| name     | string | The name of the shared memory file to open. This must be null-terminated UTF-16LE. |
| log_err  | bool   | Whether to log errors to stderr.                                                   |

### `close`

Closes a shared memory file. Returns the return code of `CloseHandle`.

| Argument | Type     | Description                                      |
| -------- | -------- | ------------------------------------------------ |
| handle   | `HANDLE` | The `HANDLE` of the shared memory file to close. |

### `read`

Reads data from a shared memory file. Returns -1 if `MapViewOfFile` fails,
otherwise the return code of `UnmapViewOfFile`.

| Argument | Type     | Description                                                                         |
| -------- | -------- | ----------------------------------------------------------------------------------- |
| handle   | `HANDLE` | The `HANDLE` of the shared memory file to read from.                                |
| buf      | pointer  | The buffer to read the data into.                                                   |
| len      | usize    | The number of bytes to map. Must be less than or equal to the length of the buffer. |
| log_err  | bool     | Whether to log errors to stderr.                                                    |

## Building

This library is written and built using Zig version _0.14.0-dev.2577+271452d22_ (_2024.11.0-mach_).
Run `zig build` to build the library locally (requires Zig to be installed). If you are not using Windows,
you should add `-Dtarget=x86_64-windows` to the build command (Obviously you will require Windows to use the library).

## License

This library is licensed under the Unlicense (Hooray!). See the `UNLICENSE` file for more information.
