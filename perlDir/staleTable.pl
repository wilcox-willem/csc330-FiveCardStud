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

our @rankStrings = (" A", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", "10", " J", " Q", " K");
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
    if (get_rank_int($currentcard) == 9){
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

=pod # commentted out handanalyzer, still under developement!

##### HandAlyzer function is the master analysis function, 
##### it takes the hands then prints the results.
sub HandAlyzer {
    # in: @hands[6][5]
    # out: prints scores to console
    my @hands = @_;


}

sub numOfPairs {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns int number of pairs,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    my $numberOfPairs;
    my @pairRanks;

    my $kickerRank;
    my $iterator;

    my @countsPerRank = (0) x 14;  # Initialize array with zeros

    for my $card (@$hand) {
        if (($card % 100) == 0) {
            # adjust aces high val
            $card += 13;
        }

        $countsPerRank[$card % 100] += 1;
    }

    for my $i (0..12) {
        if ($countsPerRank[$i] == 4) {
            $scoreKeeper->[1] = $i;  # Update the relevant value in scoreKeeper
            getHighCardTieBreakers($hand, $scoreKeeper);
            return 1;  # true
        }
    }

}

sub isThreeOfAKind {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns boolean if hand type matches,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    my @countsPerRank = (0) x 13;  # Initialize array with zeros

    for my $card (@$hand) {
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

sub isFourOfaKind {
    # in: \@playerHand[5] && \@playerScore[7]
    # out: returns boolean if hand type matches,
    #      also updates scoreKeeper
    my ($hand, $scoreKeeper) = @_;

    my @countsPerRank = (0) x 13;  # Initialize array with zeros

    for my $card (@$hand) {
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
        $currentRank = ($currentcard % 100);
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




=cut


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

}

# Call the main subroutine
mainTable();