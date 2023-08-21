@ getRandomIndex.s
@ gets a random index for the CPU player.
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ August 8 2023
@ registries used:
    @ r0 - seed
    @ r1 - max

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ data
.data
    seed: .asciz "\t\tSeed: %d"
    max:  .asciz "\t\tMax: %d"

@ text
.text
.align 2
.global getIndex
.type getIndex, %function

@ get random index
getIndex:
    @ save previous call
    push {fp, lr}
    add fp, sp, #4
    @ save arguments
    push {r1}
    bl rand
    pop {r1}
    bl mod
    add r0, r0, #0
    
    end:
        sub sp, fp, #4
        pop {fp, pc}
    