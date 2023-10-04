#include <iostream>
#include <fstream>
#include <vector>
#include <string>
//#include "Deck.h"
#include "HandAlyzer.h"

using namespace std;

void importDeck(const string& fileName, Card hands[][5]);
void printHands(const Card hands[][5]);

int main(int argc, char* argv[]) {
    bool gameMode = true;  // true = Random, false = PreFab Deck
    string fileName = " ";

    if (argc > 1) {
        gameMode = false;
        fileName = argv[1];
    }

    Card hands[6][5];

    cout << "*** P O K E R  H A N D  A N A L Y Z E R ***\n\n\n";

    if (gameMode) {
        cout << "*** USING RANDOMIZED DECK OF CARDS ***\n\n"
             << "*** Shuffled 52 card deck:" << endl;
        Deck deck;
        deck.printDeck();

        for (int playerIndex = 0; playerIndex < 6; playerIndex++){
          for (int i = 0; i < 5; i++) {
              hands[playerIndex][i] = deck.dealCard();
          }
        }
      
        printHands(hands);

        cout << "\n*** Here is what remains in the deck..." << endl;
        deck.printDeck();
    } else {
        importDeck(fileName, hands);
        printHands(hands);
    }

    // Create analyzer to analyze the entire set of hands, then print results
    HandAlyzer analyzer(hands);
    cout << "\n";
    analyzer.getFinalScorePrint();

    return 0;
}

// Function to print hands
void printHands(const Card hands[6][5]) {
    cout << "\n*** Here are the six hands..." << endl;

    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 5; j++) {
            cout << hands[i][j].toString();
        }
        cout << endl;
    }
}

// Function to import a deck from a file
void importDeck(const string& fileName, Card hands[6][5]) {
    cout << "*** USING TEST DECK ***" << endl;
    cout << "*** File: " << fileName << endl;

    // Vector to store cards after construction
    vector<Card> importedCards;
    // Duplication check variables
    bool duplicateCardBool = false;
    string duplicateCardStr = "";

    ifstream input(fileName);

    string line;

    while (getline(input, line)) {
        cout << line << endl;
        string::size_type pos = 0;
        while (pos < line.length() - 1) {
            string rankParse = line.substr(pos, 2);
            pos += 2;
            string suitParse = line.substr(pos, 1);
            pos += 2;
            
            Card inputCard(rankParse, suitParse); 
            
//            //Debugging tests 
//            cout << rankParse << "_" << suitParse << endl;
//            inputCard.toString(); 
//            //Debugging tests
            
            // Check for duplicates pt1, if found return dupCardBool true
            for (Card checkCard : importedCards) {
                if (checkCard.equals(inputCard)) {
                    duplicateCardBool = true;
                    duplicateCardStr = inputCard.toString();
                }
            }

            // Add card to queue
            importedCards.push_back(inputCard);
        }
    }

    // Check for duplicates pt2
    if (duplicateCardBool) {
        cout << "*** ERROR - DUPLICATED CARD FOUND IN DECK ***" << endl;
        cout << "*** DUPLICATE: " << duplicateCardStr << " ***" << endl;
        exit(1);
    }

    // Deal cards to players from importedCards Queue
    // For each 6 players, fills all 5 slots with a card then goes to the next player
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 5; j++) {
            hands[i][j] = importedCards[j + (i * 5)];
        }
    }
}

