@ printPairs.s
@ Finds duplicates in a player's hands; return the duplicate if found, 0 otherwise.
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ July 24 2023
@ registries used:
    @ r4 - current hand
    @ r5 - size of hand
    @ r6 - outer counter
    @ r7 - inner counter
    @ r8 - outer value
    @ r9 - inner value
@ data
.data
    number: .asciz "\n\t[ %d ]\n"

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ text
.text
.align 2
.global removeDuplicates
.type printPairs, %function

@ removeDuplicates
removeDuplicates:
    @ save previous method call
    push {fp, lr}
    add fp, sp, #4
    @ save array ro r4, size in r5
    mov r4, r0
    mov r5, r1
    mov r6, #0
    outerLoop:  @ outer loop
        cmp r6, r5  @ check if end of array reached
        beq nonFound
        add r7, r6, #1  @ start inner loop outer index + 1
        innerLoop:
            cmp r7, r5  @ check if inner index is at the end
            beq endInner
            mov r1, r6, lsl #2
            ldr r8, [r4, r1]
            mov r2, r7, lsl #2
            ldr r9, [r4, r2]
            cmp r8, r9
            beq found
            add r7, r7, #1
            b innerLoop
        endInner:
        add r6, r6, #1
        b outerLoop
    
    @ if no match found, return 0
    nonFound:
        mov r0, #0
        b end
    @ if match found, return the matched number
    found:
        mov r0, #0
        str r0, [r4, r2]    @ zero the matched indices
        str r0, [r4, r1]
        mov r0, r9
        b end
    end:
        @ return to previous call
        sub sp, fp, #4
        pop {fp, pc}
    
