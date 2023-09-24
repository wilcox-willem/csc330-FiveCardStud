using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class TableTest
{
    static void Main(string[] args)
    {
        // Initialize gamemode and console input
        bool gameMode = true; // T = Random, F = PreFab Deck
        string fileName = " ";

        if (args.Length > 0)
        {
            gameMode = false;
            fileName = args[0];
        }

        // Test Decks to skip console command,
        // set gameMode to false if skipping console command
        // fileName = "handsets/test.txt";
        // fileName = "handsets/threeofakind.txt";
        // fileName = "handsets/testDuplicate.txt";

        // Create 2d array for players decks
        Card[][] hands = new Card[6][];
        for (int i = 0; i < 6; i++)
        {
            hands[i] = new Card[5];
        }

        Console.WriteLine("*** P O K E R  H A N D  A N A L Y Z E R ***\n\n\n");

        // Deal cards based on game mode
        if (gameMode)
        {
            // Announce game mode and print deck
            Console.WriteLine("*** USING RANDOMIZED DECK OF CARDS ***"
                    + "\n\n*** Shuffled 52 card deck:");
            Deck deck = new Deck();
            deck.PrintDeck();

            // Deal 6 hands of 5 cards each
            for (int i = 0; i < 5; i++)
            {
                for (int j = 0; j < 6; j++)
                {
                    hands[j][i] = deck.DealCard();
                }
            }

            // Print hands dealt and remaining cards in the random deck
            PrintHands(hands);
            Console.WriteLine("\n*** Here is what remains in the deck...");
            deck.PrintDeck();
        }
        else
        {
            // Deal cards from prefab deck
            hands = ImportDeck(fileName, hands);

            // Print hands dealt and remaining cards in the random deck
            PrintHands(hands);
        }

        // Create analyzer to analyze the entire set of hands, then print results
        HandAlyzer analyzer = new HandAlyzer(hands);
        Console.WriteLine("\n");
        analyzer.getFinalScorePrint();
    }

    // Begin Methods

    static void PrintHands(Card[][] hands)
    {
        Console.WriteLine("\n*** Here are the six hands...");

        for (int i = 0; i < 6; i++)
        {
            for (int j = 0; j < 5; j++)
            {
                Console.Write(hands[i][j].ToString());
            }
            Console.Write("\n");
        }
    }

    static Card[][] ImportDeck(string fileName, Card[][] hands)
    {
        Console.WriteLine("*** USING TEST DECK ***\n");
        Console.WriteLine("*** File: " + fileName);

        // Queue to store cards after construction
        Queue<Card> importedCards = new Queue<Card>();
        // Duplication check variables
        bool duplicateCardBool = false;
        string duplicateCardStr = "";

        // Read lines from the file
        string[] lines = File.ReadAllLines(fileName);

        foreach (string line in lines)
        {
            Console.WriteLine(line);
            string[] parts = line.Split(',');
            foreach (string part in parts)
            {
            
                // Splits " RS" into " R", "S" to separate Rank and Suit
                string rankParse = part.Substring(0, 2); 
               
                string suitParse = part.Substring(2, 1);
               
                // Uses card methods and constructor to
                // interpret split parts to Rank & Suit enums
                Card inputCard = new Card(rankParse, suitParse);
                // Check for duplicates pt1, if found return dupCardBool true
                foreach (Card checkCard in importedCards)
                {
                    if (inputCard.Equals(checkCard))
                    {
                        duplicateCardBool = true;
                        duplicateCardStr = inputCard.ToString();
                    }
                }
        
                // Add card to queue
                importedCards.Enqueue(inputCard);
                
            }
        }

        // Check for duplicates pt2
        if (duplicateCardBool)
        {
            Console.WriteLine("*** ERROR - DUPLICATED CARD FOUND IN DECK ***"
                    + "\n\n*** DUPLICATE: " + duplicateCardStr + " ***\n");
            Environment.Exit(0);
        }

        // Deal cards to players from importedCards Queue
        // For each 6 players, fills all 5 slots with a card then goes to next player
        for (int i = 0; i < 6; i++)
        {
            for (int j = 0; j < 5; j++)
            {
                hands[i][j] = importedCards.Dequeue();
            }
        }

        return hands;
    }
}