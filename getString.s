@ getString.s
@ scans for a string, converts it to a number or a suit.
@ csci 212, summer 2023
@ Daryll Guiang, 007419370
@ July18 2023
	@ r4 - holds string address
	@ r10 - holds the returned number


@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8
.syntax unified

@ constants
.equ bytes,50
.section .rodata
.align 2
prompt:	.asciz "\n\tEnter your choice, 2-10, or J, Q, K, A:\n\t "
tab: .asciz "\t\n"

@ text
.text
.align 2
.global getString
.type getString, %function

@ main function
getString:
    push {fp, lr}          @ store lr in stack
    add fp, sp, #4

	@ prompt user
	ldr r0, =prompt
	bl printf

	@ create space, place pointer in r4
	mov r0, bytes
	bl malloc
	mov r4, r0

	@ read the line
	push {r4}
	bl readLine
	pop {r4}
	mov r10, r0

	@ free heap space
	mov r0, r4
	bl free

	@ return the number
	mov r0, r10
    sub fp, sp, #4
    pop {fp, pc}
