# Willem Ethan Wilcox, CSC 330, Dr. Pounds, Mercer University
import random


class Card:
    def __init__(self, rank, suit):
        self.rank = rank
        self.suit = suit

    def __str__(self):
        return f"{self.rank}{self.suit}"

    def __eq__(self, other):
        return self.rank == other.rank and self.suit == other.suit

    def get_rank(self):
        return self.rank

    def get_suit(self):
        return self.suit

    def get_suit_int(self):
        suit_int_value = 0
        if self.suit == "D":
            suit_int_value = 0
        if self.suit == "C":
            suit_int_value = 1
        if self.suit == "H":
            suit_int_value = 2
        if self.suit == "S":
            suit_int_value = 3
        return suit_int_value

    def get_rank_int(self):
        rank_int_value = 0
        if self.rank == "A":
            rank_int_value = 0
        if self.rank == "2":
            rank_int_value = 1
        if self.rank == "3":
            rank_int_value = 2
        if self.rank == "4":
            rank_int_value = 3
        if self.rank == "5":
            rank_int_value = 4
        if self.rank == "6":
            rank_int_value = 5
        if self.rank == "7":
            rank_int_value = 6
        if self.rank == "8":
            rank_int_value = 7
        if self.rank == "9":
            rank_int_value = 8
        if self.rank == "10":
            rank_int_value = 9
        if self.rank == "J":
            rank_int_value = 10
        if self.rank == "Q":
            rank_int_value = 11
        if self.rank == "K":
            rank_int_value = 12
        return rank_int_value


class Deck:
    ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    suits = ["D", "C", "H", "S"]
    cards = []

    def __init__(self):
        self.cards = [Card(rank, suit) for rank in self.ranks for suit in self.suits]
        random.shuffle(self.cards)

    def deal_card(self):
        if len(self.cards) == 0:
            return None
        return self.cards.pop()

    def print_deck(self):

        if self.cards.__len__() > 22:
            # ^ 22 is how many cards will be left after deal 5 cards to 6 players
            print("*** Shuffled 52 card deck:")
            for i in range(52):
                print(f"{self.cards[i].__str__()}", end=" ")
                if (i > 0 and i % 13 == 0):
                    print("")
            print("")
            print("")
        else:
            print("*** Here is what remains in the deck...")
            for j in range(len(self.cards)):
                print(f"{self.cards[j].__str__()}", end=" ")
            print("")
            print("")


# Usage example:
# if __name__ == "__main__":
#     deck = Deck()
#     deck.print_deck()
#
#     deck2 = Deck()
#     for i in range(30):
#         deck2.deal_card()
#     deck2.print_deck()
