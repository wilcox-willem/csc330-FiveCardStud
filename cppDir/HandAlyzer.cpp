#include <iostream>
#include <algorithm>
#include <sstream>
#include <iomanip>
#include "HandAlyzer.h"



using namespace std;


// implement the HandAlyzer class

//---------------------------------------------------------//
//Data implementation

    
    //For tracking win and tie breaking info
    //The following are what each index is used for
    //[0] = HandRank //denoted as 0 (high card)) -> 9 (R straight flush)
    //[1] = Highest Rank card (or highest Rank of pair)
    //[2] = 2nd highest Rank card (if needed, else 0)
    //[3] = 3rd highest Rank card (if needed, else 0)
    //[4] = 4th highest Rank card (if needed, else 0)
    //[5] = 5th highest Rank card (if needed, else 0)
    //[6] = Suit of card in [1] // denoted as (0, D) (1, C) (2, H) (3, S)

    int scoreKeeperAll[6][7] = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0},
                                {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}
                            };

    // Constructor
    HandAlyzer::HandAlyzer(Card handsImport[][5]) {
        //Can only be constructed with [6 player hands][5 Cards a hand]

        //update players1-6 hands#[]
        for (int i = 0; i < 5; i++) {
            hand1[i] = handsImport[0][i];
            hand2[i] = handsImport[1][i];
            hand3[i] = handsImport[2][i];
            hand4[i] = handsImport[3][i];
            hand5[i] = handsImport[4][i];
            hand6[i] = handsImport[5][i];


        }
        //update master hands[][]
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 5; j++){
                hands[i][j] = handsImport[i][j];
            }
        }
    }
