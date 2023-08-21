@ removeFromHand.s
@ Takes in a number and removes it from the array, returns the new size of the array
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ August 8 2023
@ registries used:
    @ r4 - array pointer
    @ r5 - item to remove
    @ r6 - size of array
    @ r7 - counter
    @ r8 - offset
    @ r9 - temp register

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ text
.text
.align 2
.global removeFromHand
.type removeFromHand, %function

removeFromHand:
    @ save previous call
    push {fp, lr}
    add fp, sp, #4
    @ save array and item
    mov r4, r0
    mov r5, r1
    mov r6, r2
    mov r7, #0
    loop:
        cmp r7, r6
        beq notFound
        mov r8, r7, lsl #2
        ldr r9, [r4, r8]
        cmp r9, r5
        beq found
        add r7, r7, #1
        b loop  

    found:
        mov r9, #0
        str r9, [r4, r8]
        mov r0, r4
        mov r1, r6
        push {r4, r5, r6, r7, r8, r9}
        bl correctZeros
        pop {r4, r5, r6, r7, r8, r9}
        b end

    notFound:
        mov r0, r6
        b end

    end:
        @ return to previous call
        sub sp, fp, #4
        pop {fp, pc}

    