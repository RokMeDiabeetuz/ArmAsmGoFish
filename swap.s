@ swap.s
@ Swaps the values between two indices of a given array.
@ first 0.
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ July 24 2023
@ registries used:
    @ r0 - array pointer
    @ r1 - index of first element
    @ r2 - index of second element
    @ r3 - calculates index
    @ r4 - temprorary storage
    @ r5 - tempoerary storage

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ text
.text
.align 2
.global swap
.type swap, %function

@ swap method
swap:
    @ save previous method call
    push {fp, lr}
    add fp, sp, #4
    
    @ swap
    mov r3, r1, lsl #2      @ extract the first value, store into r4
    ldr r4, [r0, r3]
    mov r3, r2, lsl #2      @ extract second value, store into r5
    ldr r5, [r0, r3]
    str r4, [r0, r3]        @ store firest value into second index
    mov r3, r1, lsl #2
    str r5, [r0, r3]

    @ return to previous call
    sub sp, fp, #4
    pop {fp, pc}
    





    


