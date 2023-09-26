#include <iostream>
#include <vector>
#include <algorithm>
#include <random>
#include <ctime>

using namespace std;

//---------------------//
//Define enums for cards
enum class Rank {
    A, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, J, Q, K

};

enum class Suit {
    D, C, H, S

};

//--------------------------------------------------------------------//
//Start of Card class
class Card {
public:
    Rank rank;
    Suit suit;


    //CONSTRUCTORS---------//
    //Default constructor is card of lowest value in deck (AD)
    Card() : rank(Rank::A), suit(Suit::D) {}

    //Constructor with given rank and suit
    Card(Rank rank, Suit suit) : rank(rank), suit(suit) {}

    //Constructor given string rank and suit
    //Format of strings is as follows
    //rankSample = " R" // where 10 is "10" and not " 10"
    //suitSample = "s"
    Card(string rankSample, string suitSample) 
    : rank(parseRank(rankSample)), suit(parseSuit(suitSample)) {}
   
    //Getters & Setters----//
    Rank getRank() const {
        return rank;
    }

    Suit getSuit() const {
        return suit;
    }

    //Methods--------------//
    Rank parseRank(string rankParse) const {
    // Converts string input to Rank::rank
    if (rankParse == " A") return Rank::A;
    else if (rankParse == " 2") return Rank::TWO;
    else if (rankParse == " 3") return Rank::THREE;
    else if (rankParse == " 4") return Rank::FOUR;
    else if (rankParse == " 5") return Rank::FIVE;
    else if (rankParse == " 6") return Rank::SIX;
    else if (rankParse == " 7") return Rank::SEVEN;
    else if (rankParse == " 8") return Rank::EIGHT;
    else if (rankParse == " 9") return Rank::NINE;
    else if (rankParse == "10") return Rank::TEN;
    else if (rankParse == " J") return Rank::J;
    else if (rankParse == " Q") return Rank::Q;
    else if (rankParse == " K") return Rank::K;
    else return Rank::A;
    }

  //------------------------------------------------//
    Suit parseSuit(string suitParse) const {
    // Converts string input to Suit.suit
    if (suitParse == "D") return Suit::D;
    else if (suitParse == "C") return Suit::C;
    else if (suitParse == "H") return Suit::H;
    else if (suitParse == "S") return Suit::S;
    else return Suit::D;
    }

  //------------------------------------------------//
    bool equals(const Card& card) const {
        return (rank == card.rank && suit == card.suit);
    }

  //------------------------------------------------//
    string toString() const {
    // Uses switch cases to name cards in the format RS, rank suit
        string cardTitle = " ";

        switch (rank) {
        case Rank::A:
            cardTitle += "A";
            break;
        case Rank::TWO:
            cardTitle += "2";
            break;
        case Rank::THREE:
            cardTitle += "3";
            break;
        case Rank::FOUR:
            cardTitle += "4";
            break;
        case Rank::FIVE:
            cardTitle += "5";
            break;
        case Rank::SIX:
            cardTitle += "6";
            break;
        case Rank::SEVEN:
            cardTitle += "7";
            break;
        case Rank::EIGHT:
            cardTitle += "8";
            break;
        case Rank::NINE:
            cardTitle += "9";
            break;
        case Rank::TEN:
            cardTitle += "10";
            break;
        case Rank::J:
            cardTitle += "J";
            break;
        case Rank::Q:
            cardTitle += "Q";
            break;
        case Rank::K:
            cardTitle += "K";
            break;
        }

        switch (suit) {
        case Suit::D:
            cardTitle += "D";
            break;
        case Suit::C:
            cardTitle += "C";
            break;
        case Suit::H:
            cardTitle += "H";
            break;
        case Suit::S:
            cardTitle += "S";
            break;
        }
            return cardTitle;
    }
};

//--------------------------------------------------------------------//
//Start of Deck Class
class Deck {
public:
    vector<Card> cards;


    Deck() {
        // Make deck
        for (Suit suit : {Suit::D, Suit::C, Suit::H, Suit::S}) {
            for (Rank rank : {Rank::A, Rank::TWO, Rank::THREE, Rank::FOUR, Rank::FIVE, Rank::SIX, Rank::SEVEN, Rank::EIGHT, Rank::NINE, Rank::TEN, Rank::J, Rank::Q, Rank::K}) {
                cards.push_back(Card(rank, suit));
            }
        }
        // Shuffle deck 
        // Get the current time in seconds since the Unix epoch
        time_t current_time = std::time(nullptr);

        // Seed srand with the current time
        srand(current_time);
        random_shuffle(cards.begin(), cards.end());
    }

    void printDeck() const {
        int i = 0;

        if (cards.size() == 52) {
            for (Card card : cards) {
                cout << card.toString();
                i++;
                if ((i % 13 == 0)) {
                    cout << "\n";
                }
            }
        }
        else {
            for (Card card : cards) {
                cout << card.toString() << " ";
            }
        }
    }

    Card dealCard() {
        if (!cards.empty()) {
            Card topCard = cards.back();
            cards.pop_back();
            return topCard;
        }
        return Card(); // Return a default card if the deck is empty
    }
};
// End of Deck class
//--------------------------------------------------------------------//
