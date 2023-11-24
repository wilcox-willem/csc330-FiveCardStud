#!/usr/bin/perl
use strict;
use warnings;

# Grab the name of the file from the command line, exit if no name given
my $filename = $ARGV[0] or die "Need to get file name on the  command line\n";

# Use the filename 
open(DATA, "<$filename") or die "Couldn't open file $filename, $!";

#the next line puts all the lines from the text file into an array called @all_lines
my @all_lines = <DATA>;

#Now take each line and break it into tokens based on commas and print the token
foreach my $line (@all_lines) {
   my @tokens = split(',', $line);
   chomp(@tokens);  
   foreach my $token (@tokens) {
     print "$token\n";
   }
}