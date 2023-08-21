GOFISH: contains.o correctZeros.o dealHand.o fillArray.o getRandomIndex.o getString.o main.o mod.o printArray.o printChoice.o printPairs.o readLine.o removeDuplicates.o removeFromHand.o shuffle.o swap.o
	gcc -o GOFISH contains.o correctZeros.o dealHand.o fillArray.o getRandomIndex.o getString.o main.o mod.o printArray.o printChoice.o printPairs.o readLine.o removeDuplicates.o removeFromHand.o shuffle.o swap.o
contains.o: contains.s
	gcc -c contains.s
correctZeros.o: correctZeros.s
	gcc -c correctZeros.s
dealHand.o: dealHand.s
	gcc -c dealHand.s
fillArray.o: fillArray.s
	gcc -c fillArray.s
getRandomIndex.o: getRandomIndex.s
	gcc -c getRandomIndex.s
getString.o: getString.s
	gcc -c getString.s
main.o: main.s
	gcc -c main.s
mod.o: mod.s
	gcc -c mod.s
printArray.o: printArray.s
	gcc -c printArray.s
printChoice.o: printChoice.s
	gcc -c printChoice.s
printPairs.o: printPairs.s
	gcc -c printPairs.s
readLine.o: readLine.s
	gcc -c readLine.s
removeDuplicates.o: removeDuplicates.s
	gcc -c removeDuplicates.s
removeFromHand.o: removeFromHand.s
	gcc -c removeFromHand.s
shuffle.o: shuffle.s
	gcc -c shuffle.s
swap.o: swap.s
	gcc -c swap.s
clean:
	rm *.o GOFISH
















