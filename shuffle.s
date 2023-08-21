@ shuffle.s
@ Takes in a 52 card array and shuffles the values.
@ a card in the deck.
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ August 8 2023
@ registries used:
    @ r4 - array pointer
    @ r5 - counter
    @ r6 - first swap index
    @ r7 - second swap index

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ text
.text
.align 2
.global shuffle
.type shuffle, %function

shuffle:
    @ save previous call
    push {fp, lr}
    add fp, sp, #4
    @ save array into r4
    mov r4, r0
    @ create rand seed
    mov r0, #0
    bl time
    bl srand
    @ loop
    mov r5, #0
    loop1:
        @ check if count reaches 51
        cmp r5, #51
        beq endFirst
        @ get random number
        bl rand
        mov r1, #51
        bl mod
        add r0, r0, #1
        mov r6, r0
        @ swap values at the current indices
        mov r0, r4
        mov r1, r6
        mov r2, r5
        push {r4, r5, r6, r7}
        bl swap
        pop {r4, r5, r6, r7}
        add r5, r5, #1
        b loop1
    endFirst:
    mov r5, #51
    loop2:
        @ check if count reaches 0
        cmp r5, #0
        beq endSecond
        @ get random number
        bl rand
        mov r1, #51
        bl mod
        add r0, r0, #1
        mov r6, r0
        @ swap values at the current indices
        mov r0, r4
        mov r1, r6
        mov r2, r5
        push {r4, r5, r6, r7}
        bl swap
        pop {r4, r5, r6, r7}
        sub r5, r5, #1
        b loop2
    endSecond:
    mov r5, #0
    loop3:
        @ check if count reaches 0
        cmp r5, #51
        beq end
        @ get random number
        bl rand
        mov r1, #51
        bl mod
        add r0, r0, #1
        mov r6, r0
        @ swap values at the current indices
        mov r0, r4
        mov r1, r6
        mov r2, r5
        push {r4, r5, r6, r7}
        bl swap
        pop {r4, r5, r6, r7}
        add r5, r5, #1
        b loop3
    end:
        @ return to previous call
        mov r0, #0
        sub sp, fp, #4
        pop {fp, pc}
