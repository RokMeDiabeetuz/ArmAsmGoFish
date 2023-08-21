@ printChoice.s
@ prints out a single computer or player choice to the screen
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ July 24 2023
@ registries used:
    @ r7 - item to print

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ data
.data
    charPrint:   .asciz "[%c] "
    numberPrint: .asciz "[%d] "
    newLine:    .asciz "\n"

@ text
.text
.align 2
.global printChoice
.type printChoice, %function

printChoice:
    @ save onto stack 
    push {fp, lr}
    add fp, sp, #4

    @ store item in r7
    mov r7, r0
    cmp r7, #1
    beq ace
    cmp r7, #11
    beq jack
    cmp r7, #12
    beq queen
    cmp r7, #13
    beq king
    ldr r0, =numberPrint
    mov r1, r7
    b end

    ace:
        ldr r0, =charPrint
        mov r1, #'A'
        b end
    jack:
        ldr r0, =charPrint
        mov r1, #'J'
        b end
    queen:
        ldr r0, =charPrint
        mov r1, #'Q'
        b end
    king:
        ldr r0, =charPrint
        mov r1, #'K'
        b end

    @ return to previous call
    end:
    bl printf
    ldr r0, =newLine
    bl printf
    mov r0, r7
    sub sp, fp, #4
    pop {fp, pc}
