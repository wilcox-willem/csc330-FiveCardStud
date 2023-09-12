import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

//------------------------------------------------//
// Define enums for Rank and Suit
enum Rank {
	A, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, J, Q, K
}

enum Suit {
	D, C, H, S
}

//--------------------------------------------------------------------//
// Define Card subclass
class Card {
	public Rank rank;
	public Suit suit;

	//Default constructor is card of lowest value in deck (AD)
	public Card() {
		this.rank = Rank.A;
		this.suit = Suit.D;
	}

	//Constructor with given rank and suit
	public Card(Rank rank, Suit suit) {
		this.rank = rank;
		this.suit = suit;
	}

	//Constructor given string rank and suit
	//Format of strings is as follows
	//rankSample = " R" // where 10 is "10" and not " 10"
	//suitSample = "s"
	public Card(String rankSample, String suitSample) {
		this.rank = parseRank(rankSample);
		this.suit = parseSuit(suitSample);
	}

	//------------------------------------------------//
	//Getters for rank and suit
	public Rank getRank() {
		return this.rank;
	}

	public Suit getSuit() {
		return this.suit;
	}

	//------------------------------------------------//
	public Rank parseRank(String rankParse) {
		//Converts string input to Rank.rank
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
		case " Q": return Rank.K;
		case " K": return Rank.Q;
		default: return null;
		}
	}
	//------------------------------------------------//
	public Suit parseSuit(String suitParse) {
		//Converts string input to Suit.suit
		switch (suitParse) {
		case "D": return Suit.D;
		case "C": return Suit.C;
		case "H": return Suit.H;
		case "S": return Suit.S;
		default: return null;
		}
	}
	//------------------------------------------------//
	public boolean equals(Card card) {
		if ((this.rank == card.rank) && (this.suit == card.suit)) {
			return true;
		}
		else return false;
	}
	//------------------------------------------------//
	@Override
	public String toString() {
		//Uses switch cases to name cards in the format RS, rank suit
		String cardTitle = " ";

		switch (this.rank) {
		case A:
			cardTitle += "A"; break;
		case TWO:
			cardTitle += "2"; break;
		case THREE:
			cardTitle += "3"; break;
		case FOUR:
			cardTitle += "4"; break;
		case FIVE:
			cardTitle += "5"; break;
		case SIX:
			cardTitle += "6"; break;
		case SEVEN:
			cardTitle += "7"; break;
		case EIGHT:
			cardTitle += "8"; break;
		case NINE:
			cardTitle += "9"; break;
		case TEN:
			cardTitle += "10"; break;
		case J:
			cardTitle += "J"; break;
		case Q:
			cardTitle += "Q"; break;
		case K:
			cardTitle += "K"; break;
		}

		switch (this.suit) {
		case D:
			cardTitle += "D"; break;
		case C:
			cardTitle += "C"; break;
		case H:
			cardTitle += "H"; break;
		case S:
			cardTitle += "S"; break;

		}

		return cardTitle;
	}
}
//End of Card subclass
//--------------------------------------------------------------------//
//Define Deck class
public class Deck {
	private List<Card> cards = new ArrayList<>();

	public Deck() {
		//Make deck
		for (Suit suit : Suit.values()) {
			for (Rank rank : Rank.values()) {
				cards.add(new Card(rank, suit));
			}
		}
		//Shuffle deck
		Collections.shuffle(cards, new Random());
	}


	//------------------------------------------------//	

	public void printDeck() {
		int i = 0;

		if (this.cards.size() == 52) {
			for (Card card : cards) {
				System.out.print(card.toString());
				i++;
				if ((i % 13 == 0)) {
					System.out.print("\n");
				}
			}
		}  
		else {
			for (Card card : cards) {
				System.out.print(card.toString());
			}
		}
	}

	//------------------------------------------------//

	public Card dealCard() {
		if (!cards.isEmpty()) {
			return cards.remove(cards.size() - 1);
		}
		return null;
	}

}
//End of Deck class
//--------------------------------------------------------------------//
