import sys

with open(sys.argv[1], "rb") as f:
    infile = bytearray(f.read())

with open(sys.argv[2], "w") as g:
    g.write("v3.0 hex bytes plain little-endian\n")
    for b in infile:
        g.write(f"{b:02X}")
