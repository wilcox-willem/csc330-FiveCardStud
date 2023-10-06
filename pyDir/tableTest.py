# Willem Ethan Wilcox, CSC 330, Dr. Pounds, Mercer University
from Deck import Card, Deck
from HandAlyzer import HandAlyzer

import sys


# ---------------------------------------- Main()
def main():
    # Initialize game mode and file name
    game_mode = True  # True for Random, False for PreFab Deck
    file_name = ""

    if len(sys.argv) > 1:
       game_mode = False
       file_name = sys.argv[1]

    print("*** P O K E R  H A N D  A N A L Y Z E R ***\n\n")

    # Create 2D list for players' decks
    hands = [[None] * 5 for _ in range(6)]

    # Deal cards based on game mode
    if game_mode:
        # Announce game mode and print deck
        print("*** USING RANDOMIZED DECK OF CARDS ***\n")
        deck = Deck()
        deck.print_deck()

        # Deal 6 hands of 5 cards each
        for i in range(5):
            for j in range(6):
                hands[j][i] = deck.deal_card()

        # Print hands dealt and remaining random deck
        print_hands(hands)
        deck.print_deck()
    else:
        # Deal cards from prefab deck
        hands = import_deck(file_name, hands)

        # Print hands dealt
        print_hands(hands)

    # Create analyzer to analyze entire set of hands, then print results
    analyzer = HandAlyzer(hands)
    analyzer.get_final_score_print()


# ---------------------------------------- Methods
# Print hands function
def print_hands(hands):
    print("*** Here are the six hands...")
    for i in range(6):
        for j in range(5):
            print(hands[i][j], end=" ")
        print()
    print()


# Import deck function
def import_deck(file_name, hands):
    print("*** USING TEST DECK ***\n")
    print("*** File:", file_name)

    # Queue to store cards after construction
    imported_cards = []
    # Duplication check variables
    duplicate_card_bool = False
    duplicate_card_str = ""

    # Read file and split into lines
    with open(file_name, 'r') as file:
        lines = file.readlines()

    for line in lines:
        line = line.strip()
        print(line)
        parts = line.split(',')
        for part in parts:
            last_two_char = part.strip()[-2:]
            if last_two_char[0] == "0":
                rank_parse = "10"
            else:
                rank_parse = last_two_char[0]
            suit_parse = last_two_char[1]
            input_card = Card(rank_parse, suit_parse)
            # Check for duplicates
            if input_card in imported_cards:
                duplicate_card_bool = True
                duplicate_card_str = str(input_card)
            imported_cards.append(input_card)

    # Check for duplicates
    if duplicate_card_bool:
        print("*** ERROR - DUPLICATED CARD FOUND IN DECK ***")
        print("\n*** DUPLICATE:", duplicate_card_str, "***\n")
        sys.exit(0)

    # Deal cards to players from imported_cards list
    for i in range(6):
        for j in range(5):
            hands[i][j] = imported_cards.pop(0)

    return hands


if __name__ == "__main__":
    main()
