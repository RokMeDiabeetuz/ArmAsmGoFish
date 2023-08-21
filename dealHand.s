@ dealHand.s
@ Swaps the values between two indices of a given array.
@ first 0.
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ July 24 2023
@ registries used:
    @ r4 - array
    @ r5 - deck
    @ r6 - amount to deal
    @ r7 - deck size
    @ r8 - temp register
    @ r9 - calc offset
    @ r10 - counter

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ text
.text
.align 2
.global dealHand
.type dealHand, %function

dealHand:
    @ save previous method call
    push {fp, lr}
    add fp, sp, #4
    @ counter
    mov r10, #0
    @ save values
    mov r4, r0      @ current hand array
    mov r5, r1      @ current deck
    mov r6, r2      @ amount to deal
    mov r7, r3      @ current deck size
    loop:
        cmp r10, r6
        beq end
        sub r7, r7, #1
        mov r9, r7, lsl #2
        ldr r8, [r5, r9]
        mov r9, r10, lsl #2
        str r8, [r4, r9]
        mov r8, #0
        mov r9, r7, lsl #2
        str r8, [r5, r9]
        add r10, r10, #1
        b loop

    end:
    @ restore previous method call
    mov r0, r7
    sub sp, fp, #4
    pop {fp, pc}
