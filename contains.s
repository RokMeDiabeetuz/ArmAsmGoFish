@ printChoice.s
@ determines if an array has a given number; returns that number if so, 0 if not found.
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ July 24 2023
@ registries used:
    @ r4 - array to search through
    @ r5 - size of the array
    @ r6 - chosen card by the user or computer
    @ r7 - index counter
    @ r8 - calculate offset
    @ r9 - temp register

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ data
.data
    number: .asciz " [ %d ]"
    numberEnd: .asciz "\nEND: [ %d ]\n"

@ text
.text
.align 2
.global contains
.type contains, %function

@ contains function
contains:
    @ save previous call
    push {fp, lr}
    add fp, sp, #4
    @ store data in new registers
    mov r4, r0
    mov r5, r1
    mov r6, r2
    mov r7, #0
    @ iterate to find value in array
    loop:
        cmp r7, r5
        beq notFound
        mov r8, r7, lsl #2
        ldr r9, [r4, r8]
        cmp r9, r6
        beq end
        add r7, r7, #1
        b loop
    @ not found
    notFound:
        mov r0, #0
        sub sp, fp, #4
        pop {fp, pc}
        
    @ return to previous call
    end:
        mov r0, r6
        sub sp, fp, #4
        pop {fp, pc}


