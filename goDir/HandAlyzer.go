package main

import (
	"sort"
)

// // PlayerHand
// contains info of players hand/score
type Hand struct {
	cards []*Card
	sortedCards []*Card
	scoreKeeper []int // below is each value explained
	handScore int
}

// 

// // initHand
// Initializes a new hand
func initHand() *Hand {
	return &Hand {
		cards : make([]*Card, 0),
		sortedCards : make([]*Card, 0),
		scoreKeeper : make([]int, 0),
		handScore : 0,
	}
}

// // addCard
// adds given card to hand
func (thisHand *Hand) addCard(card *Card) {
	thisHand.cards = append(thisHand.cards, card)
}


// // toString
// returns string "hand - hand rank"
func (thisHand *Hand) toString() string {
	handRanks := []string{
		"Royal Straight Flush",
		"Straight Flush",
		"Four of a Kind",
		"Full House",
		"Flush",
		"Straight",
		"Three of a Kind",
		"Two Pair",
		"Pair",
		"High Card",
	}	
	list := ""

	for i := 1; i <= len(thisHand.cards); i++ {
		list += " "
		list += thisHand.cards[i - 1].toString() 
	}

	if thisHand.handScore == 0 { return list
	} else {
		list += handRanks[(9 - thisHand.handScore)]
	}

	return list
}


// // compare
// Compares otherHand (O) to hand calling func (T)
// returns int, (-#: T < O) (0: T = O) (+#: T > O)
func (thisHand *Hand) compare(otherHand *Hand) int {
	thisHand.scoreHand()
	otherHand.scoreHand()

	breakerDiff := thisHand.handScore - otherHand.handScore

	return thisHand.tieBreak(otherHand, breakerDiff, 1)
}


// // tieBreak
// function repeats until winner of two hands
// is determined. 
func (thisHand *Hand) tieBreak(otherHand *Hand, breakerDiff int, pass int) int {
	if (breakerDiff != 0 || pass >= len(thisHand.scoreKeeper)) { return breakerDiff }

	thisBreaker := thisHand.scoreKeeper[pass]
	otherBreaker := otherHand.scoreKeeper[pass]

	breakerDiff = thisBreaker - otherBreaker
	

	if (breakerDiff == 0) {
		return thisHand.tieBreak(otherHand, breakerDiff, pass + 1)
	}

	return breakerDiff
}


// // scoreHand
// returns int of hand's value
func (thisHand *Hand) scoreHand() {
	thisHand.sortHand()

	if (thisHand.isRoyalStraightFlush()) {
		thisHand.handScore = 10
	} else if (thisHand.isStraightFlush()) {
		thisHand.handScore = 9
	} else if (thisHand.isFourOfAKind()) {
		thisHand.handScore = 8
	} else if (thisHand.isFullHouse()) {
		thisHand.handScore = 7
	} else if (thisHand.isFlush()) {
		thisHand.handScore = 6
	} else if (thisHand.isStraight()) {
		thisHand.handScore = 5
	} else if (thisHand.isThreeOfAKind()) {
		thisHand.handScore = 4
	} else if (thisHand.isTwoPair()) {
		thisHand.handScore = 3
	} else if (thisHand.isPair()) {
		thisHand.handScore = 2
	} else { thisHand.handScore = 1}

	thisHand.scoreKeeper[0] = thisHand.handScore
}


// // isRoyalStraightFlush
// returns true bool if rsf
func (thisHand *Hand) isRoyalStraightFlush() bool {
	rankList := thisHand.getRankList()

	if ( thisHand.isStraightFlush() && rankList[0] == 10 && rankList[4] == 14) {
		thisHand.scoreKeeper[6] = thisHand.cards[0].suit
		return true
	} 

	return false
}


// // isStraightFlush
// returns true bool if sf
func (thisHand *Hand) isStraightFlush() bool {
	if (thisHand.isStraight() && thisHand.isFlush()) {
		return true
	}

	return false
}

// // isFlush
// returns true bool if flush
func (thisHand *Hand) isFlush() bool {
	suitOccurences := thisHand.suitOccurencesList()

	for i := 0; i < 4; i++ {
		if suitOccurences[i] == 5 {
			return true
		}
	}

	return false
}


