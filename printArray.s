@ printArrays.s
@ Takes in an array and its size and prints it to screen.
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ July 24 2023
@ registries used:
    @ r7 - stores array
    @ r8 - stores size of array
    @ r9 - used as counter
    @ r10 - used to determine shift

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ data
.data
    charPrint:   .asciz "[%c] "
    numberPrint: .asciz "[%d] "
    newLine:     .asciz "\n\n"

@ text
.text
.align 2
.global printArray
.type printArray, %function

printArray:
    @ save onto stack 
    push {fp, lr}
    add fp, sp, #4

    @ store array in r7, size in r8, start count at 0 in r9
    mov r7, r0
    mov r8, r1
    mov r9, #0

    loop:
        @ compare count to array size
        cmp r9, r8
        beq end
        @ calculate index position
        mov r10, r9, lsl #2 
        @ load into arg 1 the string, int value into arg 2
        ldr r0, =numberPrint
        ldr r1, [r7, r10]
        cmp r1, #1
        beq ace
        cmp r1, #11
        beq jack
        cmp r1, #12
        beq queen
        cmp r1, #13
        beq king
        continue:
        bl printf
        add r9, r9, #1
        b loop

    ace:
        ldr r0, =charPrint
        mov r1, #'A'
        b continue
    jack:
        ldr r0, =charPrint
        mov r1, #'J'
        b continue
    queen:
        ldr r0, =charPrint
        mov r1, #'Q'
        b continue
    king:
        ldr r0, =charPrint
        mov r1, #'K'
        b continue

end:
@ print newline and index value
ldr r0, =newLine
bl printf
sub sp, fp, #4
pop {fp, pc}
