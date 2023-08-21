@ fillArray.s
@ Create a 52 element array, place inside quads of numbers 1-13, each representing
@ a card in the deck.
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ August 8 2023
@ registries used:
    @ r4 - stores array pointer
    @ r8 - holds temporary 
    @ r9 - counter
    @ r10 - used as counter to a max of 45

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ text
.text
.align 2
.global fillArray
.type fillArray, %function

@ create array
fillArray:
    push {fp, lr}
    add fp, sp, #4

    @ save into r4 the array pointer
    mov r4, r0

    @ start loop
    mov r10, #0
    mov r9, #0
    mov r8, #1
    loop:
        @ compare current sum to max of 45
        cmp r10, #52
        bge end
        @ fill first
        mov r1, r10, lsl #2
        str r8, [r4, r1]
        add r9, r9, #1
        add r10, r10, #1
        @ fill second
        mov r1, r10, lsl #2
        str r8, [r4, r1]
        add r9, r9, #1
        add r10, r10, #1
        @ fill third
        mov r1, r10, lsl #2
        str r8, [r4, r1]
        add r9, r9, #1
        add r10, r10, #1
        @ fill fourth
        mov r1, r10, lsl #2
        str r8, [r4, r1]
        add r9, r9, #1
        add r10, r10, #1
        add r8, r8, #1
        b loop
  
    end:
        mov r0, r9      @ store array size in r0 to return
        sub sp, fp, #4
        pop {fp, pc}
    


    


