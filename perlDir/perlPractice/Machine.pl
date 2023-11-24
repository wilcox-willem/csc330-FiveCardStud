#!/usr/bin/perl
use strict;
use warnings;
use Drink; 

# Create my drink objects
my @drinks = ( Drink->new("Coke"),  Drink->new("Sprite"),
               Drink->new("Guinness", 6.50),  Drink->new("Bud Light", 0.25));

# Refill the machine
for ( my $i=0; $i<scalar @drinks; $i++) {
   $drinks[$i]->refill();
   }

# Sell 8 cokes
for ( my $i=0; $i<8; $i++) {
   $drinks[0]->vend();
   }
   
# Sell 2 sprites 
for ( my $i=0; $i<2; $i++) {
   $drinks[1]->vend();
   }

# Sell 11 Guinness (or try to) 
for ( my $i=0; $i<11; $i++) {
   $drinks[2]->vend();
   }

# Sell 1 Bud Light  
for ( my $i=0; $i<1; $i++) {
   $drinks[3]->vend();
   }

# Compute the total profits

my $totalProfit = 0.0;
for ( my $i=0; $i<4; $i++) {
   $totalProfit += $drinks[$i]->profit();
   }
  
print "\n Total Profit from Drink Sales: \$" . $totalProfit . "\n\n";

for ( my $i=0; $i<4; $i++) {
   print "You sold " . $drinks[$i]->drinksSold() . " " . $drinks[$i]->getDrinkName() . " for a total of " .  $drinks[$i]->profit() . "\n"; 
}

for ( my $i=0; $i<4; $i++) {
   print "Restock " . $drinks[$i]->drinksSold() . " " . $drinks[$i]->getDrinkName() . "\n"; 
}