# 01. Your First Program

This chapter presents an assembler program to put `hello, world` on your screen.

## Edit, Assemble, Link, and Run (or Debug)
- NASM (Netwide Assembler) is chosen due to
  - its availablity on Linux, Windows, and macOS
  - a large community
- Example as [codes/hello.asm](./codes/hello.asm), run as
  ```bash
  cd codes
  make hello
  ```
  Sample output (the `bash-5.1#` is the command prompt due to no newline in the printed string) goes as 
  ```bash
  hello, worldbash-5.1# 
  ```
  As can be seen from [codes/hello.asm](./codes/hello.asm)
  - Tabs, spaces, and new lines can be used to make the code more readable.
  - Use one instruction per line.
  - The text following a semicolon is a comment, in other words, an explanation for the benefit of humans. Computers
    happily ignore comments.
- GNU Make
  - A makefile (here is the [manual][gnu-make-manual]) will be used by make to automate the building of our program.
  - Building a program means checking your source code for errors, adding all necessary services from the operation
    system, and converting your code into a sequence of machine-readable instructions.
  - Every time targets/files depended by a target is more recent than the target, `make` will be rebuilding of the
    target.
  - Comments start with `#`.
- Building process: after NASM produces the object file, the file is then linked with a **linker**. A linker takes your
  object code and searches the system for other files that are needed, typically system services or other object files.
  These files are combined with your generated object code by the linker, and an executable file is produced.
  - `gcc` is used to ease accessing C standard library functions from within assembler code. Another popular linker is
    `ld`.

## Structure of an Assembly Program
- main parts of an assembly program:
  - section `.data`
  - section `.bss`
  - section `.text`

### section .data
- Initialized data is declared and defined as:
  - For variables
    ```
    <variable name> <type> <value>
    ```
  - For constants
    ```
    <constant name> equ <value>
    ```
- When a variable is included in section `.data`, memory is allocated for that variable when the source code is
  assembled and linked to an executable.
- Variable names are symbolic names, and references to memory locations and a variable can take one or more memory
  locations. The variable name refers to the start address of the variable in memory.
- Variable names start with a letter, followed by letters or numbers or special characters.
- Possible datatypes

  Type | Length | Name
  ---|----------|----
  `db` | 8  |bits Byte
  `dw` | 16 | bits Word
  `dd` | 32 | bits Double word
  `dq` | 64 | bits Quadword
- A string is a contiguous list of characters.
  - It is a "list" or "arra" of characters in memory.
  - Any contiguous list in memory can be considered a string
    - the characters can be human readable or not 
    - the string can be meaningful to humans or not
- Type `man ascii` at the CLI, Linux will show you an ASCII table.

### section .bss

- A.k.a. **B**lock **S**tarted by **S**ymbol
- This sections declare uninitialized variables as
  ```
  <variable name> <type> <number>
  ```
- Possible `bss` datatypes

  Type | Length | Name
  -----|--------|---------
  resb | 8 bits  | Byte
  resw | 16 bits |  Word
  resd | 32 bits |  Double word
  resq | 64 bits |  Quadword

- The variables in section `.bss` do not contain any values; the values will be assigned later at execution time.
- Memory places are not reserved at compile time but at execution time.
- When your program starts executing, the program asks for the needed memory from the operating system, allocated to
  variables in section `.bss` and initialized to zeros.
- If there is not enough memory available for the `.bss` variables at execution time, the program will crash.

### section .text
- This section store the program codes.
- Our example code goes as
  ```asm
  global main

  main:
  ```
  - The `main:` part is called a label.
    - When you have a label on a line without anything following it, the word is best followed by a colon; otherwise,
      the assembler will send you a warning.
    - When a label is followed by other instructions, there is no need for a colon, but it is best to make it a habit
      to end all labels with a colon. Doing so will increase the readability of your code.
- Instruction `mov` formats
  - `mov register, immediate value`
  - `mov register, memory`
  - `mov memory, register`
  - **illegal**: `mov memory, memory`
- System calls are used to ask the operating system to do specific actions.
- Listing files helpings debug is arranged as

  column index | meaning | description
  -------------|---------|-------------
  0   | line number |
  1   | memory locations | `.bss` section has no memory, assembly stage knows no memory location,
  2   | assembly instruction in hex | e.g. `mov rax` is written as `B8`

  - Variables' memory location is referred to as `[0000000000000000]` in instructions.
- The first-generation programming language is machine language (like `B8`). Assembly language, with its
  "easier to remember" mnemonics, is a second-generation programming language.

[gnu-make-manual]: https://www.gnu.org/software/make/manual/make.html
