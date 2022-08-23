# 07. Jumping and Looping

`rflags` register is shown as `eflags` in GDB debugging.

| Instruction | Flags                   | Meaning                  | Use              |
| ----------- | ----------------------- | ------------------------ | ---------------- |
| je          | ZF=1                    | Jump if equal            | Signed, unsigned |
| jne         | ZF=0                    | Jump if not equal        | Signed, unsigned |
| jg          | ((SF XOR OF) OR ZF) = 0 | Jump if greater          | Signed           |
| jge         | (SF XOR OF) = 0         | Jump if greater or equal | Signed           |
| jl          | (SF XOR OF) = 1         | Jump if lower            | Signed           |
| jle         | ((SF XOR OF) OR ZF) = 1 | Jump if lower or equal   | Signed           |
| ja          | (CF OR ZF) = 0          | Jump if above            | Unsigned         |
| jae         | CF=0                    | Jump if above or equal   | Unsigned         |
| jb          | CF=1                    | Jump if lesser           | Unsigned         |
| jbe         | (CF OR ZF) = 1          | Jump if lesser or equal  | Unsigned         |
