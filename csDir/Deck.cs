using System;
using System.Collections.Generic;
using System.Linq;

// Define enums for Rank and Suit
public enum Rank {
    A, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, J, Q, K
}

public enum Suit {
    D, C, H, S
}

// Define Card class
public class Card {
    public Rank Rank { get; set; }
    public Suit Suit { get; set; }

    // Default constructor is card of lowest value in deck (AD)
    public Card() {
        Rank = Rank.A;
        Suit = Suit.D;
    }

    // Constructor with given rank and suit
    public Card(Rank rank, Suit suit) {
        Rank = rank;
        Suit = suit;
    }

    // Constructor given string rank and suit
    // Format of strings is as follows
    // rankSample = "R" // where 10 is "10" and not " 10"
    // suitSample = "s"
    public Card(string rankSample, string suitSample)  {
        Rank = ParseRank(rankSample);
        Suit = ParseSuit(suitSample);
    }

    // Getters for rank and suit
    public Rank GetRank() {
        return Rank;
    }

    public Suit GetSuit() {
        return Suit;
    }

    public Rank ParseRank(string rankParse) {
    
        // Converts string input to Rank.rank
        switch (rankParse) {
            case " A": return Rank.A; 
            case " 2": return Rank.TWO;
            case " 3": return Rank.THREE;
            case " 4": return Rank.FOUR;
            case " 5": return Rank.FIVE;
            case " 6": return Rank.SIX;
            case " 7": return Rank.SEVEN;
            case " 8": return Rank.EIGHT;
            case " 9": return Rank.NINE;
            case "10": return Rank.TEN;
            case " J": return Rank.J;
            case " Q": return Rank.Q; 
            case " K": return Rank.K; 
            default:  return Rank.K;
        }
    }

    public Suit ParseSuit(string suitParse) {
            
        // Converts string input to Suit.suit
        switch (suitParse) {
            case "D": return Suit.D;
            case "C": return Suit.C;
            case "H": return Suit.H;
            case "S": return Suit.S;
            default:  return Suit.D;
        }
    }

    public bool Equals(Card card) {
        return ((Rank == card.Rank) && (Suit == card.Suit));
    }

    public override string ToString() {
        // Uses switch cases to name cards in the format RS, rank suit
        string cardTitle = " ";

        switch (Rank) {
            case Rank.A:
                cardTitle += "A"; break;
            case Rank.TWO:
                cardTitle += "2"; break;
            case Rank.THREE:
                cardTitle += "3"; break;
            case Rank.FOUR:
                cardTitle += "4"; break;
            case Rank.FIVE:
                cardTitle += "5"; break;
            case Rank.SIX:
                cardTitle += "6"; break;
            case Rank.SEVEN:
                cardTitle += "7"; break;
            case Rank.EIGHT:
                cardTitle += "8"; break;
            case Rank.NINE:
                cardTitle += "9"; break;
            case Rank.TEN:
                cardTitle += "10"; break;
            case Rank.J:
                cardTitle += "J"; break;
            case Rank.Q:
                cardTitle += "Q"; break;
            case Rank.K:
                cardTitle += "K"; break;
        }

        switch (Suit) {
            case Suit.D:
                cardTitle += "D"; break;
            case Suit.C:
                cardTitle += "C"; break;
            case Suit.H:
                cardTitle += "H"; break;
            case Suit.S:
                cardTitle += "S"; break;
        }

        return cardTitle;
    }
}

// Define Deck class
public class Deck {
    private List<Card> cards = new List<Card>();

    public Deck() {
        // Make deck
        foreach (Suit suit in Enum.GetValues(typeof(Suit))) {
            foreach (Rank rank in Enum.GetValues(typeof(Rank))) {
                cards.Add(new Card(rank, suit));
            }
        }
        // Shuffle deck
        Shuffle();
    }

    public void PrintDeck() {
        int i = 0;

        if (cards.Count == 52) {
            foreach (Card card in cards) {
                Console.Write(card.ToString());
                i++;
                if (i % 13 == 0) {
                    Console.Write("\n");
                }
            }
        }
        else {
            foreach (Card card in cards) {
                Console.Write(card.ToString());
            }
        }
    }

    public Card DealCard() {
        if (cards.Any()) {
            Card card = cards.Last();
            cards.RemoveAt(cards.Count - 1);
            return card;
        } else return null;
    }

    private void Shuffle() {
        Random rng = new Random();
        int n = cards.Count;
        while (n > 1) {
            n--;
            int k = rng.Next(n + 1);
            Card value = cards[k];
            cards[k] = cards[n];
            cards[n] = value;
        }
    }
}
