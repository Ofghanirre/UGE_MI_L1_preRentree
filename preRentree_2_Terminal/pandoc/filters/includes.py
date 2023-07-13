#!/usr/bin/env python3

from pandocfilters import toJSONFilter, CodeBlock, Str, get_value
import sys

def includes(key, value, format, meta):
    if key == 'CodeBlock':
        [[ident, classes, kvs], code] = value
        filename, _ = get_value(kvs, "include")
        if filename is not None:
            print(filename, file=sys.stderr)
            with open(filename) as fd:
                code = fd.read()
            return CodeBlock([ident, classes, kvs], code)

if __name__ == "__main__":
    toJSONFilter(includes)
