#pragma once
#include <iostream>
#include <algorithm>
#include <sstream>
#include <iomanip>
#include "Deck.h"

using namespace std;

// Define enums for hand ranks
enum HandRank {
        HIGH_CARD, PAIR, TWO_PAIR, THREE_OF_A_KIND, STRAIGHT,
        FLUSH, FULL_HOUSE, FOUR_OF_A_KIND, STRAIGHT_FLUSH, ROYAL_STRAIGHT_FLUSH
    };

// Class declarations
class HandAlyzer {
public:
    // For storing all the players hands
    Card hands[6][5];
    // For storing hands into player1-6 hands#
    Card hand1[5];
    Card hand2[5];
    Card hand3[5];
    Card hand4[5];
    Card hand5[5];
    Card hand6[5];

    // For storing all players scores
    int scoreKeeperAll[6][7];
    // For storing scores into player1-6 hands#
    int scoreKeeperP1[7]; 
    int scoreKeeperP2[7]; 
    int scoreKeeperP3[7]; 
    int scoreKeeperP4[7]; 
    int scoreKeeperP5[7]; 
    int scoreKeeperP6[7]; 
    
    // For storing each players resulting hand rank
    HandRank playerHandRanks[6];

    //Constructor, requires deck of hands[6][5]
    HandAlyzer(Card handsImport[][5]);

    //Methods
    string handRanktoString(HandRank rank);
    int handRanktoInt(HandRank rank);
    void getFinalScorePrint();
    HandRank getHandRank(Card hand[5], int scoreKeeper[7]);
    Card getHighCard(Card playerHand[5], int scoreKeeper[7]);
    void getHighCardTieBreakers(Card hand[5], int scoreKeeper[7]);
    bool isStraight(Card hand[5], int scoreKeeper[7]);
    bool isFlush(Card hand[5], int scoreKeeper[7]);
    bool isStraightFlush(Card hand[5], int scoreKeeper[7]);
    bool isStraightRoyalFlush(Card hand[5], int scoreKeeper[7]);
    bool isStraightRoyal(Card hand[5], int scoreKeeper[7]);
    int numOfPairs(Card hand[5], int scoreKeeper[7]);
    bool isThreeOfAKind(Card hand[5], int scoreKeeper[7]);
    bool isFullHouse(Card hand[5], int scoreKeeper[7]);
    bool isFourOfAKind(Card hand[5], int scoreKeeper[7]);
    void swapHands(int player1, int player2, string handStrings[6]);

};
