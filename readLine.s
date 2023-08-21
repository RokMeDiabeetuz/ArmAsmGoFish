@ scanLine.s
@ reads a line from terminal and determines what suit is entered. Returns suit in int form
@ or 0 if incorrect string entered.
@ registries:
    @ r4 - stores string pointer
    @ r5 - copy of string pointer
    @ r6 - char counter
    @ r10 - stores final integer number

@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8
.syntax unified

@ constants
.equ    STDIN,0
.equ    NUL,0
.equ    LF,10

@ text
.text
.align 2
.global readLine
.type readLine, %function

@ readLIne
readLine:
    @ save previous call
    push {fp, lr}          @ store lr in stack
    add fp, sp, #4

    @ save string pointer
    mov r4, r0
    mov r5, r0
    mov r10, #0
    @ read from keyboard
    mov r0, STDIN
    mov r1, r4
    mov r2, #1
    bl read

    loop:
        ldrb r3, [r4]   @ store current string char to r1, compare to end of input
        cmp r3, LF
        beq endString
        @ increment count, read from input
        add r4, r4, #1
        mov r0, STDIN
        mov r1, r4
        mov r2, #1
        bl read
        b loop

    endString:
        mov r0, NUL
        strb r0, [r4]
        mov r4, r5
        findLoop:
            ldrb r3, [r4]
            cmp r3, NUL
            beq getDigit
            cmp r3, #'A'
            beq ace
            cmp r3, #'a'
            beq ace
            cmp r3, #'J'
            beq jack
            cmp r3, #'j'
            beq jack
            cmp r3, #'Q'
            beq queen
            cmp r3, #'q'
            beq queen
            cmp r3, #'K'
            beq king
            cmp r3, #'k'
            beq king
            add r4, r4, #1
            b findLoop
    @ jack
    jack:
        mov r10, #11
        b end
    @ queen
    queen:
        mov r10, #12
        b end
    @ king
    king:
        mov r10, #13
        b end
    @ ace
    ace:
        mov r10, #1
        b end

    @ get digit
    getDigit:
        mov r0, r5
        bl atoi
        mov r10, r0
        b end

    @ end
    end:
        @ restore previous call, return number
        mov r0, r10
        sub fp, sp, #4
        pop {fp, pc}
    