// // isStraight
// returns true bool if straight
func (thisHand *Hand) isStraight() bool {
	rankList := thisHand.getRankList()

	if rankList[4] == 14 && rankList[0] == 2 {
		rankList[4] = 1
		sort.Ints(rankList)
	}

	for i := 0; i < 4; i++ {
		if rankList[i+1] != rankList[i]+1 {
			return false
		}
	}

	return true
}

// // isFullHouse
// returns true bool if FH
func (thisHand *Hand) isFullHouse() bool {
	rankList := thisHand.getRankList()

	if ((rankList[0] == rankList[1] && rankList[2] == rankList[4]) ||
		(rankList[0] == rankList[2] && rankList[3] == rankList[4])) {
		return true
	}

	return false
}


// // isFourOfAKind
// returns true bool if FoaK
func (thisHand *Hand) isFourOfAKind() bool {
	rankList := thisHand.rankOccurencesList()

	for i := 0; i < len(rankList); i++ {
		if (rankList[i] == 4) {
			return true
		}
	}

	return false
}


// // isThreeOfAKind
// returns true bool if ToaK
func (thisHand *Hand) isThreeOfAKind() bool {
	rankList := thisHand.rankOccurencesList()

	for i := 0; i < len(rankList); i++ {
		if (rankList[i] == 3) {
			return true
		}
	}

	return false
}


// // isTwoPair
// returns true bool if two pairs
func (thisHand *Hand) isTwoPair() bool {
	rankList := thisHand.rankOccurencesList()

	pairOne := 0
	pairTwo := 0
	pairOneFound := false
	pairTwoFound := false
	kickerRank := 0

	for i := 0; i < len(rankList); i++ {
		if (rankList[i] == 2) {
			if (pairOneFound) {
				pairTwoFound = true
				pairTwo = i
			} else {
				pairOneFound = true
				pairOne = i
			}
		} else if (rankList[i] == 1) {
			kickerRank = i
		}

	}

	if (pairTwoFound) {
		thisHand.scoreKeeper[1] = pairTwo
		thisHand.scoreKeeper[2] = pairOne
		thisHand.scoreKeeper[3] = kickerRank
		return true
	}

	return false
}


// // isPair
// returns true bool if a pair
func (thisHand *Hand) isPair() bool {
	rankList := thisHand.getRankList()
	pairRank := 0
	notPairInd := 0

	for i := 0; i < 4; i++ {
		if rankList[i] == rankList[i+1] {
			thisHand.scoreKeeper[1] = rankList[i]
			pairRank = rankList[i]
			thisHand.scoreKeeper[1] = pairRank
			return true
		} else {
			thisHand.scoreKeeper[5 - notPairInd] = rankList[i]
			notPairInd += 1 
		}
	}

	return false
}

// // getRankList
// returns a sorted list of hands rank values
func (thisHand *Hand) getRankList() []int {
	rankList := make([]int, 0)

	for i := 0; i < len(thisHand.cards); i++ {
		rankList = append(rankList, thisHand.cards[i].rank)
	}

	sort.Ints(rankList)

	return rankList;
}

// // rankOccurencesList
// returns an array with the number
// of times each rank occurs, where
// index = card rank ([0,1] are empty)
func (thisHand *Hand) rankOccurencesList() []int {
	var occList [15]int

	for i := 0; i < len(thisHand.cards); i++ {
		cardRank := thisHand.cards[i].rank	
		occList[cardRank] += 1
	}

	return occList[:];
}

// // suitOccurencesList
// returns an array with the number
// of times each suit occurs, where
// index = card suit 
func (thisHand *Hand) suitOccurencesList() []int {
	var occList [4]int

	for i := 0; i < len(thisHand.cards); i++ {
		cardSuit := thisHand.cards[i].suit	
		occList[cardSuit] += 1
	}

	return occList[:];
}

// Sets the sorted instance variable to a sorted version of a provided hand.
func (thisHand *Hand) sortHand() {

	for i := 0; i < 5; i++ {
		thisHand.sortedCards = append(thisHand.sortedCards, initCard(thisHand.cards[i].rank, thisHand.cards[i].suit))
	}
	
	for j := 0; j < 4; j++ {
		for i := 0; i < 4; i++ {
			if thisHand.sortedCards[i].compareCards(thisHand.sortedCards[i + 1]) > 0 {
				temp := initCard(thisHand.sortedCards[i + 1].rank, thisHand.sortedCards[i + 1].suit)
				thisHand.sortedCards[i + 1] = thisHand.sortedCards[i]
				thisHand.sortedCards[i] = temp
			}
		}
	}
}