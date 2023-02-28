# file.asm

.intel_syntax noprefix

    .data
                            # expressions used for conditional assembly
CREATE            = 1
OVERWRITE         = 1
APPEND            = 1
O_WRITE           = 1
READ              = 1
O_READ            = 1
DELETE            = 1
                            # syscall symbols
NR_read           = 0
NR_write          = 1
NR_open           = 2
NR_close          = 3
NR_lseek          = 8
NR_create         = 85
NR_unlink         = 87
                                # creation and status flags
O_CREAT           = 000000100
O_APPEND          = 000002000
                                # access mode
O_RDONLY          = 0000000
O_WRONLY          = 0000001
O_RDWR            = 0000002
                                # create mode (permissions)
S_IRUSR           = 000400      # user read permission
S_IWUSR           = 000200      # user write permission
NL                = 0xa
bufferlen         = 64
fileName:          .asciz "testfile.txt"
FD:                .quad   0                          # file descriptor
text1:             .asciz "1. Hello...to everyone!\n"
len1              = . - text1 - 1                     # remove 0
text2:             .asciz "2. Here I am!\n"
len2              = . - text2 - 1                     # remove 0
text3:             .asciz "3. Alife and kicking!\n"
len3              = . - text3 - 1 # remove 0
text4:             .asciz "Adios !!!"
len4              = . - text4 - 1
error_Create:      .asciz "error creating file\n"
error_Close:       .asciz "error closing file\n"
error_Write:       .asciz "error writing to file\n"
error_Open:        .asciz "error opening file\n"
error_Append:      .asciz "error appending to file\n"
error_Delete:      .asciz "error deleting file\n"
error_Read:        .asciz "error reading file\n"
error_Print:       .asciz "error printing string\n"
error_Position:    .asciz "error positioning in file\n"
success_Create:    .asciz "File created and opened\n"
success_Close:     .asciz "File closed\n\n"
success_Write:     .asciz "Written to file\n"
success_Open:      .asciz "File opened for R/W\n"
success_Append:    .asciz "File opened for appending\n"
success_Delete:    .asciz "File deleted\n"
success_Read:      .asciz "Reading file\n"
success_Position:  .asciz "Positioned in file\n"


  .bss
  .lcomm buffer, bufferlen


  .text


  .global main
main:
  push rbp
  mov rbp, rsp
  .if CREATE
  # CREATE AND OPEN A FILE, THEN CLOSE --------------------
  # create and open file
  mov rdi, offset fileName
  call createFile
  mov FD, rax # save descriptor
  # write to file #1
  mov rdi, FD
  mov rsi, offset text1
  mov rdx, len1
  call writeFile
  # close file
  mov rdi, FD
  call closeFile
  .endif
  .if OVERWRITE
  # OPEN AND OVERWRITE A FILE, THEN CLOSE -----------------
  # open file
  mov rdi, offset fileName
  call openFile
  mov FD, rax # save file descriptor
  # write to file #2 OVERWRITE!
  mov rdi, FD
  mov rsi, offset text2
  mov rdx, len2
  call writeFile
  # close file
  mov rdi, FD
  call closeFile
  .endif
  .if APPEND
  # OPEN AND APPEND TO A FILE, THEN CLOSE ----------------
  # open file to append
  mov rdi, offset fileName
  call appendFile
  mov FD, rax # save file descriptor
  # write to file #3 APPEND!
  mov rdi, FD
  mov rsi, offset text3
  mov rdx, len3
  call writeFile
  # close file
  mov rdi, FD
  call closeFile
  .endif
  .if O_WRITE
  # OPEN AND OVERWRITE AT AN OFFSET IN A FILE, THEN CLOSE ----
  # open file to write
  mov rdi, offset fileName
  call openFile
  mov FD, rax # save file descriptor
  # position file at offset
  mov rdi, FD
  mov rsi, len2 # offset at this location
  mov rdx, 0
  call positionFile
  # write to file at offset
  mov rdi, FD
  mov rsi, offset text4
  mov rdx, len4
  call writeFile
  # close file
  mov rdi, FD
  call closeFile
  .endif
  .if READ
  # OPEN AND READ FROM A FILE, THEN CLOSE ----------------
  # open file to read
  mov rdi, offset fileName
  call openFile
  mov FD, rax # save file descriptor
  # read from file
  mov rdi, FD
  mov rsi, offset buffer
  mov rdx, bufferlen
  call readFile
  mov rdi, rax
  call printString
  # close file
  mov rdi, FD
  call closeFile
  .endif
  .if O_READ
  # OPEN AND READ AT AN OFFSET FROM A FILE, THEN CLOSE -----
  # open file to read
  mov rdi, offset fileName
  call openFile
  mov FD, rax # save file descriptor
  # position file at offset
  mov rdi, FD
  mov rsi, len2 # skip the first line
  mov rdx, 0
  call positionFile
  # read from file
  mov rdi, FD
  mov rsi, offset buffer
  mov rdx, 10 # number of characters to read
  call readFile
  mov rdi, rax
  call printString
  # close file
  mov rdi, FD
  call closeFile
  .endif
  .if DELETE
  # DELETE A FILE ----------------------------------
  # delete file UNCOMMENT NEXT LINES TO USE
  mov rdi, offset fileName
  call deleteFile
  .endif
  leave
  ret

