package wwClasses;

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

//------------------------------------------------//
// Define Card class
class Card {
	private final Rank rank;
	private final Suit suit;

	public Card(Rank rank, Suit suit) {
		this.rank = rank;
		this.suit = suit;
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

//------------------------------------------------//
// Define Deck class
public class Deck {
	private final List<Card> cards;

	public Deck() {
		cards = new ArrayList<>();
		createDeck();
		shuffleDeck();
	}

	//------------------------------------------------//	

	private void createDeck() {
		for (Suit suit : Suit.values()) {
			for (Rank rank : Rank.values()) {
				cards.add(new Card(rank, suit));
			}
		}
	}

	//------------------------------------------------//

	public void shuffleDeck() {
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

	//------------------------------------------------//

	public void checkForDuplicates() {
		Card[] temp = new Card[52];
		int index = 0;

		for (Card card : cards) {
			// Check if the card already exists in the temp array
			for (int i = 0; i < index; i++) {
				if (temp[i].equals(card)) {
					// Found a duplicate card
					System.out.println("*** ERROR - DUPLICATED CARD FOUND IN DECK ***"
							+ "\n\n*** DUPLICATE: " + card.toString() + " ***\n");	
				}
			}

			// Add the card to the temp array
			temp[index++] = card;
		}

	}
}