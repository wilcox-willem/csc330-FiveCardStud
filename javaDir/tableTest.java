package wwClasses;

import java.io.File;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Scanner;

public class tableTest {

	public static void main(String[] args) throws Exception {
		//initialize gamemode and console input
		boolean gameMode = true; //T = Random, F = PreFab Deck
		String fileName = " ";

		if (args.length > 0) {
			gameMode = false; 
			fileName = args[0];
		} 

		//Test Decks to skip console command
		//fileName = "handsets/test.txt";
		//fileName = "handsets/threeofakind.txt";
		//fileName = "handsets/testDuplicate.txt";

		//Create 2d array for players decks
		Card[][] hands = new Card[6][5]; //[player][card index]

		System.out.print("*** P O K E R  H A N D  A N A L Y Z E R ***\n\n\n");

		//Deal cards based off game mode
		if(gameMode) {
			//Announce game mode and print deck
			System.out.println("*** USING RANDOMIZED DECK OF CARDS ***\n\n*** Shuffled 52 card deck:");
			Deck deck = new Deck();
			deck.printDeck();

			//Deal 6 hands of 5 cards each,
			for (int i = 0; i < 6; i++) {
				for (int j = 0; j < 5; j++) {			
					hands[i][j] = deck.dealCard(); 
				}
			}

			//Print hands dealt and remaining of random deck
			printHands(hands);
			System.out.println("\n*** Here is what remains in the deck...");
			deck.printDeck();
		} 

		else {
			//Deal cards from prefab deck
			hands = importDeck(fileName, hands);
			//Print hands dealt and remaining of random deck
			printHands(hands);
		}

		//------------
		//Create analyzer to analyze and rank hands
		//------------
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

	private static Card[][] importDeck(String fileName, Card[][] hands) throws Exception {
		System.out.println("*** USING TEST DECK ***\n");
		System.out.println("*** File: " + fileName);

		//Queue to store cards after construction
		Queue<Card> importedCards = new LinkedList<>();
		//Duplication check variables
		boolean duplicateCardBool = false;
		String duplicateCardStr = "";

		//Scanner inputs file, then it gets broken into lines
		Scanner input = new Scanner(new File(fileName));
		while (input.hasNextLine()) {
			String line = input.nextLine();
			System.out.println(line);
			String parts[] = line.split(",");
			for (String part : parts) {
				//Splits " RS" into " R", "S"
				String rankParse = part.substring(0, 2);
				String suitParse = part.substring(2, 3);
				//Uses card methods and constructor to
				//interpret split parts to Rank & Suit enums
				Card inputCard = new Card(rankParse, suitParse);
				//Check for duplicates
				for (Card checkCard : importedCards) {
					if (checkCard.equals(inputCard)) {
						duplicateCardBool = true;
						duplicateCardStr = inputCard.toString();

					}
				}
				//add card to queue
				importedCards.add(inputCard);

			}
		}

		//Process duplication check
		if (duplicateCardBool) {
			System.out.println("*** ERROR - DUPLICATED CARD FOUND IN DECK ***"
					+ "\n\n*** DUPLICATE: " + duplicateCardStr + " ***\n");
			System.exit(0);
		}

		//Deal cards from importedCards Queue
		for (int i = 0; i < 6; i++) {
			for (int j = 0; j < 5; j++) {			
				hands[i][j] = importedCards.remove(); 
			}
		}

		return hands;
	}

}