//---------------------------------------------------------//
//Methods

    //Converts HandRank enum to string
    string HandAlyzer::handRanktoString(HandRank rank) { 
        string rankString = "";
        switch (rank) {
            case HIGH_CARD: rankString += "High Card"; break;
            case PAIR: rankString += "Pair"; break;
            case TWO_PAIR: rankString += "Two Pair"; break;
            case THREE_OF_A_KIND: rankString += "Three of a Kind"; break;
            case STRAIGHT: rankString += "Straight"; break;
            case FLUSH: rankString += "Flush"; break;
            case FULL_HOUSE: rankString += "Full House"; break;
            case FOUR_OF_A_KIND: rankString += "Four of a Kind"; break;
            case STRAIGHT_FLUSH: rankString += "Straight Flush"; break;
            case ROYAL_STRAIGHT_FLUSH: rankString += "Royal Straight Flush"; break;
        }
        return rankString;
    }

    //Converts HandRank enum to int
    int HandAlyzer::handRanktoInt(HandRank rank) { 
        int rankInt = 0;
        switch (rank) {
            case HIGH_CARD: rankInt = 0; break;
            case PAIR: rankInt = 1; break;
            case TWO_PAIR: rankInt = 2; break;
            case THREE_OF_A_KIND: rankInt = 3; break;
            case STRAIGHT: rankInt = 4; break;
            case FLUSH: rankInt = 5; break;
            case FULL_HOUSE: rankInt = 6; break;
            case FOUR_OF_A_KIND: rankInt = 7; break;
            case STRAIGHT_FLUSH: rankInt = 8; break;
            case ROYAL_STRAIGHT_FLUSH: rankInt = 9; break;
        }
        return rankInt;
    }



    //------------------------------------------------//
    void HandAlyzer::getFinalScorePrint() {
        string handStrings[6];

        //Get hand rank and build strings for printing
        for (int i = 0; i < 6; i++) {
            int scoreKeeper[7] = {0};
            HandRank rank = getHandRank(hands[i], scoreKeeper);
            playerHandRanks[i] = rank;
            scoreKeeper[0] = handRanktoInt(rank);

            //updates master scoreKeeper
            for (int j = 0; j < 7; j++){
                scoreKeeperAll[i][j] = scoreKeeper[j]; 
            }

            //Build out Hands to print, stored in order of players 1->6
            stringstream handStringStream;
            for (int j = 0; j < 5; j++) {
                handStringStream << setw(4) << hands[i][j].toString();
            }
            
            // //DEBUGGING: Adds on to print statement to show scoreKeeper values
            // for (int j = 0; j < 7; j++) {
            //     if (scoreKeeper[j] < 10){
            //         handStringStream << " [0" << scoreKeeper[j] << "] ";
            //     } 
            //     else {handStringStream << " [" << scoreKeeper[j] << "] ";}
            // }
            // //DEBUGGING: End.

            handStrings[i] = handStringStream.str();
        }

        ////Sort out winners and implement tie breaking via bubblesorting
        for (int playerRankIndexLimit = 0; playerRankIndexLimit < 6 ;  playerRankIndexLimit++){
            for(int currentPlayer = 0; currentPlayer < 5; currentPlayer++){
                if (scoreKeeperAll[currentPlayer][0] < scoreKeeperAll[currentPlayer + 1][0]){
                    swapHands(currentPlayer, currentPlayer + 1, handStrings);
                } 
                //Tie Breaking
                else if (scoreKeeperAll[currentPlayer][0] == scoreKeeperAll[currentPlayer + 1][0]){
                    for (int criteriaIndex = 1; criteriaIndex < 7; criteriaIndex++){
                        if(scoreKeeperAll[currentPlayer][criteriaIndex] < scoreKeeperAll[currentPlayer + 1][criteriaIndex]){
                            swapHands(currentPlayer, currentPlayer + 1, handStrings);
                            break;

                        } else if (scoreKeeperAll[currentPlayer][criteriaIndex] > scoreKeeperAll[currentPlayer + 1][criteriaIndex]){
                            break;
                        }
                    }
                }
            }
        }

        //Print the sorted hands with their ranks
        cout << "--- WINNING HAND ORDER ---" << endl;
        for (int i = 0; i < 6; i++) {
            cout << handStrings[i] << " - " << handRanktoString(playerHandRanks[i]) << endl;
        }

    }
    //-------------------
    // Helper method to swap hands and corresponding data
    void HandAlyzer::swapHands(int player1, int player2, string handStrings[]) {
        
        //Swaps scoreKeeper[p1] and [p2]
        for (int i = 0; i < 7; i++){
            int tempScoreKeeper = scoreKeeperAll[player1][i];
            scoreKeeperAll[player1][i] = scoreKeeperAll[player2][i];
            scoreKeeperAll[player2][i] = tempScoreKeeper;
        }

        HandRank tempRank = playerHandRanks[player1];
        playerHandRanks[player1] = playerHandRanks[player2];
        playerHandRanks[player2] = tempRank;
        
        string tempHand = handStrings[player1];
        handStrings[player1] = handStrings[player2];
        handStrings[player2] = tempHand;
    }
    //------------------------------------------------//
    HandRank HandAlyzer::getHandRank(Card hand[], int scoreKeeper[]) {
        //Checks one hand of 5 cards for its HandRank
        //Currently, assigns High Card if no other HandRank fits, then
        //uses getHighCardTieBreakers to determine ties
        //...
        //Other methods have independent means to adjust scoreKeeper
        //to suit the needs for tie breaking of equal strength hands

        if (isStraightRoyalFlush(hand, scoreKeeper)) {
            scoreKeeper[0] = 9;
            return ROYAL_STRAIGHT_FLUSH;
        } else if (isStraightFlush(hand, scoreKeeper)) {
            scoreKeeper[0] = 8;
            return STRAIGHT_FLUSH;
        } else if (isFourOfAKind(hand, scoreKeeper)) {
            scoreKeeper[0] = 7;
            return FOUR_OF_A_KIND;
        } else if (isFullHouse(hand, scoreKeeper)) {
            scoreKeeper[0] = 6;
            return FULL_HOUSE;
        } else if (isFlush(hand, scoreKeeper)) {
            scoreKeeper[0] = 5;
            return FLUSH;
        } else if (isStraight(hand, scoreKeeper)) {
            scoreKeeper[0] = 4;
            return STRAIGHT;
        } else if (isThreeOfAKind(hand, scoreKeeper)) {
            scoreKeeper[0] = 3;
            return THREE_OF_A_KIND;
        } else if (numOfPairs(hand, scoreKeeper) == 2) {
            scoreKeeper[0] = 2;
            return TWO_PAIR;
        } else if (numOfPairs(hand, scoreKeeper) == 1) {
            scoreKeeper[0] = 1;
            return PAIR;
        } else if (scoreKeeper[0] == 0) {
            getHighCard(hand, scoreKeeper);
            getHighCardTieBreakers(hand, scoreKeeper);
        }       
        return HIGH_CARD;
    }

    //------------------------------------------------//
    //Hand Rank Identifiers---------------------------//
    //------------------------------------------------//
    bool HandAlyzer::isStraight(Card hand[], int scoreKeeper[]) {
        int ranks[5] = {0};
        Card highestCard;

        for (int i = 0; i < 5; i++) {
            ranks[i] = hand[i].getRankInt();

            if (hand[i].getRankInt() > highestCard.getRankInt()) {
                highestCard = hand[i];
            }
        }

        sort(ranks, ranks + 5);

        if (isStraightRoyal(hand, scoreKeeper)) {
            return true;
        } else {
            for (int i = 0; i < 4; i++) {
                if (ranks[i] + 1 != ranks[i + 1]) {
                    return false;
                }
            }
        }

        getHighCard(hand, scoreKeeper);
        return true;
    }

    //------------------------------------------------//
    bool HandAlyzer::isFlush(Card hand[], int scoreKeeper[]) {
        for (int i = 0; i < 4; i++) {
            if (hand[i].getSuitInt() != hand[i + 1].getSuitInt()) {
                return false;
            }
        }
        getHighCard(hand, scoreKeeper);
        getHighCardTieBreakers(hand, scoreKeeper);
        return true;
    }

    //------------------------------------------------//
    //This method does NOT account for wrap around flushes!
    bool HandAlyzer::isStraightFlush(Card hand[], int scoreKeeper[]) {
        return (isFlush(hand, scoreKeeper) && isStraight(hand, scoreKeeper));                                                                                                                                                                                
    }

    //------------------------------------------------//
    bool HandAlyzer::isStraightRoyalFlush(Card hand[], int scoreKeeper[]) {
        int loopCounter = 0;
        int countsPerRank[13] = {0};
        int suitPerCard[5] = {0};
        //Array with hard coded rank values of A, 10, J, Q, K
        int cardsToCheck[5] = {0, 9, 10,
                              11, 12};

         for (int i = 0; i < 5; i++) {
            Card card = hand[i];
            countsPerRank[card.getRankInt()] += 1;
            suitPerCard[loopCounter] = card.getSuitInt();
            loopCounter++;
        }
        for (int i : cardsToCheck) {
            if (countsPerRank[i] != 1) {
                return false;
            }
        }

        for (int i = 0; i < 4; i++) {
            if (suitPerCard[i] != suitPerCard[i + 1]) {
                return false;
            }
        }
        
        scoreKeeper[6] = hand[0].getSuitInt();        
        return true;
    }

    //------------------------------------------------//
    //To solve edge case where (non-flush, royal) Straights were not identified
    //Catches straights in order of "10, J, Q, K, A" not caught by isStraight
    bool HandAlyzer::isStraightRoyal(Card hand[], int scoreKeeper[]) {
        int countsPerRank[13] = {0};
        //Array with hard coded int values for A, 10, J, Q, K
        int cardsToCheck[5] = {0, 9, 10,
                              11, 12};
        int aceSuit = 0;

         for (int i = 0; i < 5; i++) {
            Card card = hand[i];
            countsPerRank[card.getRankInt()] += 1;
            if (card.getRankInt() == 0) aceSuit = card.getSuitInt();                
        }

        for (int i : cardsToCheck) {
            if (countsPerRank[i] != 1) {
                return false;
            }
        }

        scoreKeeper[1] = 14; //Ace High value hard coded, since it will be in every SRF
        scoreKeeper[6] = aceSuit;       
        return true;
    }
    //------------------------------------------------//
    //Returns int for num of pairs, unlike rest returning bool!
    int HandAlyzer::numOfPairs(Card hand[], int scoreKeeper[]) {
        int numofPairs = 0;
        int iterator = 0;
        int kickerRank = 0;
        int rankofPair[2];
        int countsPerRank[13] = {0};

        for (int i = 0; i < 5; i++) {
            countsPerRank[hand[i].getRankInt()] += 1;
        }

        for (int i = 0; i < 13; i++) {
            if (countsPerRank[i] == 2) {
                numofPairs++;
                //check for aces, make high
                if (i == 0){
                    rankofPair[iterator] = 14;
                } else rankofPair[iterator] = i;

                iterator++;
            }
            //updates kicker if no pair, always ends with highest non-pair's rank
            else if (countsPerRank[i] == 1) {
                kickerRank = i;
            }
        }

       

        if (numofPairs == 1) {
            //update scorekeeping if only 1 pair
            int ranks[5] = {0};
            for (int i = 0; i < 5; i++) {
                ranks[i] = hand[i].getRankInt();
                //For ties, ranks ace as highest value
                if (ranks[i] == 0){
                    ranks[i] = 14;
                }
            }

            sort(ranks, ranks + 5); //sorted [low to high]
            int sKIndex = 2; //scoreKeeper[sKIndex], [2]->[5] is the 2nd highest card -> lowest card

            //Reverses the array from [low to high], to, [high to low] when assigning values to scoreKeeper[]
            //Only assigns value if the rank does not match the pair
            for (int i = 4; i >= 0; i--) {
                if (ranks[i] != rankofPair[0]){
                    scoreKeeper[sKIndex] = ranks[i];
                    sKIndex++;
                }
            }
            
            //FINISHED UPDATE
            scoreKeeper[1] = rankofPair[0];

        } else if (numofPairs == 2) {
            scoreKeeper[1] = rankofPair[1]; //higher value pair first
            scoreKeeper[2] = rankofPair[0]; //lower value pair second
        }
        
        if (numofPairs > 0){
          //finds kicker card, then updates scorekeeper[6] with suit
          for (int i = 0; i < 5; i++) {
              Card card = hand[i];
              if (card.getRankInt() == kickerRank) {
                  scoreKeeper[6] = card.getSuitInt();
              }
          }
          
        }

        return numofPairs;
    }

    //------------------------------------------------//
    bool HandAlyzer::isThreeOfAKind(Card hand[], int scoreKeeper[]) {
        int countsPerRank[13] = {0};
        for (int i = 0; i < 5; i++) {
            Card card = hand[i];
            countsPerRank[card.getRankInt()] += 1;
        }

        for (int i = 0; i < 13; i++) {
            if (countsPerRank[i] == 3) {
                getHighCardTieBreakers(hand, scoreKeeper);
                getHighCard(hand, scoreKeeper);
                return true;
            }
        }
        return false;
    }

    //------------------------------------------------//
    bool HandAlyzer::isFullHouse(Card hand[], int scoreKeeper[]) {
        if (isThreeOfAKind(hand, scoreKeeper) && (numOfPairs(hand, scoreKeeper) == 1)) {
            getHighCard(hand, scoreKeeper);
            return true; 
        }
        return false;
    }

    //------------------------------------------------//
    bool HandAlyzer::isFourOfAKind(Card hand[], int scoreKeeper[]) {
        int countsPerRank[13] = {0};
        for (int i = 0; i < 5; i++) {
            Card card = hand[i];
            countsPerRank[card.getRankInt()]++;
        }

        for (int i = 0; i < 13; i++) {
            if (countsPerRank[i] == 4) {
                getHighCard(hand, scoreKeeper);
                return true;
            }
        }
        return false;
    }

    Card HandAlyzer::getHighCard(Card playerHand[5], int scoreKeeper[7]){
        Card highCard;
            bool isAce = false;
            for (int i = 0; i < 5; i++) {
                Card cardToBeChecked = playerHand[i];

                //check for aces, if found only looks for other possible aces to compare
                if (cardToBeChecked.getRankInt() == 0){
                    if (highCard.getRankInt() != 0){
                        highCard = cardToBeChecked;
                    } 
                    else if (cardToBeChecked.getSuitInt() > highCard.getSuitInt()){
                        highCard = cardToBeChecked;
                    }
                    isAce = true;
                }
                //else, find highest rank card
                else if (highCard.getRankInt() < cardToBeChecked.getRankInt())
                {
                    highCard = cardToBeChecked;
                }
                //if tied for rank, compare suit
                else if ((highCard.getRankInt() == cardToBeChecked.getRankInt()) 
                        && (highCard.getSuitInt() < cardToBeChecked.getSuitInt()))
                {
                    highCard = cardToBeChecked;
                }
    
            }   
    
            //Keeps Aces High for high card
            if (isAce){
                scoreKeeper[1] = 14;
            } else scoreKeeper[1] = highCard.getRankInt();
    
            scoreKeeper[6] = highCard.getSuitInt();
    
            return highCard;
    
    }


    void HandAlyzer::getHighCardTieBreakers(Card hand[5], int scoreKeeper[7]){
        int ranks[5];
        for (int i = 0; i < 5; i++) {
            ranks[i] = hand[i].getRankInt();
            
           // //DEBUGGING: check to see if hand[] is being passed in right
           // cout << " DEBUG DEBUG :: " << hand[i].getRankInt() << endl;
           // 
           
            //For tiebreaking later, ranks ace as highest value
            if (ranks[i] == 0){
                ranks[i] = 14;
            }
        }
        sort(ranks, ranks + 5); //sorted [low to high]
        int sKIndex = 2;

        //Assigns the scoreKeeper[][][3][2][1][0][]
        //Where 3-0 is:
        //ranks[3] ~ 2nd highest card, to , ranks[0] ~ lowest card
        for (int i = 3; i >= 0; i--) {
            scoreKeeper[sKIndex] = ranks[i];
            sKIndex++;
        }


    }
    //------------------------------------------------//