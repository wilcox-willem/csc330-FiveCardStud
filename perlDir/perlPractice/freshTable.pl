
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
    my $filename = shift;
    my @deck;

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
    push @deck, $currentcard;
    # Debugging step
    # my $at = $currentcard % 100;
    # my $bt = int($currentcard / 100);
    # print get_card_string($currentcard)."  $currentcard - $at - $bt\n";
    }
    }

    print "\n";
    
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

# Main program





sub main {
    # Check if there are any command line arguments
    if (scalar @ARGV > 0) {
        print "Command line arguments:\n";
        while (my $arg = shift @ARGV) {
            print "- $arg\n";
        }
    } else {
        print "No command line arguments provided.\n";
    }

    my $fileNameTest = "/home/wilcox_we/csc330/FCWW/handsets/tester_rsf";
    my @testDeck = import_deck($fileNameTest);
    my @deck = create_deck;

}

# Call the main subroutine
mainTable();

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