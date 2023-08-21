@ main.s
@ Starting program for go fish
@ Daryll Guiang, 007419370
@ CSCI 212, Summer 2023
@ August 2, 2023
@ registries:
    @ r4 - deck of cards
    @ r5 - computer player hand 
    @ r6 - computer player pairs 
    @ r7 - human player hand
    @ r8 - human player pairs
    @ r9 - counter array
        @ #0 - deck size
        @ #4 - computer player deck size
        @ #8 - player 1 deck size
        @ #12 - computer player pairs
        @ #16 - player 1 pairs
        @ #20 - temp storage 1
        @ #24 - temp storage 2
    @ r10 - random seed


@ define architecture
.cpu cortex-a72
.fpu neon-fp-armv8

@ data
.data 
    humanWon:       .asciz "\n*** Human Player Won ***"
    computerWon:    .asciz "\n*** Computer Won ***"
    itsATie:        .asciz "\n*** Its a Tie! ***\n"
    startingGame:   .asciz "\n*** STARTING GAME ***\n"
    cardsInDeck:    .asciz "\tCards left in deck: %d\n"
    currentHand:    .asciz "\n\tCurrent Hand: "
    currentPairs:   .asciz "\tCurrent Pairs: "
    computerPairs:  .asciz "\tComputer Pairs: "
    playerPairs:    .asciz "\tPlayer Pairs: "
    totalPairs:     .asciz "\nNo of pairs: %d"
    userPrompt:     .asciz "\n\tEnter numbers 2-10 or J, Q, K, A: "
    compturn:       .asciz "\nComputer's turn: Computer picked "
    humanTurn:      .asciz "\nYour turn!\n"
    humanChoice:    .asciz "\nPick a card: "
    matchPrompt:    .asciz "\n\tIts a match!\n"
    deckMatchPlyr:  .asciz "\n\tYou drew matching card from deck, adding to pairs.\n"
    guessedRight:   .asciz "\n\tYou guessed right! Taking computers card.\n"
    goFishPrompt:   .asciz "\n\tGo Fish!\n"
    number:         .asciz "\n\tYou picked: %d"

@ text
.text
.align 2
.global main
.type main, %function

