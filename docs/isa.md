# Opcode

| Opcode | Instruction | Bits 11–8 | Bits 7-4 | Bits 3-0 | Operation |
|--------|-------------|-----------|----------|-----------|-----------|
| `0000` | NOP         | unused    |    unused|   unused   | do nothing|
| `0001` | LDI        | Rd        | imm8[7:4] | imm8[3:0] | Rd = imm8 |
| `0010` | STORE       | Rs        | addr8[7:4]| addr8[3:0]| RAM[addr8] = Rs |
| `0011` | MOV         | Rd        | Rs        | Unused    | Rd = Rs |
| `0100` | ADD         | Rd        | Rs1        | Rs2    | Rd = Rs1 + Rs2 |
| `0101` | SUB         | Rd        | Rs1        | Rs2     | Rd = Rs1 - Rs2 |
| `0110` | MUL         | Rd        | Rs1        | Rs2     | Rd = Rs1 * Rs2  |
| `0111` | MAC         | Rd        | Rs1        | Rs2     | Rd = Rd + (Rs1 * Rs2) |
| `1000` | AND         | Rd        | Rs1        | Rs2     | Rd = Rs1 AND Rs2|
| `1001` | OR          | Rd        | Rs1        | Rs2     | Rd = Rs1 OR Rs2|
| `1010` | XOR         | Rd        | Rs1        | Rs2     | Rd = Rs1 XOR Rs2|
| `1011` | JMP         | unused        | imm8[7:4]  |imm8[3:0]| PC = imm8      |
| `1100` | BEQ         | imm4      | Rs1        | Rs2      | Rs1 == Rs2 : PC = imm4|
| `1101` | BNE         | imm4      | Rs1        | Rs2      | Rs1 != Rs2 : PC = imm4|
| `1110` | LOAD        | Rs    | addr[7:4]     | addr[3:0]   | Rd = RAM[addr8]      |
| `1111` | HALT        | unused    | unused     | unused   | stopping execution       |

# Architecture rules

Instruction Width: 16 bits
Register Count: 16
Register width: 8 bits
Program Counter width: 8 bits
Memory address width: 8 bits

## Arithmetic
    opcode | Rd | Rs1 | Rs2
## Immediate
    opcode | Rd | imm8
## Memory
    opcode | Rs/Rd | addr8
## Branch
    opcode | target4 | Rs1 | Rs2