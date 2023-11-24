package Drink;

use strict;
use warnings;
use POSIX;   # needed for floor function

# Class variables
our $MAXIMUM_CAPACITY = 10;
our $DEFAULT_DRINK_COST = 1.75;

# Instance variables
my $available;
my $consumed;
my $useDefaultCost;
my $useSuppliedCost;
my $drinkCost;
my $moneyMade;
my $name;

# Constructor
sub new {
    my $class = shift;
    my $self = bless {
        available => 0,
        consumed => 0,
        useDefaultCost => 1,
        useSuppliedCost => 0,
        drinkCost => $DEFAULT_DRINK_COST,
        moneyMade => 0.0,
        name => shift,
    }, $class;

    return $self;
}

# Methods
sub vend {
    my $self = shift;

    if ($self->{available} > 0) {
        $self->{available}--;
        $self->{consumed}++;
        $self->{moneyMade} += ($self->{useDefaultCost} * $DEFAULT_DRINK_COST +
                                $self->{useSuppliedCost} * $self->{drinkCost});

        print "$self->{name} purchased.\n";
    } else {
        print "************\n";
        print "* SOLD OUT *\n";
        print "************\n";
    }
}

sub refill {
    my $self = shift;

    $self->{available} = $MAXIMUM_CAPACITY;
}

sub profit {
    my $self = shift;

    return floor($self->{moneyMade} * 100.0 + 0.5) / 100.0;
}

sub drinksSold {
    my $self = shift;

    return $self->{consumed};
}

sub getDrinkName {
    my $self = shift;

    return $self->{name};
}

sub restockAmount {
    my $self = shift;

    return $MAXIMUM_CAPACITY - $self->{available};
}

1  # This is the required "true" value that is returned by the class
