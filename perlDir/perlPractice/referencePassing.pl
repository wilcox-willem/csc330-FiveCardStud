#!/usr/bin/perl

use strict;
use warnings;

# Function to add 1 to each element of the array
sub addOneToElements {
    my ($array_ref) = @_;

    for my $i (0..$#$array_ref) {
        $array_ref->[$i] += 1;
    }
}

# Example usage
my @numbers = (1, 2, 3, 4, 5);

print "Original array: @numbers\n";

addOneToElements(\@numbers);

print "Modified array: @numbers\n";