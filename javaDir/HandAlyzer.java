import java.util.Arrays;

public class HandAlyzer {

	enum HandRank {
		HIGH_CARD, PAIR, TWO_PAIR, THREE_OF_A_KIND, STRAIGHT,
		FLUSH, FULL_HOUSE, FOUR_OF_A_KIND, STRAIGHT_FLUSH, ROYAL_STRAIGHT_FLUSH;
	}

	//For importing all the hands
	Card[][] hands;
	//For splitting all hands into each players hand
	Card[] hand1 = new Card[5];
	Card[] hand2 = new Card[5];
	Card[] hand3 = new Card[5];
	Card[] hand4 = new Card[5];
	Card[] hand5 = new Card[5];
	Card[] hand6 = new Card[5];

	HandRank[] playerHandRanks = new HandRank[6];

	

	//Constructor ----------------------------------------//
	//Can only be constructed with [6 player hands][5 Cards a hand]
	public HandAlyzer(Card[][] hands) {
		this.hands = hands;
		for (int i = 0; i < 5; i++) {
			hand1[i] = hands[0][i];
			hand2[i] = hands[1][i];
			hand3[i] = hands[2][i];
			hand4[i] = hands[3][i];
			hand5[i] = hands[4][i];
			hand6[i] = hands[5][i];
		}
	}

	//Start of Methods------------------------------------------------//


	//------------------------------------------------//
	//Converts HandRank enum to String
	public String handRanktoString(HandRank rank) {
		String rankString = "";
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

	//------------------------------------------------//
	//Checks for the highest value card in a hand
	//First, by rank A,2,3,...Q,K (L -> H)
	//Then if a tie, by suit D,C,H,S (L -> H)
	public Card getHighCard(Card[] playerHand) {
		Card highCard = new Card();
		for (Card card : playerHand) {
			if (highCard.rank.ordinal() < card.rank.ordinal())
			{
				highCard = card;
			}
			else if ((highCard.rank.ordinal() == card.rank.ordinal()) 
					&& (highCard.suit.ordinal() < card.suit.ordinal()))
			{
				highCard = card;
			}
		}	
		return highCard;
	}

	//------------------------------------------------//
	//Checks the HandRank of each player, then prints from p1->p6
	//Primarily for testing purposes
	//Future/Alt version that prints in winning order w/ tie breaking
	public void getAllHandsWithRanks() {
		String[] playerScores = new String[6];
		this.playerHandRanks[0] = getHandRank(this.hand1);
		this.playerHandRanks[1] = getHandRank(this.hand2);
		this.playerHandRanks[2] = getHandRank(this.hand3);
		this.playerHandRanks[3] = getHandRank(this.hand4);
		this.playerHandRanks[4] = getHandRank(this.hand5);
		this.playerHandRanks[5] = getHandRank(this.hand6);

		for (int i = 0; i < 6; i++) {
			System.out.println(handRanktoString(this.playerHandRanks[i]));
		}

	}

	//------------------------------------------------//
	//Checks one hand of 5 cards for its HandRank
	//Currently, assigns High Card if no other HandRank fits,
	//but it does not rank at all
	public HandRank getHandRank(Card[] hand) {
		if (isStraightRoyalFlush(hand)) {
			return HandRank.ROYAL_STRAIGHT_FLUSH;
		} else if (isStraightFlush(hand)) {
			return HandRank.STRAIGHT_FLUSH;
		} else if (isFourOfAKind(hand)) {
			return HandRank.FOUR_OF_A_KIND;
		} else if (isFullHouse(hand)) {
			return HandRank.FULL_HOUSE;
		} else if (isFlush(hand)) {
			return HandRank.FLUSH;
		} else if (isStraight(hand)) {
			return HandRank.STRAIGHT;
		} else if (isThreeOfAKind(hand)) {
			return HandRank.THREE_OF_A_KIND;
		} else if (numOfPairs(hand) == 2) {
			return HandRank.TWO_PAIR;
		} else if (numOfPairs(hand) == 1) {
			return HandRank.PAIR;
		} 
		return HandRank.HIGH_CARD;
	}

	//------------------------------------------------//
	//Hand Rank Identifiers---------------------------//
	//------------------------------------------------//

	public boolean isStraight(Card[] hand) {
		int[] ranks = new int[5];
		for (int i = 0; i < 5; i++) {
			ranks[i] = hand[i].rank.ordinal();
		}

		Arrays.sort(ranks);

		for (int i = 0; i < 4; i++) {
			if (ranks[i] + 1 != ranks[i + 1]) {
				return false;
			}
		}

		return true;
	}

	//------------------------------------------------//
	public boolean isFlush(Card[] hand) {
		for (int i = 0; i < 4; i++) {
			if (hand[i].suit.ordinal() != hand[i + 1].suit.ordinal()) {
				return false;
			}
		}
		return true;
	}

	//------------------------------------------------//
	public boolean isStraightFlush(Card[] hand) {
		return (isFlush(hand) && isStraight(hand));
	}

	//------------------------------------------------//
	public boolean isStraightRoyalFlush(Card[] hand) {
		int[] countsPerRank = new int[13];
		int[] cardsToCheck = {Rank.A.ordinal(), 
				Rank.TEN.ordinal(), 
				Rank.J.ordinal(),
				Rank.Q.ordinal(),
				Rank.K.ordinal()};

		for (Card card : hand) {
			countsPerRank[card.rank.ordinal()]++;
		}
		for (int i : cardsToCheck) {
			if (countsPerRank[i] != 1) {
				return false;
			}
		}
		return (isFlush(hand));
	}

	//------------------------------------------------//
	//Returns int for num of pairs, unlike rest returning bool!
	public int numOfPairs(Card[] hand) {
		int numofPairs = 0;
		int[] countsPerRank = new int[13];
		for (Card card : hand) {
			countsPerRank[card.rank.ordinal()]++;
		}

		for (int i = 0; i < 13; i++) {
			if (countsPerRank[i] == 2) {
				numofPairs++;
			}
		}

		return numofPairs;
	}

	//------------------------------------------------//
	public boolean isThreeOfAKind(Card[] hand) {
		int[] countsPerRank = new int[13];
		for (Card card : hand) {
			countsPerRank[card.rank.ordinal()]++;
		}

		for (int i = 0; i < 13; i++) {
			if (countsPerRank[i] == 3) {
				return true;
			}
		}

		return false;
	}

	//------------------------------------------------//
	public boolean isFullHouse(Card[] hand) {
		if (isThreeOfAKind(hand) && (numOfPairs(hand) == 1)) {
			return true;
		}
		return false;
	}

	//------------------------------------------------//
	public boolean isFourOfAKind(Card[] hand) {
		int[] countsPerRank = new int[13];
		for (Card card : hand) {
			countsPerRank[card.rank.ordinal()]++;
		}

		for (int i = 0; i < 13; i++) {
			if (countsPerRank[i] == 4) {
				return true;
			}
		}
		return false;
	}
	//------------------------------------------------//

}