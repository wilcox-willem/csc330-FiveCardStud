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

	//For tracking win and tie breaking info
	//The following are what each index is used for
	//[0] = HandRank //denoted as 0 (high card)) -> 9 (R straight flush)
	//[1] = Highest Rank card (or highest Rank of pair)
	//[2] = 2nd highest Rank card (if needed, else 0)
	//[3] = 3rd highest Rank card (if needed, else 0)
	//[4] = 4th highest Rank card (if needed, else 0)
	//[5] = 5th highest Rank card (if needed, else 0)
	//[6] = Suit of card in [1] // denoted as (0, D) (1, C) (2, H) (3, S)
	int[] scoreKeeperP1 = {0, 0, 0, 0, 0, 0, 0};
	int[] scoreKeeperP2 = {0, 0, 0, 0, 0, 0, 0};
	int[] scoreKeeperP3 = {0, 0, 0, 0, 0, 0, 0};
	int[] scoreKeeperP4 = {0, 0, 0, 0, 0, 0, 0};
	int[] scoreKeeperP5 = {0, 0, 0, 0, 0, 0, 0};
	int[] scoreKeeperP6 = {0, 0, 0, 0, 0, 0, 0};
	int[][] scoreKeeperAll =  {scoreKeeperP1, scoreKeeperP2, scoreKeeperP3,
			scoreKeeperP4, scoreKeeperP5, scoreKeeperP6};


	//Holds HandRank enums in player order 1-6
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
	public void getFinalScorePrint() {
		String[] handStrings = new String[6];

		//Get hand rank and build strings for printing
		for (int i = 0; i < 6; i++) {
			int[] scoreKeeper = new int[7];
			HandRank rank = getHandRank(hands[i], scoreKeeper);
			playerHandRanks[i] = rank;
			this.scoreKeeperAll[i][0] = rank.ordinal();

			for (int j = 1; j < 7; j++){
				this.scoreKeeperAll[i][j] = scoreKeeper[j]; 
			}

			//Build out Hands to print, stored in order of players 1->6
			StringBuilder handString = new StringBuilder();
			for (Card card : hands[i]) {
				handString.append(String.format("%4s", card.toString()));
			}
			handStrings[i] = handString.toString();
		}

		// //DEBUGGING PURPOSES
		// //Adds [0]1[2][3][4][5][6] section to printout, with the values of the player scoreKeeperAll[player][0-6]
		// for (int i = 0; i < 6 ; i++) {
		// 	String temp = handStrings[i] + " ";
		// 	for (int j = 0; j < 7; j++) {
		// 		if (this.scoreKeeperAll[i][j] <10 ) {
		// 			temp += "[0" + this.scoreKeeperAll[i][j] + "]";
		// 		} else temp += "[" + this.scoreKeeperAll[i][j] + "]";
		// 	}
		// 	handStrings[i] = temp;
		// }
		// //END DEBUGGING STRING APPENDER

		//////////////Sort out winners and implement tie breaking
		for (int playerRankIndexLimit = 0; playerRankIndexLimit < 6 ;  playerRankIndexLimit++){
			for(int currentPlayer = 0; currentPlayer < 5; currentPlayer++){
				if (this.scoreKeeperAll[currentPlayer][0] < this.scoreKeeperAll[currentPlayer + 1][0]){
					swapHands(currentPlayer, currentPlayer + 1, handStrings);
				} 
				//Tie Breaking
				else if (this.scoreKeeperAll[currentPlayer][0] == this.scoreKeeperAll[currentPlayer + 1][0]){
					for (int criteriaIndex = 1; criteriaIndex < 7; criteriaIndex++){
						if(this.scoreKeeperAll[currentPlayer][criteriaIndex] < this.scoreKeeperAll[currentPlayer + 1][criteriaIndex]){
							swapHands(currentPlayer, currentPlayer + 1, handStrings);
							break;

						} else if (this.scoreKeeperAll[currentPlayer][criteriaIndex] > this.scoreKeeperAll[currentPlayer + 1][criteriaIndex]){
							break;
						}
					}
				}
			}
		}

		//Print the sorted hands with their ranks
		System.out.println("--- WINNING HAND ORDER ---");
		for (int i = 0; i < 6; i++) {
			System.out.println(handStrings[i] + " - " + handRanktoString(playerHandRanks[i])
			//Debugging step - print out playerHandRanks[]

					);
		}

	}
	//-------------------
	// Helper method to swap hands and corresponding data
	private void swapHands(int player1, int player2, String[] handStrings) {
		int[] tempScoreKeeper = scoreKeeperAll[player1];
		scoreKeeperAll[player1] = scoreKeeperAll[player2];
		scoreKeeperAll[player2] = tempScoreKeeper;

		HandRank tempRank = playerHandRanks[player1];
		playerHandRanks[player1] = playerHandRanks[player2];
		playerHandRanks[player2] = tempRank;

		String tempHand = handStrings[player1];
		handStrings[player1] = handStrings[player2];
		handStrings[player2] = tempHand;
	}
	//------------------------------------------------//
	//Checks one hand of 5 cards for its HandRank
	//Currently, assigns High Card if no other HandRank fits,
	//but it does not rank at all
	public HandRank getHandRank(Card[] hand, int[] scoreKeeper) {
		if (isStraightRoyalFlush(hand, scoreKeeper)) {
			return HandRank.ROYAL_STRAIGHT_FLUSH;
		} else if (isStraightFlush(hand, scoreKeeper)) {
			return HandRank.STRAIGHT_FLUSH;
		} else if (isFourOfAKind(hand, scoreKeeper)) {
			return HandRank.FOUR_OF_A_KIND;
		} else if (isFullHouse(hand, scoreKeeper)) {
			return HandRank.FULL_HOUSE;
		} else if (isFlush(hand, scoreKeeper)) {
			return HandRank.FLUSH;
		} else if (isStraight(hand, scoreKeeper)) {
			return HandRank.STRAIGHT;
		} else if (isThreeOfAKind(hand, scoreKeeper)) {
			return HandRank.THREE_OF_A_KIND;
		} else if (numOfPairs(hand, scoreKeeper) == 2) {
			return HandRank.TWO_PAIR;
		} else if (numOfPairs(hand, scoreKeeper) == 1) {
			return HandRank.PAIR;
		} else if (scoreKeeper[0] == 0) {
			getHighCard(hand, scoreKeeper);
			getHighCardTieBreakers(hand, scoreKeeper);

		}		
		return HandRank.HIGH_CARD;
	}

	//------------------------------------------------//
	//Hand Rank Identifiers---------------------------//
	//------------------------------------------------//

	//Checks for the highest value card in a hand
	//First, by rank A,2,3,...Q,K (L -> H)
	//Then if a tie, by suit D,C,H,S (L -> H)
	public Card getHighCard(Card[] playerHand, int[] scoreKeeper) {
		Card highCard = new Card();
		boolean isAce = false;
		for (Card card : playerHand) {
			//check for aces, if found only looks for other possible aces to compare
			if (card.rank.ordinal() == 0){
				if (highCard.rank.ordinal() != 0){
					highCard = card;
				}
				if (card.suit.ordinal() > highCard.suit.ordinal()){
					highCard = card;
				}
				isAce = true;
			}
			//else, find highest rank card
			else if (highCard.rank.ordinal() < card.rank.ordinal())
			{
				highCard = card;
			}
			//if tied for rank, compare suit
			else if ((highCard.rank.ordinal() == card.rank.ordinal()) 
					&& (highCard.suit.ordinal() < card.suit.ordinal()))
			{
				highCard = card;
			}

<<<<<<< HEAD

=======
>>>>>>> 0449f2369367c623e90b0a24aebb28eed3801559
		}	

		//Keeps Aces High for high card
		if (isAce){
			scoreKeeper[1] = 14;
		} else scoreKeeper[1] = highCard.rank.ordinal();

		scoreKeeper[6] = highCard.suit.ordinal();

		return highCard;
	}

	public void getHighCardTieBreakers(Card[] hand, int[] scoreKeeper) {
		int[] ranks = new int[5];
		for (int i = 0; i < 5; i++) {
			ranks[i] = hand[i].rank.ordinal();
			//For ties, ranks ace as highest value
			if (ranks[i] == 0){
<<<<<<< HEAD
				ranks[i] = 13;
=======
				ranks[i] = 14;
>>>>>>> 0449f2369367c623e90b0a24aebb28eed3801559
			}
		}
		Arrays.sort(ranks); //sorted [low to high]
		int sKIndex = 2;

<<<<<<< HEAD
		//Reverses the array from [low to high], to, [high to low]
		for (int i = 4; i > 0; i--) {
=======
		//Reverses the array from [low to high], to, [high to low] when assigning values to scoreKeeper[]
		for (int i = 3; i >= 0; i--) {
>>>>>>> 0449f2369367c623e90b0a24aebb28eed3801559
			scoreKeeper[sKIndex] = ranks[i];
			sKIndex++;
		}

	}

	//------------------------------------------------//
	public boolean isStraight(Card[] hand, int[] scoreKeeper) {
		int[] ranks = new int[5];
		Card highestCard = new Card();
		for (int i = 0; i < 5; i++) {
			ranks[i] = hand[i].rank.ordinal();

			if (hand[i].rank.ordinal() > highestCard.rank.ordinal()) {
				highestCard = hand[i];
			}
		}

		Arrays.sort(ranks);

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
	public boolean isFlush(Card[] hand, int[] scoreKeeper) {
		for (int i = 0; i < 4; i++) {
			if (hand[i].suit.ordinal() != hand[i + 1].suit.ordinal()) {
				return false;
			}
		}
		getHighCard(hand, scoreKeeper);
		return true;
	}

	//------------------------------------------------//
	//This method does NOT account for wrap around flushes!
	public boolean isStraightFlush(Card[] hand, int[] scoreKeeper) {
		return (isFlush(hand, scoreKeeper) && isStraight(hand, scoreKeeper));                                                                                                                                                                                
	}

	//------------------------------------------------//
	public boolean isStraightRoyalFlush(Card[] hand, int[] scoreKeeper) {
		int[] countsPerRank = new int[13];
		int[] suitPerCard = new int[5];
		int loopCounter = 0;
		int[] cardsToCheck = {Rank.A.ordinal(), 
				Rank.TEN.ordinal(), 
				Rank.J.ordinal(),
				Rank.Q.ordinal(),
				Rank.K.ordinal()};

		for (Card card : hand) {
			countsPerRank[card.rank.ordinal()]++;
			suitPerCard[loopCounter] = card.suit.ordinal();
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
		
		scoreKeeper[6] = hand[0].suit.ordinal(); 		
		return (true);
	}

	//------------------------------------------------//
	//To solve edge case where (non-flush, royal) Straights were not identified
	//Catches straights in order of "10, J, Q, K, A" not caught by isStraight
	public boolean isStraightRoyal(Card[] hand, int[] scoreKeeper) {
		int[] countsPerRank = new int[13];
		int[] cardsToCheck = {Rank.A.ordinal(), 
				Rank.TEN.ordinal(), 
				Rank.J.ordinal(),
				Rank.Q.ordinal(),
				Rank.K.ordinal()};
		int aceSuit = 0;

		for (Card card : hand) {
			countsPerRank[card.rank.ordinal()]++;
			if (card.rank.ordinal() == 0) aceSuit = card.suit.ordinal();				
		}

		for (int i : cardsToCheck) {
			if (countsPerRank[i] != 1) {
				return false;
			}
		}

		scoreKeeper[1] = 14; //Ace High value hard coded, since it will be in every SRF
		scoreKeeper[6] = aceSuit; 		
		return (true);
	}
	//------------------------------------------------//
	//Returns int for num of pairs, unlike rest returning bool!
	public int numOfPairs(Card[] hand, int[] scoreKeeper) {
		int numofPairs = 0;
		int iterator = 0;
		int kickerRank = 0;
		int[] rankofPair = new int[2];
		int[] countsPerRank = new int[13];
		for (Card card : hand) {
			countsPerRank[card.rank.ordinal()]++;
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
			else if (countsPerRank[i] == 1) {
				kickerRank = i;
			}
		}

		for (Card card : hand) {
			if (card.rank.ordinal() == kickerRank) {
				scoreKeeper[6] = card.suit.ordinal();
			}
		}

		if (numofPairs == 1) {
			//UPDATE SCOREKEEPER
			int[] ranks = new int[5];
			for (int i = 0; i < 5; i++) {
				ranks[i] = hand[i].rank.ordinal();
				//For ties, ranks ace as highest value
				if (ranks[i] == 0){
					ranks[i] = 14;
				}
			}
			Arrays.sort(ranks); //sorted [low to high]
			int sKIndex = 2;

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

		return numofPairs;
	}

	//------------------------------------------------//
	public boolean isThreeOfAKind(Card[] hand, int[] scoreKeeper) {
		int[] countsPerRank = new int[13];
		for (Card card : hand) {
			countsPerRank[card.rank.ordinal()]++;
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
	public boolean isFullHouse(Card[] hand, int[] scoreKeeper) {
		if (isThreeOfAKind(hand, scoreKeeper) && (numOfPairs(hand, scoreKeeper) == 1)) {
			getHighCard(hand, scoreKeeper);
			return true; 
		}
		return false;
	}

	//------------------------------------------------//
	public boolean isFourOfAKind(Card[] hand, int[] scoreKeeper) {
		int[] countsPerRank = new int[13];
		for (Card card : hand) {
			countsPerRank[card.rank.ordinal()]++;
		}

		for (int i = 0; i < 13; i++) {
			if (countsPerRank[i] == 4) {
				getHighCard(hand, scoreKeeper);
				return true;
			}
		}
		return false;
	}
	//------------------------------------------------//

}