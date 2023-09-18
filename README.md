# Five Card Stud Hand Analyzer

## Description
This project uses 2 classes and a driver.
Deck.java : provides the Card class and Deck builder
HandAlyzer : provides Hand analysis and final results printing
tableTest : driver class that starts and manages distributing hands of cards



## To Run
java tableTest 
~ or ~
java tableTest filename
(where filename is the name of a test deck in the same package)

Test decks should be formatted like the following example:

10H, JC, JH, 4C, 4S
 9S, AS, 2C, 4D, 7C
 5C, JS, 6C,10S,10C
 AH, 2H, 3H, 4H, 5H
 AC, KD, QH, JD,10D
 8H, 8C, 8D, 3D, 3S

## Debugging
tableTest.java : 
    -Line 19 - 23, set l11 boolean gameMode to false, then remove comments on file to test

HandAlyzer.java :
    -Line 103 - 114, prints out below when showing winning hands, to track if tiebreaker values are assigned correctly
    [player hand rank][High card // or first tie breaker][2nd][3rd][4th][5th][Tie breaker suit]