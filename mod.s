@ mod.s
@ Returns the modulos of two numbers
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ July 24 2023
@ registries used:
    @ r0-r3 used, will be overwritten when returning from function

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ text
.text
.align 2
.global mod
.type mod, %function

mod:
    @ save previous method call
    push {fp, lr}
    add fp, sp, #4
    @ store divident into r3
    mov r3, r0
    @ calculate the qoutient
    udiv r2, r0, r1
    @ multiply qoutient with divisor
    mul r2, r2, r1
    @ subtract product from divident to get modulus
    sub r2, r3, r2
    @ return modulus
    mov r0, r2
    sub sp, fp, #4
    pop {fp, pc}


    

