package main

import (
	"io/ioutil"
	"math/rand"
	"time"
	"strings"
)

// // Card Struct // // // // // // //
// This struct defines a card,
// below it are functions to support Card

type Card struct {
	rank int
	suit int
}

func initCard(thisRank int, thisSuit int) *Card {
	return &Card {
		rank : thisRank,
		suit : thisSuit,
	}
}

// // compareCards
// Compares otherCard (O) to card calling func (T)
// returns int, (-#: T < O) (0: T = O) (+#: T > O)
func (thisCard *Card) compareCards(otherCard *Card) int {
	difference := thisCard.rank - otherCard.rank
	if (difference == 0) {
		difference = thisCard.suit - otherCard.suit
	}

	return difference
}

// // toString
// converts card to string
func (thisCard *Card) toString() string {
	// Ranks
    ranks := []string{" 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", "10", " J", " Q", " K", " A"}

    // Suits
    suits := []string{"D", "C", "H", "S"}

	rankStr := ranks[thisCard.rank - 2]
	suitStr := suits[thisCard.suit]

	return rankStr + suitStr

}

//--------------------------------------------------------------------------------//

// // Deck Struct // // // // // // //
// This struct defines a Deck,
// below it are functions to support Deck
type Deck struct {
	cards []*Card
	isImported bool
	duplicateCard *Card
}

// // initializes Deck
func initDeck() *Deck {
	return &Deck {
		cards : make([]*Card, 0),
		isImported : false, 	// change to true if imported
		duplicateCard : nil,
	}
}

// // createRandDeck
// creates a deck then shuffles it
func (thisDeck *Deck) createRandDeck() {

	for suit := 0; suit <= 3; suit ++ {
		for rank := 2; rank <= 14; rank ++ {
			thisDeck.cards = append(thisDeck.cards, initCard(rank, suit))
		}
	}

	rand.Seed(time.Now().UnixNano())

	rand.Shuffle(len(thisDeck.cards), func(i, j int) {
        thisDeck.cards[i], thisDeck.cards[j] = thisDeck.cards[j], thisDeck.cards[i]
    })
}


// // importDeck
// creates a deck based on given file path
func (thisDeck *Deck) importDeck(file string) error {
	thisDeck.isImported = true

	// Ranks
	ranks := []string{" 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", "10", " J", " Q", " K", " A"}

	// Suits
	suits := []string{"D", "C", "H", "S"}

	content, err := ioutil.ReadFile(file)
	if err != nil { return err }

	lines := strings.Split(string(content), "\n")

	for _, line := range lines {
		tokens := strings.Split(line, ",")

		for _, token := range tokens {
			currRankVal := 0
			currSuitVal := 0
			// token comes in form "RRS"
			currRank := token[:2]
			currSuit := token[2:3]
			

			// find rank
			for  i := 0; i < len(ranks); i++ {
				if (currRank == ranks[i]) {
					currRankVal = i + 2
				}
			}

			// find suit
			for  i := 0; i < len(suits); i++ {
				if (currSuit == suits[i]) {
					currSuitVal = i
				}
			}

			// check if already in deck
			for _, card := range thisDeck.cards {
				if card.rank == currRankVal && card.suit == currSuitVal {
					thisDeck.duplicateCard = card
				}
			}

			// add card to deck
			thisDeck.cards = append(thisDeck.cards, initCard(currRankVal, currSuitVal))

		}
	}

	return nil
}

func (thisDeck *Deck) toString() string {
	var list string

	for i := 1; i <= len(thisDeck.cards); i++ {

		list += thisDeck.cards[i - 1].toString()
		

		if (i == len(thisDeck.cards)) { break
		} else if ((i == 0 || i % 13 != 0) && !thisDeck.isImported) { list += ","
		} else if ((i == 0 || i % 5 != 0) && thisDeck.isImported) { list += ","
		} else {list += "\n"}
	}

	return list

}

func (thisDeck *Deck) drawCard() *Card {
	currCard := thisDeck.cards[0]
	thisDeck.cards = thisDeck.cards[1:]
	return currCard
}