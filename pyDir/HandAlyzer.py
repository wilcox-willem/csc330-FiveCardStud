# Willem Ethan Wilcox, CSC 330, Dr. Pounds, Mercer University
from Deck import Card, Deck


class HandAlyzer:
    def __init__(self, hands):
        # creates 2 2d arrays
        # hands[6][5] imported from tableTest
        self.hands = hands
        # scoreKeeper[6][7]
        # scoreKeeper[Player][0-6] where [0-6] is tiebreaking criteria
        self.score_keeper_all = [[0] * 7 for _ in range(6)]

        # tracks the strings for each player, starts players 1->6
        self.player_hand_ranks = [0] * 6
        self.hand_rank_strings = [
            "High Card",  # index 0
            "Pair",
            "Two Pair",
            "Three of a Kind",
            "Straight",
            "Flush",
            "Full House",
            "Four of a Kind",
            "Straight Flush",
            "Royal Straight Flush"  # index 9
        ]

    def get_final_score_print(self):
        hand_strings = [""] * 6

        # get hand ranks and build strings for printing
        for i in range(0, 6, 1):
            score_keeper = [0] * 7
            current_hand_rank = self.get_hand_rank(self.hands[i], score_keeper)
            self.player_hand_ranks[i] = current_hand_rank
            self.score_keeper_all[i] = score_keeper
            self.score_keeper_all[i][0] = current_hand_rank

            # Build out hands to print, stored in order of players 1->6
            hand_string = ""
            for card in self.hands[i]:
                if card.get_rank_int() == 9: # hard coded adjustment for printing rank 10 cards
                    hand_string += f"{str(card):<4}"
                else:
                    hand_string += " "
                    hand_string += f"{str(card):<3}"
            hand_strings[i] = hand_string

        # Sort out winners and implement tie-breaking
        for player_rank_index_limit in range(0, 6, 1):
            for current_player in range(0, 5, 1):
                if self.score_keeper_all[current_player][0] < self.score_keeper_all[current_player + 1][0]:
                    self.swap_hands(current_player, current_player + 1, hand_strings)
                # Tie Breaking
                elif self.score_keeper_all[current_player][0] == self.score_keeper_all[current_player + 1][0]:
                    for criteria_index in range(1, 7, 1):
                        if self.score_keeper_all[current_player][criteria_index] < \
                                self.score_keeper_all[current_player + 1][criteria_index]:
                            self.swap_hands(current_player, current_player + 1, hand_strings)
                            break
                        elif self.score_keeper_all[current_player][criteria_index] > \
                                self.score_keeper_all[current_player + 1][criteria_index]:
                            break

        # Print the sorted hands with their ranks
        print("--- WINNING HAND ORDER ---")
        for i in range(0, 6, 1):
            print(f"{hand_strings[i]} - {self.hand_rank_strings[self.score_keeper_all[i][0]]}")

    # Helper Method for swapping corresponding player data in get_final_score_print
    def swap_hands(self, player1, player2, hand_strings):
        temp_score_keeper = self.score_keeper_all[player1]
        self.score_keeper_all[player1] = self.score_keeper_all[player2]
        self.score_keeper_all[player2] = temp_score_keeper

        temp_rank = self.player_hand_ranks[player1]
        self.player_hand_ranks[player1] = self.player_hand_ranks[player2]
        self.player_hand_ranks[player2] = temp_rank

        temp_hand = hand_strings[player1]
        hand_strings[player1] = hand_strings[player2]
        hand_strings[player2] = temp_hand

    def get_hand_rank(self, hand, score_keeper):
        if self.is_straight_royal_flush(hand, score_keeper):
            return 9
        elif self.is_straight_flush(hand, score_keeper):
            return 8
        elif self.is_four_of_a_kind(hand, score_keeper):
            return 7
        elif self.is_full_house(hand, score_keeper):
            return 6
        elif self.is_flush(hand, score_keeper):
            return 5
        elif self.is_straight(hand, score_keeper):
            return 4
        elif self.is_three_of_a_kind(hand, score_keeper):
            return 3
        elif self.num_of_pairs(hand, score_keeper) == 2:
            return 2
        elif self.num_of_pairs(hand, score_keeper) == 1:
            return 1
        else:
            self.get_high_card(hand, score_keeper)
            self.get_high_card_tie_breakers(hand, score_keeper)
            return 0

    # ------------------------------------------------ Hand Rank Identifier Methods
    def get_high_card(self, hand, score_keeper):
        # Checks for the highest value card in a hand
        # First, by rank A, 2, 3, ... Q, K (L -> H)
        # Then if a tie, by suit D, C, H, S (L -> H)

        # initialize high_card as lowest value card
        high_card = Card("A", "D")
        is_ace = False

        for card in hand:
            # checks for ace
            if card.get_rank_int() == 0:
                if high_card.get_rank_int() != 0:
                    high_card = card
                elif high_card.get_suit_int() < card.get_suit_int():
                    high_card = card
                is_ace = True
            # check for everything else
            elif high_card.get_rank_int() < card.get_rank_int():
                high_card = card
            elif high_card.get_suit_int() < card.get_suit_int() and high_card.get_rank_int() == card.get_rank_int():
                high_card = card

        # update score_keeper, check for aces and hard code to 13
        if is_ace:
            score_keeper[1] = 13
        else:
            score_keeper[1] = high_card.get_rank_int()
        score_keeper[6] = high_card.get_suit_int()

        return high_card

    def get_high_card_tie_breakers(self, hand, score_keeper):
        current_hand_ranks = [0]*5
        iterator = 0

        # get values of ranks in hand, store to sort
        for card in hand:
            current_hand_ranks[iterator] = card.get_rank_int()
            if current_hand_ranks[iterator] == 0:
                current_hand_ranks[iterator] = 13

        current_hand_ranks.sort(reverse=True)
        iterator = 2
        for i in range(0, 4, 1):
            score_keeper[iterator] = current_hand_ranks[i]
            iterator += 1

    def is_straight(self, hand, score_keeper):
        current_hand_ranks = [card.get_rank_int() for card in hand]
        current_hand_ranks.sort()

        for i in range(0, 4, 1):
            if current_hand_ranks[i] + 1 != current_hand_ranks[i + 1]:
                return False

        self.get_high_card(hand, score_keeper)

    def is_flush(self, hand, score_keeper):
        current_hand_suits = [card.get_suit_int() for card in hand]

        for i in range(0, 4, 1):
            if current_hand_suits[i] != current_hand_suits[i + 1]:
                return False

        self.get_high_card(hand, score_keeper)
        return True

    def is_straight_flush(self, hand, score_keeper):
        return self.is_flush(hand, score_keeper) and self.is_straight(hand, score_keeper)

    def is_straight_royal_flush(self, hand, score_keeper):
        # Makes array showings how many of each rank are in hand. A=0, 2=1, ... K=12
        cards_in_hand = [0] * 13
        current_hand_ranks = [card.get_rank_int() for card in hand]
        for i in current_hand_ranks:
            cards_in_hand[i] += 1

        # defined array of indices for SRF
        check_for_rsf = [0, 9, 10, 11, 12]

        for i in check_for_rsf:
            if cards_in_hand[i] != 1:
                return False

        if self.is_flush(hand, score_keeper):
            score_keeper[2] = 13  # hard coded for ace
            score_keeper[6] = hand[0].get_suit_int()
            return True

        return False

    def num_of_pairs(self, hand, score_keeper):
        number_of_pairs = 0
        rank_of_pair = [0]*2
        kicker_rank = 0

        # Makes array showings how many of each rank are in hand. A=0, 2=1, ... K=12
        cards_in_hand = [0]*13
        current_hand_ranks = [card.get_rank_int() for card in hand]
        for i in current_hand_ranks:
            cards_in_hand[i] += 1

        for i in range(0, 13, 1):
            if cards_in_hand[i] == 2:
                rank_of_pair[number_of_pairs] = i
                number_of_pairs += 1
            if cards_in_hand[i] == 1:
                kicker_rank = i

        if number_of_pairs == 1:
            current_hand_ranks.sort(reverse=True)
            iterator = 2
            score_keeper[1] = rank_of_pair[0]
            score_keeper[6] = kicker_rank
            for i in range(0, 5, 1):
                if current_hand_ranks[i] != rank_of_pair[0]:
                    score_keeper[iterator] = current_hand_ranks[i]
        elif number_of_pairs == 2:
            score_keeper[1] = rank_of_pair[1]
            score_keeper[2] = rank_of_pair[0]
            score_keeper[6] = kicker_rank

        return number_of_pairs

    def is_three_of_a_kind(self, hand, score_keeper):
        # Makes array showings how many of each rank are in hand. A=0, 2=1, ... K=12
        cards_in_hand = [0]*13
        current_hand_ranks = [card.get_rank_int() for card in hand]
        for i in current_hand_ranks:
            cards_in_hand[i] += 1

        for i in range(0, 13, 1):
            if cards_in_hand[i] == 3:
                self.get_high_card_tie_breakers(hand, score_keeper)
                self.get_high_card(hand, score_keeper)
                return True

        return False

    def is_full_house(self, hand, score_keeper):
        if self.is_three_of_a_kind(hand, score_keeper) and self.num_of_pairs(hand, score_keeper) == 1:
            self.get_high_card(hand, score_keeper)
            return True
        else:
            return False

    def is_four_of_a_kind(self, hand, score_keeper):
        # Makes array showings how many of each rank are in hand. A=0, 2=1, ... K=12
        cards_in_hand = [0]*13
        current_hand_ranks = [card.get_rank_int() for card in hand]
        for i in current_hand_ranks:
            cards_in_hand[i] += 1

        for i in range(0, 13, 1):
            if cards_in_hand[i] == 4:
                self.get_high_card_tie_breakers(hand, score_keeper)
                self.get_high_card(hand, score_keeper)
                return True

        return False
