@ correctZeros.s
@ Iterates through the array and finds the indices with zeros. Swaps that index with the last item and 
@ updates the size of the array.
@ CSCI 212, Summer 2023
@ July 24 2023
@ registries used:
    @ r4 - store first array
    @ r5 - store size of first array
    @ r6 - new array
    @ r7 - index counter
    @ r8 - new array counter
    @ r9 - calculate offset
    @ r10 - temp storage

@ DATA
.data
    number: .asciz "\n[ %d ]\n"

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ text
.text
.align 2
.global correctZeros
.type correctZeros, %function

@ correct zeros
correctZeros:
    @ save previous method call
    push {fp, lr}
    add fp, sp, #4

    @ save items
    mov r4, r0
    mov r5, r1
    
    @ create new array
    mov r0, #208
    bl malloc
    mov r6, r0

    @ set indices to zero
    mov r7, #0      @ original array index
    mov r8, #0      @ new array index and size of non zeros
    
    @ loop
    loop:
        cmp r7, r5
        beq copy
        mov r9, r7, lsl #2
        ldr r10, [r4, r9]
        cmp r10, #0
        beq skip
        mov r9, r8, lsl #2
        str r10, [r6, r9]
        add r8, r8, #1
        skip:
        add r7, r7, #1
        b loop

    @ copy
    copy:
    mov r7, #0
    copyLoop:
        cmp r7, r8
        beq end
        mov r9, r7, lsl #2
        ldr r10, [r6, r9]
        str r10, [r4, r9]
        add r7, r7, #1
        b copyLoop

    @ restore previous method call
    end:
    mov r0, r6
    bl free
    ldr r0, =number
    mov r1, r8
    mov r0, r8
    sub sp, fp, #4
    pop {fp, pc}


