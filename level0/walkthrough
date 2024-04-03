## Level 0

level0:level0

```
$ gdb ./level0
```
```
(gdb) set disassembly-flavor intel
(gdb) set pagination off
```
The first argument is converted to int using `atoi()`.  
The returned value is compared with `0x1a7` which is `423` in decimal
```
(gdb) disassemble main
...
0x08048ed1 <+17>:	mov    DWORD PTR [esp],eax
0x08048ed4 <+20>:	call   0x8049710 <atoi>
0x08048ed9 <+25>:	cmp    eax,0x1a7
0x08048ede <+30>:	jne    0x8048f58 <main+152>
...
```
```
$ ./level0 423
$ id
uid=2030(level1) gid=2020(level0) groups=2030(level1),100(users),2020(level0)
$ cat /home/user/level1/.pass
1fe8a524fa4bec01ca4ea2a869af2a02260d4a7d5fe7e7c24d8617e6dca12d3a
```
