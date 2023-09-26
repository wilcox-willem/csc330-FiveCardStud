#include <vector>
#include <string>

using namespace std;

// Define enums for cards
enum class Rank {
    A, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, J, Q, K
};

enum class Suit {
    D, C, H, S
};

// Class declarations
class Card {
public:
    Rank rank;
    Suit suit;

    // Constructors
    Card();
    Card(Rank rank, Suit suit);
    Card(const string& rankSample, const string& suitSample);

    // Getters
    Rank getRank() const;
    Suit getSuit() const;

    // Methods
    Rank parseRank(const string& rankParse) const;
    Suit parseSuit(const string& suitParse) const;
    bool equals(const Card& card) const;
    string toString() const;
};

class Deck {
public:
    vector<Card> cards;

    Deck();

    void printDeck() const;
    Card dealCard();
};