main:
    @ save onto stack
    push {fp, lr}
    add fp, sp, #4

    @ allocate array space for deck, fill array
    mov r0, #208
    bl malloc
    mov r4, r0
    push {r4}
    mov r0, r4
    bl fillArray
    pop {r4}
    @ shuffle
    mov r0, r4
    push {r4}
    bl shuffle
    pop {r4}

    @ create starting counts
    mov r0, #28
    bl malloc
    mov r9, r0
    mov r1, #52
    str r1, [r9, #0]    @ start deck count at 52
    mov r1, #5          @ start hand count at 5
    str r1, [r9, #4]
    str r1, [r9, #8]
    mov r1, #0          @ start hand count at 0
    str r1, [r9, #12]
    str r1, [r9, #16]
    str r1, [r9, #20]
    str r1, [r9, #24]

    @ allocate computer hand, deal hand
    mov r0, #208
    bl malloc
    mov r5, r0
    mov r1, r4
    ldr r2, [r9, #4]
    ldr r3, [r9, #0]
    push {r4, r5, r6, r7, r8, r9}
    bl dealHand
    pop {r4, r5, r6, r7, r8, r9}
    str r0, [r9, #0]

    @ allocate player hand, deal hand
    mov r0, #208
    bl malloc
    mov r7, r0
    mov r1, r4
    ldr r2, [r9, #8]
    ldr r3, [r9, #0]
    push {r4, r5, r6, r7, r8, r9}
    bl dealHand
    pop {r4, r5, r6, r7, r8, r9}
    str r0, [r9, #0]

    @ allocate space for computer and player pairs arrays
    mov r0, #108
    bl malloc 
    mov r6, r0
    mov r0, #108
    bl malloc
    mov r8, r0

    continueForward:
    @ print initial state
    ldr r0, =startingGame
    bl printf

    @ print player hand and pairs
    ldr r0, =currentHand
    bl printf
    mov r0, r7
    ldr r1, [r9, #8]
    push {r4, r5, r6, r7, r8, r9, r10}
    bl printArray
    pop {r4, r5, r6, r7, r8, r9, r10}
    ldr r0, =currentPairs
    bl printf
    mov r0, r8
    ldr r1, [r9, #16]
    push {r4, r5, r6, r7, r8, r9, r10}
    bl printPairs
    pop {r4, r5, r6, r7, r8, r9, r10}

    @ remove duplicates
    mov r10, #0
    removeLoop:
        cmp r10, #2
        beq createSeed
        
        @ computer hand - remove duplicates
        mov r0, r5
        ldr r1, [r9, #4]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl removeDuplicates
        pop {r4, r5, r6, r7, r8, r9, r10}
        cmp r0, #0
        beq skip
        
        @ place duplicate into computer pairs
        ldr r1, [r9, #12]
        mov r2, r1, lsl #2
        str r0, [r6, r2]
        ldr r1, [r9, #12]
        add r1, r1, #1
        str r1, [r9, #12]
        
        @ update computer hand array and count
        mov r0, r5
        ldr r1, [r9, #4]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl correctZeros
        pop {r4, r5, r6, r7, r8, r9, r10}
        str r0, [r9, #4]

        @ player hand - remove duplicates
        skip:
        mov r0, r7
        ldr r1, [r9, #8]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl removeDuplicates
        pop {r4, r5, r6, r7, r8, r9, r10}
        cmp r0, #0
        beq incrementCount
        
        @ place duplicate into player pairs
        ldr r1, [r9, #16]
        mov r2, r1, lsl #2
        str r0, [r8, r2]
        ldr r1, [r9, #16]
        add r1, r1, #1
        str r1, [r9, #16]
        
        @ update player hand array and count
        mov r0, r7
        ldr r1, [r9, #8]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl correctZeros
        pop {r4, r5, r6, r7, r8, r9, r10}
        str r0, [r9, #8]

        @ increment count
        incrementCount:
        add r10, r10, #1
        b removeLoop

    @ create seed for random, place in r10
    createSeed:
    mov r0, #0
    bl time
    bl srand
    mov r10, r0
    
    @ main loop
    mainLoop:

        @ check if game is over
        ldr r3, [r9, #0]
        cmp r3, #0
        beq calculateWinner
        ldr r3, [r9, #4]
        cmp r3, #0
        beq calculateWinner
        ldr r3, [r9, #8]
        cmp r3, #0
        beq calculateWinner
        
        @ prompt the computer
        ldr r0, =compturn
        bl printf
    
        @ get and print the computer's choice
        mov r0, r10
        ldr r1, [r9, #4]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl getIndex
        mov r2, r0, lsl #2
        ldr r1, [r5, r2]
        str r1, [r9, #20]
        ldr r0, [r5, r2]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl printChoice
        pop {r4, r5, r6, r7, r8, r9, r10}
        @ determine if player's hand contains computer's choice
        mov r0, r7
        mov r2, r1
        ldr r1, [r9, #8]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl contains
        pop {r4, r5, r6, r7, r8, r9, r10}
        cmp r0, #0
        beq goFishComp
        cmp r0, #0
        bne compCorrect
        
        playerChoice:
        @ prompt player
        ldr r0, =humanTurn
        bl printf
        @ print player hand and pairs
        ldr r0, =currentHand
        bl printf
        mov r0, r7              @ print hand
        ldr r1, [r9, #8]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl printArray
        pop {r4, r5, r6, r7, r8, r9, r10}
        ldr r0, =currentPairs
        bl printf
        mov r0, r8
        ldr r1, [r9, #16]       @ print pairs
        push {r4, r5, r6, r7, r8, r9, r10}
        bl printPairs
        pop {r4, r5, r6, r7, r8, r9, r10} 
        ldr r0, =cardsInDeck    @ print cards left in deck
        ldr r1, [r9, #0]
        bl printf
        @ get player choice
        push {r4, r5, r6, r7, r8, r9, r10}
        bl getString
        pop {r4, r5, r6, r7, r8, r9, r10} 
        str r0, [r9, #24]       @ store choice in extra storage
        @ determine if computer's hand contains player's choice
        mov r2, r0
        mov r0, r5
        ldr r1, [r9, #4]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl contains
        pop {r4, r5, r6, r7, r8, r9, r10}
        mov r1, r0
        cmp r0, #0
        beq goFishPlayer
        mov r0, r1
        cmp r0, #0
        bne playerCorrect

        @ restart loop
        increment:
            b mainLoop
        
    
    @ go fish
    goFishComp:
        
        @ if computer guess wrong
        ldr r0, =goFishPrompt
        bl printf
        ldr r0, [r9, #0]    @ get size of deck, sub 1 to get last index
        sub r0, r0, #1
        str r0, [r9, #0]    @ update size of deck
        mov r1, r0, lsl #2  @ get offset of last index
        ldr r2, [r4, r1]    @ store last item in deck to r2
        ldr r0, [r9, #4]    @ get last index of computer hand
        mov r1, r0, lsl #2  @ calc offset for computer hand last index
        str r2, [r5, r1]    @ store item from deck into computer hand
        ldr r0, [r9, #4]    @ increment size of computer hand
        add r0, r0, #1
        str r0, [r9, #4]

        @ check for duplicates, remove, and update size of hand
        mov r0, r5          @ move computer hand into arg 1
        ldr r1, [r9, #4]    @ move hand size into arg 2
        push {r4, r5, r6, r7, r8, r9, r10}      @ check new hand for duplicates
        bl removeDuplicates
        pop {r4, r5, r6, r7, r8, r9, r10}
        mov r3, r0          @ move duplicate, if found, into r3
        cmp r3, #0          @ return to player choice if none found.
        beq playerChoice
        
        @ if player drew a matching card from the deck
        ldr r0, [r9, #12]   @ get last index of computer pairs
        mov r1, r0, lsl #2  
        str r3, [r6, r1]    @ store duplicate into last index of computer pairs
        ldr r0, [r9, #12]   @ update count of computer pairs
        add r0, r0, #1
        str r0, [r9, #12]
        
        @ remove zeros in the computer hand
        mov r0, r5
        ldr r1, [r9, #4]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl correctZeros
        mov r1, r0
        pop {r4, r5, r6, r7, r8, r9, r10}
        str r1, [r9, #4]  @ update size of hand
        b playerChoice

    @ computer is correct
    compCorrect:
        ldr r0, =matchPrompt    @ notify of match
        bl printf
        @ remove the zeros left in the array of player hand
        ldr r1, [r9, #20]
        mov r0, r7
        ldr r2, [r9, #8]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl removeFromHand
        mov r1, r0
        pop {r4, r5, r6, r7, r8, r9, r10}
        str r1, [r9, #8]    @ update player hand
        
        @ place correct answer in computer pairs array
        ldr r1, [r9, #20]   @ store computer choice in r1
        ldr r0, [r9, #12]   @ get last index of computer pairs
        mov r2, r0, lsl #2  @ offset for last index
        str r1, [r6, r2]    @ store new pair item in computer pair
        ldr r0, [r9, #12]   @ load current computer pair count
        add r0, r0, #1
        str r0, [r9, #12]   @ update count
        
        @ remove chosen pair from computer hand
        mov r0, r5          @ place computer hand in arg 0
        ldr r1, [r9, #20]   @ place choice in arg 1
        ldr r2, [r9, #4]    @ place size of hand in arg 2
        push {r4, r5, r6, r7, r8, r9, r10}
        bl removeFromHand
        mov r1, r0
        pop {r4, r5, r6, r7, r8, r9, r10}
        str r1, [r9, #4]
        b playerChoice
    
    @ go fish player
    goFishPlayer:
        
        @ if player guess wrong
        ldr r0, =goFishPrompt
        bl printf
        
        addToDeck:
        @ remove from deck and add to hand
        ldr r0, [r9, #0]    @ get size of deck, sub 1 to get last index
        sub r0, r0, #1
        str r0, [r9, #0]    @ update size of deck
        mov r1, r0, lsl #2  @ get offset of last index
        ldr r2, [r4, r1]    @ store last item in deck to r2
        ldr r0, [r9, #8]    @ get last index of player hand
        mov r1, r0, lsl #2  @ calc offset for player hand last index
        str r2, [r7, r1]    @ store item from deck into player hand
        ldr r0, [r9, #8]    @ increment size of computer hand
        add r0, r0, #1
        str r0, [r9, #8]
        
        @ check for duplicates, remove, and update size of hand
        mov r0, r7
        ldr r1, [r9, #8]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl removeDuplicates
        pop {r4, r5, r6, r7, r8, r9, r10}
        str r0, [r9, #24]
        cmp r0, #0
        beq increment
        
        @ if duplicate found, place into pairs array
        ldr r0, =deckMatchPlyr
        bl printf
        ldr r0, [r9, #16]
        mov r1, r0, lsl #2 
        ldr r3, [r9, #24]
        str r3, [r8, r1]    @ store duplicate in player pairs
        ldr r0, [r9, #16]
        add r0, r0, #1
        str r0, [r9, #16]   @ update pairs count
        
        @ remove zeros from the player hand
        mov r0, r7
        ldr r1, [r9, #8]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl correctZeros
        mov r3, r0
        pop {r4, r5, r6, r7, r8, r9, r10}
        str r3, [r9, #8]
        b increment


    @ player is correct
    playerCorrect:
        @ notify player he guessed correct
        ldr r0, =guessedRight
        bl printf
        
        @ remove the zeros left in the array of computer hand
        ldr r1, [r9, #24]
        mov r0, r5
        ldr r2, [r9, #4]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl removeFromHand
        mov r1, r0
        pop {r4, r5, r6, r7, r8, r9, r10}
        str r1, [r9, #4]    @ update computer hand
        
        @ place correct answer in player hand
        ldr r1, [r9, #24]   @ store choice in r1
        ldr r0, [r9, #8]   @ get last index of player hand
        mov r2, r0, lsl #2  @ offset for last index
        str r1, [r7, r2]    @ store new item in 
        ldr r0, [r9, #8]   @ load current computer pair count
        add r0, r0, #1      
        str r0, [r9, #8]   @ update count
        
        @ check for duplicates, remove, and update size of hand
        mov r0, r7
        ldr r1, [r9, #8]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl removeDuplicates
        pop {r4, r5, r6, r7, r8, r9, r10}
        cmp r0, #0
        beq increment
        
        @ if duplicate found, place into pairs array
        ldr r0, [r9, #16]
        mov r1, r0, lsl #2 
        ldr r3, [r9, #24]
        str r3, [r8, r1]    @ store duplicate in player pairs
        ldr r0, [r9, #16]
        add r0, r0, #1
        str r0, [r9, #16]   @ update pairs count
        
        @ remove zeros from the player hand
        mov r0, r7
        ldr r1, [r9, #8]
        push {r4, r5, r6, r7, r8, r9, r10}
        bl correctZeros
        mov r3, r0
        pop {r4, r5, r6, r7, r8, r9, r10}
        str r3, [r9, #8]
        b increment
        
        b increment


    @ calculate winner
    calculateWinner:
        ldr r2, [r9, #16]      @ player pairs
        ldr r3, [r9, #12]      @ computer pairs
        cmp r2, r3
        bgt humWon
        cmp r2, r3
        beq tie

    @ computer player won
    compWon:
    ldr r0, =computerWon    @ notify that computer player won
    bl printf
    ldr r0, =currentHand    @ print label
    bl printf
    mov r0, r5
    ldr r1, [r9, #4]
    push {r4, r5, r6, r7, r8, r9}
    @ print current hand
    bl printArray
    pop {r4, r5, r6, r7, r8, r9}
    ldr r0, =currentPairs
    bl printf
    mov r0, r6
    ldr r1, [r9, #12]
    push {r4, r5, r6, r7, r8, r9}
    @ print pairs
    bl printPairs
    pop {r4, r5, r6, r7, r8, r9}
    b end
    
    @ human player won
    humWon:
    ldr r0, =humanWon
    bl printf
    ldr r0, =currentHand
    bl printf
    mov r0, r7
    ldr r1, [r9, #8]
    push {r4, r5, r6, r7, r8, r9}
    bl printArray
    pop {r4, r5, r6, r7, r8, r9}
    ldr r0, =currentPairs
    bl printf
    mov r0, r8
    ldr r1, [r9, #16]
    push {r4, r5, r6, r7, r8, r9}
    bl printPairs
    pop {r4, r5, r6, r7, r8, r9}
    b end

    @ its a tie
    tie:
    ldr r0, =itsATie
    bl printf
    ldr r0, =computerPairs
    bl printf
    mov r0, r6
    ldr r1, [r9, #12]
    push {r4, r5, r6, r7, r8, r9}
    @ print pairs
    bl printPairs
    pop {r4, r5, r6, r7, r8, r9}
    ldr r0, =playerPairs
    bl printf
    mov r0, r8
    ldr r1, [r9, #16]
    push {r4, r5, r6, r7, r8, r9}
    bl printPairs
    pop {r4, r5, r6, r7, r8, r9}
    b end

    @ end print and clean up
    end:
    @ free used heap memory
    mov r0, r4
    bl free
    mov r0, r5
    bl free
    mov r0, r6
    bl free
    mov r0, r7
    bl free
    mov r0, r8
    bl free
    mov r0, r9
    bl free
    @ return to previous call
    sub sp, fp, #4
    pop {fp, pc}
