#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(shuffle);

###################################################################################
###################################################################################
###################################################################################
###################################################################################

# CARD FUNCTIONS and card storage

# Cards will be stored as a 3 digit integer, where
# card = (suit[0-3] * 100) + (rank[0-12])
# Therefore, the suit is int(card/100)
# and the rank is card%100
#
# Finally, to get cards to a string, it uses 
# the rank and suit values to find strings
# in predefined string arrays

our @rankStrings = (" A", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", "10", " J", " Q", " K", " A");
our @suitStrings = ("D", "C", "H", "S");

# Create dictionaries
our %rank_dict = map { $rankStrings[$_] => $_ } 0..$#rankStrings;
our %suit_dict = map { $suitStrings[$_] => $_ } 0..$#suitStrings;

sub get_rank_int {
    # in: $card
    # out: 0-12 val for int
    my $card = shift;
    my $rank = ($card % 100);
    return $rank;
}

sub get_suit_int {
    # in: $card
    # out: 0-3 val for int
    my $card = shift;
    my $suit = int($card / 100);
    return $suit;
}

sub get_card_string {
    # in: $card
    # out: $string, form "RRS"
    my $card = shift;
    my $cardTitle = $rankStrings[($card % 100)].$suitStrings[(int($card / 100))];
    return $cardTitle;
}

sub print_card_string {
    # in: $card
    # out: prints to current line " RRS" or " RS" 
    my $currentcard = shift;
    if (($currentcard % 100) == 9){
        print " ".get_card_string($currentcard);
    } else {
        print get_card_string($currentcard);
    }
}

sub create_card_from_string {
    # in: $string, in form "RRS" 
    # out: $card, 3 digit num representing a card
    my $card_string = shift;
    if (length($card_string) > 3)  {
        chop($card_string);
    }

    my ($rank_str, $suit_str) = $card_string =~ /(.{2})(.{1})/;

    my $rank = $rank_dict{$rank_str};
    my $suit = $suit_dict{$suit_str};
    my $card = ($suit * 100) + $rank;

    return $card;
}

# Creates and prints a randomized deck
sub create_deck {
    # in: 
    # out: @deck[52]
    my @deck;

    for my $suit (0..3) {
        for my $rank (0..12) {
            my $card = ($suit * 100) + $rank;
            push @deck, $card;
        }
    }
    @deck = shuffle(@deck);

    print "*** USING RANDOMIZED DECK OF CARDS ***\n\n";
    print "*** Shuffled 52 card deck:";
    for my $iterator (0..51) {
        if ($iterator % 13 == 0) {
            print "\n";
        }
        if (get_rank_int($deck[$iterator]) == 9){
            print " ".get_card_string($deck[$iterator]);

        } else {
            print get_card_string($deck[$iterator]);
        }
    }

    print "\n\n";

    return @deck;
}

# Takes a file name, then creates a deck of 30 cards
sub import_deck {
    # in: $filename
    # out: @hands[6][5]
    my $filename = shift;
    my @deck;
    my %cardsInDeck;
    my $dupeFound = 0;
    my $dupeCard;

    # Use the filename 
    open(DATA, "<$filename") or die "***ERROR: Unable to Open File";

    #the next line puts all the lines from the text file into an array called @all_lines
    my @all_lines = <DATA>;
    print "*** USING TEST DECK ***\n\n";
    print "*** File: $filename\n";
    print @all_lines;
    print "\n";

    #Now take each line and break it into tokens based on commas and print the token
    foreach my $line (@all_lines) {
        my @tokens = split(',', $line);
        chomp(@tokens);  

        foreach my $token (@tokens) {
            my $currentcard = create_card_from_string($token);

            # check for duplicates in the deck
            if ($cardsInDeck{$currentcard}) {
                $dupeCard = get_card_string($currentcard);
                $dupeFound = 1;
            } else {
                $cardsInDeck{$currentcard} = 1;
            }
            push @deck, $currentcard;
        }
    }
    print "\n";

    if ($dupeFound) {
        die "***ERROR: DUPLICATED CARD FOUND IN DECK***\n\n***Duplicate: $dupeCard ***\n";
    }
    
    return @deck;
}

# Takes an array of cards, then distributes it
# into a hand array [6][5] then prints the hands. 
# If there are any cards remaining, it prints them.
sub deal_cards {
    # in: @deck[30-52]
    # out: @hands[6][5]
    my @deck = @_;
    my @hands;

    # deal cards to hands and print hands
    print "*** Here are the six hands...\n";
    for my $i (0..5) {
        for my $j (0..4) {
            my $currentcard = shift @deck;
            $hands[$i][$j] = $currentcard;
            print_card_string($currentcard);
        }
        print "\n";
    }   
    print "\n";


    # print any remaining cards
    if (scalar @deck > 1) {
        print "*** Here is what remains in the deck...\n";
        while (scalar @deck > 0) {
            my $currentcard = shift @deck;
            print_card_string($currentcard);
        }
    }
    print "\n";

    return @hands;
}

###################################################################################
###################################################################################
###################################################################################
###################################################################################

##### HandAlyzer function is the master analysis function, 
##### it takes the hands then prints the results.
sub HandAlyzer {
    # in: @hands[6][5], (pass by val or ref, doesn't matter)
    # out: prints scores to console
    my @hands = @_;


    our @scoreKeeperAll;
    for my $i (0..5) {
        for my $j (0..6) {
            $scoreKeeperAll[$i][$j] = 0;
        }
    }

    for my $i (0..5) {
        getHandRank($hands[$i], $scoreKeeperAll[$i]);
    }

    ## Sort out winners and implement tie breaking via bubblesorting
    for my $playerRankIndexLimit (0..5) {
        for my $currentPlayer (0..4) {
            if ($scoreKeeperAll[$currentPlayer][0] < $scoreKeeperAll[$currentPlayer + 1][0]) {
                swapHands($currentPlayer, $currentPlayer + 1,\@scoreKeeperAll);
            } elsif ($scoreKeeperAll[$currentPlayer][0] == $scoreKeeperAll[$currentPlayer + 1][0]) {
                for my $criteriaIndex (1..6) {
                    if ($scoreKeeperAll[$currentPlayer][$criteriaIndex] < $scoreKeeperAll[$currentPlayer + 1][$criteriaIndex]) {
                        swapHands($currentPlayer, $currentPlayer + 1, \@scoreKeeperAll);
                        last;
                    } elsif ($scoreKeeperAll[$currentPlayer][$criteriaIndex] > $scoreKeeperAll[$currentPlayer + 1][$criteriaIndex]) {
                        last;
                    }
                }
            }
        }
    }

    printResults(\@hands, \@scoreKeeperAll);

}

# helper function to clean up swapping hands
sub swapHands {
    # in: $p1, $p2, \@scoreKeeperMaster
    # out: in sKM, swaps $p1 with $p2
    my ($currentPlayer, $nextPlayer, $scoreKeeperAll) = @_;
    
    # Swap score keepers
    my @tempSK = @$scoreKeeperAll[$currentPlayer];
    @$scoreKeeperAll[$currentPlayer] = @$scoreKeeperAll[$nextPlayer];
    @$scoreKeeperAll[$nextPlayer] = @tempSK;

}

# helper function to get final print string
sub printResults { 
    # in: \@playerHands[6][5] && \@scoreKeeper[6][7]
    # out: prints final results from analysis
    my ($playerHandsAll, $scoreKeeperAll) = @_;

    my @rankStrings = ("High Card", "Pair", "Two Pair",
                    "Three of a Kind", "Straight", "Flush",
                    "Full House", "Four of a Kind",
                    "Straight Flush", "Royal Straight Flush");

    for my $i (0..5) {
        for my $j (0..4) {
            my $card = $playerHandsAll->[$i][$j];
            print_card_string($card);
        }
        my $score = $scoreKeeperAll->[$i][0];
        my $string = $rankStrings[$score];


        print " - $string\n";
    }

    print "\n";
}

### this function is the master ranker
sub getHandRank {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    if (isStraightRoyalFlush($hand, $scoreKeeper)) {
        $scoreKeeper->[0] = 9;
    } elsif (isStraightFlush($hand, $scoreKeeper)) {
        $scoreKeeper->[0] = 8;
    } elsif (isFourOfAKind($hand, $scoreKeeper)) {
        $scoreKeeper->[0] = 7;
    } elsif (isFullHouse($hand, $scoreKeeper)) {
        $scoreKeeper->[0] = 6;
    } elsif (isFlush($hand, $scoreKeeper)) {
        $scoreKeeper->[0] = 5;
    } elsif (isStraight($hand, $scoreKeeper)) {
        $scoreKeeper->[0] = 4;
    } elsif (isThreeOfAKind($hand, $scoreKeeper)) {
        $scoreKeeper->[0] = 3;
    } elsif (numOfPairs($hand, $scoreKeeper) == 2) {
        $scoreKeeper->[0] = 2;
    } elsif (numOfPairs($hand, $scoreKeeper) == 1) {
        $scoreKeeper->[0] = 1;
    } elsif ($scoreKeeper->[0] == 0) {
        getHighCard($hand, $scoreKeeper);
        getHighCardTieBreakers($hand, $scoreKeeper);
    }
}

### START analysis functions

sub isFlush {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns bool if matches rank,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    my @suitPerCard;

    foreach my $card (@$hand) {
        push @suitPerCard, int($card / 100);
    }

    for my $i (0..3) {
        if ($suitPerCard[$i] != $suitPerCard[$i + 1]) {
            return 0;  # false
        }
    }

    getHighCard($hand, $scoreKeeper);
    getHighCardTieBreakers($hand, $scoreKeeper);
    return 1;  # true
}

sub isStraight {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns bool if matches rank,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    my @handCopy = sort @$hand;

    # Array with hard coded rank values of A, 10, J, Q, K
    my @cardsToCheck = (0, 9, 10, 11, 12);
    my @isRoyalStraight = 1;

    foreach my $i (0..4) {
        if (($handCopy[$i] % 100) != $cardsToCheck[$i]) {
            @isRoyalStraight = 0;
        }
    }

    # if hand happens to be royal straight
    if (@isRoyalStraight) {
        $scoreKeeper->[6] = int($handCopy[0] / 100);
        return 0;
    }

    for my $i (0..3) {
        if (($handCopy[$i] % 100) != ($handCopy[$i + 1] % 100) + 1) {
            return 0;  # false
        }
    }

    $scoreKeeper->[1] =     ($handCopy[4] % 100); # set highest card rank 
    $scoreKeeper->[6] =  int($handCopy[4] / 100); # set tie breaking suit
    return 1;  # true
}

sub isStraightFlush {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns bool if matches rank,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    if (isStraight($hand, $scoreKeeper) && isFlush($hand, $scoreKeeper)) {
        return 1;
    } else {
        return 0;
    }
}


sub isStraightRoyalFlush {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns bool if matches rank,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    my @countsPerRank = (0) x 13;
    my @suitPerCard;

    # Array with hard coded rank values of A, 10, J, Q, K
    my @cardsToCheck = (0, 9, 10, 11, 12);

    foreach my $card (@$hand) {
        $countsPerRank[$card % 100] += 1;
        push @suitPerCard, int($card / 100);
    }

    foreach my $i (@cardsToCheck) {
        if ($countsPerRank[$i] != 1) {
            return 0;  # false
        }
    }

    for my $i (0..3) {
        if ($suitPerCard[$i] != $suitPerCard[$i + 1]) {
            return 0;  # false
        }
    }

    $scoreKeeper->[6] = $suitPerCard[0];

    return 1;  # true
}

sub numOfPairs {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns int number of pairs,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    my $numberOfPairs = 0;
    my $kickerCard;
    my @pairRanks;
    my $iterator = 0;
   
    my @countsPerRank = (0) x 14;  # Initialize array with zeros
    foreach my $card (@$hand) {
        if (($card % 100) == 0) {
            # adjust aces high val
            $card += 13;
        }
        $countsPerRank[$card % 100] += 1;
    }

    for my $i (0..13) {
        if ($countsPerRank[$i] == 2) {
            $numberOfPairs+= 1;
            $pairRanks[$iterator] = $i;
            $iterator += 1;
        }
    }

    # if no pairs, exit
    if ($numberOfPairs == 0) {
        return 0;
    }

    # update scoreKeeper / playerScore
    if ($numberOfPairs == 1) {
        my $sKIndex = 2;

        # Assign the sorted values to the appropriate positions in $scoreKeeper
        foreach my $rank (@$hand) {
            $rank = $rank % 100;
            if ($rank != ($pairRanks[0])) {
            $scoreKeeper->[$sKIndex++] = $rank;
            }
        }
        $scoreKeeper->[1] = $pairRanks[0];
        return 0;
    } elsif ($numberOfPairs == 2) {
        @pairRanks = sort @pairRanks;
        $scoreKeeper->[1] = $pairRanks[1];
        $scoreKeeper->[2] = $pairRanks[0];
    }

    # update kicker value
    my @handClone = sort @$hand;
    foreach my $card (@handClone) {
        foreach my $pairRank (@pairRanks) {
            if (($card % 100) != $pairRank) {
                $kickerCard = $card;  
            }
        }
    }
    $scoreKeeper->[6] = $kickerCard;

    return $numberOfPairs;
}

sub isThreeOfAKind {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns boolean if hand type matches,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    my @countsPerRank = (0) x 13;  # Initialize array with zeros

    foreach my $card (@$hand) {
        $countsPerRank[$card % 100] += 1;
    }

    for my $i (0..12) {
        if ($countsPerRank[$i] == 3) {
            getHighCardTieBreakers($hand, $scoreKeeper);
            getHighCard($hand, $scoreKeeper);
            return 1;  # true
        }
    }

    return 0;  # false
}

sub isFullHouse {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns boolean true if hand type matches,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    if (isThreeOfAKind($hand, $scoreKeeper) && numOfPairs($hand, $scoreKeeper) == 1) {
        getHighCard($hand, $scoreKeeper);
        return 1;  # true
    }

    return 0;  # false
}

sub isFourOfAKind {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns boolean if hand type matches,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    my @countsPerRank = (0) x 13;  # Initialize array with zeros

    foreach my $card (@$hand) {
        $countsPerRank[$card % 100] += 1;
    }

    for my $i (0..12) {
        if ($countsPerRank[$i] == 4) {
            $scoreKeeper->[1] = $i;  # Update the relevant value in scoreKeeper
            getHighCardTieBreakers($hand, $scoreKeeper);
            return 1;  # true
        }
    }

    return 0;  # false
}

sub getHighCard {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: updates playerScore/scoreKeeper
    my ($hand, $scoreKeeper) = @_; 
    my $isAce = 0;
    my $highCard = 0;

    foreach my $currentcard (@$hand) {
        if (($currentcard % 100) == 0) {
            # adjust aces to high val
            $currentcard += 13;
        }

        if (($currentcard % 100) > ($highCard % 100)) {
            $highCard = $currentcard;
        } elsif ((($currentcard % 100) == ($highCard % 100)) 
                &&  (int($currentcard / 100) == int($highCard / 100))) {
            $highCard = $currentcard;
        }
    }

    # set scoreKeeper high card and high card suit
    $scoreKeeper->[1] = ($highCard % 100);
    $scoreKeeper->[6] = int($highCard / 100);
}

sub getHighCardTieBreakers {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: updates playerScore/scoreKeeper
    my ($hand, $scoreKeeper) = @_; 
    my @cardRanks;

    foreach my $currentcard (@$hand) {
        my $currentRank = ($currentcard % 100);
        if ($currentRank == 0) {
            # adjust for aces high val
            $currentRank += 13;
        }

        push @cardRanks, $currentRank;
    }

    # Sort cardRanks in descending order (high to low)
    @cardRanks = reverse sort @cardRanks;
    # Get rid of highest card, already handled in getHighCard
    shift @cardRanks;

    my $sKIndex = 2;

    # Assign the sorted values to the appropriate positions in $scoreKeeper
    foreach my $rank (@cardRanks) {
        $scoreKeeper->[$sKIndex++] = $rank;
    }
}

#### End Hand Analysis Functions

###################################################################################
###################################################################################
###################################################################################
###################################################################################

#### Main program
sub mainTable {
    print "*** P O K E R  H A N D  A N A L Y Z E R ***\n\n\n";
    
    my @gameHands;
    my @gameDeck;
    if (scalar @ARGV > 0) {
        my $fileNameArg = shift @ARGV;
        @gameDeck = import_deck($fileNameArg);
    } else {
        @gameDeck = create_deck();
    }

    @gameHands = deal_cards(@gameDeck);
    HandAlyzer(@gameHands);
}

# Call the main subroutine
mainTable();