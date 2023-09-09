package wwClasses;

public class tableTest {

	public static void main(String[] args) {
		//WHAT TO DO FOR PRE FAB DECKS??
		//WHAT TO DO FOR PRE FAB DECKS??
		//WHAT TO DO FOR PRE FAB DECKS??
		boolean gameMode = true; //T = Random, F = PreFab Deck

		//Create 2d array for players decks
		Card[][] hands = new Card[6][5]; //[player][card index]
		

		//WHAT TO DO FOR PRE FAB DECKS??
		//WHAT TO DO FOR PRE FAB DECKS??
		//WHAT TO DO FOR PRE FAB DECKS??
		//WHAT TO DO FOR PRE FAB DECKS??

		System.out.print("*** P O K E R  H A N D  A N A L Y Z E R ***\n\n\n");
		//Deal Cards for Randomized Game
		if(gameMode) {
			//Announce game mode and print deck
			System.out.println("*** USING RANDOMIZED DECK OF CARDS ***\n\n*** Shuffled 52 card deck:");
			Deck deck = new Deck();
			deck.printDeck();
			deck.checkForDuplicates();
			
			//Deal 6 hands of 5 cards each,
			for (int i = 0; i < 6; i++) {
				for (int j = 0; j < 5; j++) {			
				hands[i][j] = deck.dealCard(); 
				}
			}
			
			printHands(hands);
			printRemainingDeck(deck);
		} 
		else {
			//Pre Fab deck creation and display
		}

		
		

	}
	
	//------------------------------------------------//

	public static void printHands(Card[][] hands) {
		System.out.println("\n*** Here are the six hands...");
		
		for (int i = 0; i < 6; i++) {
			for (int j = 0; j < 5; j++) {			
			System.out.print(hands[i][j].toString()); 
			}
			System.out.print("\n");
		}
	}
	
	//------------------------------------------------//
	
	public static void printRemainingDeck(Deck deck) {
		System.out.println("\n*** Here is what remains in the deck...");
		deck.printDeck();

	}
	
	//------------------------------------------------//

}
