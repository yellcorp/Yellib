#!/usr/bin/python

import struct
import sys
import math

if len(sys.argv) != 2:
    print "Usage: gen-factorial filename"
    sys.exit(1)

outfile = open(sys.argv[1], 'wb')

i = 0
try:
    while True:
        outfile.write(struct.pack("<d", float(math.factorial(i))))
        i += 1
except OverflowError:
    pass

outfile.close()