# FILE MANIPULATION FUNCTIONS--------------------
#------------------------------------------------
  .global readFile
readFile:
  mov rax, NR_read
  syscall # rax contains # of characters read
  cmp rax, 0
  jl readerror
  mov byte ptr [rsi+rax], 0 # add a terminating zero
  mov rax, rsi
  mov rdi, offset success_Read
  push rax # caller saved
  call printString
  pop rax # caller saved
  ret

readerror:
  mov rdi, offset error_Read
  call printString
  ret

#--------------------------------------------------
  .global deleteFile
deleteFile:
  mov rax, NR_unlink
  syscall
  cmp rax, 0
  jl deleteerror
  mov rdi, offset success_Delete
  call printString
  ret

deleteerror:
  mov rdi, offset error_Delete
  call printString
  ret

#-------------------------------------------------
  .global appendFile
appendFile:
  mov rax, NR_open
  mov rsi, O_RDWR | O_APPEND
  syscall
  cmp rax, 0
  jl appenderror
  mov rdi, offset success_Append
  push rax  # caller saved
  call printString
  pop rax   # caller saved
  ret

appenderror:
  mov rdi, offset error_Append
  call printString
  ret

#------------------------------------------------
  .global openFile
openFile:
  mov rax, NR_open
  mov rsi, O_RDWR
  syscall
  cmp rax, 0
  jl openerror
  mov rdi, offset success_Open
  push rax  # caller saved
  call printString
  pop rax   # caller saved
  ret

openerror:
  mov rdi, offset error_Open
  call printString
  ret

#----------------------------------------------
  .global writeFile
writeFile:
  mov rax, NR_write
  syscall
  cmp rax, 0
  jl writeerror
  mov rdi, offset success_Write
  call printString
  ret

writeerror:
  mov rdi, offset error_Write
  call printString
  ret

#---------------------------------------------
  .global positionFile
positionFile:
  mov rax, NR_lseek
  syscall
  cmp rax, 0
  jl positionerror
  mov rdi, offset success_Position
  call printString
  ret

positionerror:
  mov rdi, offset error_Position
  call printString
  ret

#---------------------------------------------
  .global closeFile
closeFile:
  mov rax, NR_close
  syscall
  cmp rax, 0
  jl closeerror
  mov rdi, offset success_Close
  call printString
  ret

closeerror:
  mov rdi, offset error_Close
  call printString
  ret

#------------------------------------------------
  .global createFile
createFile:
  mov rax, NR_create
  mov rsi, S_IRUSR | S_IWUSR
  syscall
  cmp rax, 0                # file descriptor in rax
  jl createerror
  mov rdi, offset success_Create
  push rax                  # caller saved
  call printString
  pop rax                   # caller saved
  ret

createerror:
  mov rdi, offset error_Create
  call printString
  ret

# PRINT FEEDBACK
#-----------------------------------------------
  .global printString
printString:
  # Count characters
  mov r12, rdi
  mov rdx, 0

strLoop:
  cmp byte ptr [r12], 0
  je strDone
  inc rdx # length in rdx
  inc r12
  jmp strLoop

strDone:
  cmp rdx, 0 # no string (0 length)
  je prtDone
  mov rsi, rdi
  mov rax, 1
  mov rdi, 1
  syscall

prtDone:
  ret
