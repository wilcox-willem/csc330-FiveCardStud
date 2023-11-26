package main

import (
	"fmt"
	"os"
)

// // Table
// stores deck and hands, 
// as well as funcs to support
type Table struct {
	deck *Deck
	hands []*Hand
}

// // initTable
// Initializes table, if filepath given
// imports deck
func initTable(file string) *Table {
	
	var thisDeck = initDeck()
	var thisHands = make([]*Hand, 0)

	for i := 0; i < 6; i++ {
		thisHands = append(thisHands, initHand())
	}

	if (file != "") { thisDeck.importDeck(file) 
	} else  { thisDeck.createRandDeck() }

	return &Table {
		deck : thisDeck,
		hands : thisHands,
	}
}


// Starts a Five Hand game.
// Type of game is determined if there is an input file.
// Then determines the winning hands in descending order.
// param: file - String representing the file to build the deck from.
func (thisTable *Table) play(file string) {

	fmt.Println("*** P O K E R   H A N D   A N A L Y Z E R ***\n\n")

	gameType := true // true if using rand deck
	if (file != "") { gameType = false }

	if (gameType) {
		fmt.Println( "*** USING RANDOMIZED DECK OF CARDS ***\n\n" + "*** Shuffled 52 card deck\n" + thisTable.deck.toString())

	} else {
		fmt.Println( "\n*** USING TEST DECK ***\n" + "\n*** File: " + file + "\n" + thisTable.deck.toString())
	}

	if (thisTable.deck.duplicateCard != nil) {
		fmt.Println( "\n*** ERROR - DUPLICATED CARD FOUND IN DECK ***\n" + "\n*** DUPLICATE: " + thisTable.deck.duplicateCard.toString() + " ***\n")
		return
	}

	thisTable.drawCards()

	fmt.Println("\n*** Here are the six hands...")

	thisTable.printAllHands()

	if (gameType) {
		fmt.Println("\n*** Here is what remains in the deck...\n" + thisTable.deck.toString())
	}

	fmt.Println("\n--- WINNING HAND ORDER ---")

	thisTable.sortHands()
	thisTable.printAllHands()
	fmt.Println()
}


// Draws 30 cards to set up 6 hands of 5 cards.
// Alternates drawing cards among the hands.
// param: gameType - int representing if the hands should be drawn randomized or from a file input.
func (thisTable *Table) drawCards() {
	handNum := 0
	
	for i := 1; i <= 30; i++ {
		thisTable.hands[handNum].addCard(thisTable.deck.drawCard())
		if (i % 5 == 0) { handNum++ }
	}
	
}


// Prints all the hands to the console.
func (thisTable *Table) printAllHands() {
	for i := 0; i < len(thisTable.hands); i++ {
		fmt.Println(thisTable.hands[i].toString())
	}
}


// Sorts the hands to the winning order
func (thisTable *Table) sortHands() {
	for j := 0; j < len(thisTable.hands) - 1; j++ {
        for i := 0; i < len(thisTable.hands) - 1; i++ {
            if thisTable.hands[i].compare(thisTable.hands[i + 1]) < 0 {
                temp := thisTable.hands[i + 1]
                thisTable.hands[i + 1] = thisTable.hands[i]
                thisTable.hands[i] = temp
            }
        }
    }
}


// Main Method Calls
func main() {
	filePath := ""
	if (len(os.Args) > 1) { filePath = os.Args[1] }
	game := initTable(filePath)
	game.play(filePath)
}
