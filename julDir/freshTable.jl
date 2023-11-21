
mutable struct Card
    rank_int::Int
    suit_int::Int
    rank::String
    suit::String
end

function create_card(rank::String, suit::String)
    suitdict = Dict("D"=>1, "C"=>2, "H"=>3, "S"=>4)
    rankdict = Dict(" A"=>1, " 2"=>2, " 3"=>3, " 4"=>4, " 5"=>5, " 6"=>6, " 7"=>7, " 8"=>8, " 9"=>9, "10"=>10, " J"=>11, " Q"=>12, " K"=>13)
    rank_int_value = 1
    suit_int_value = 1

    # Map suit to suit_int_value
    suit_int_value = get(suitdict, suit, 1)

    # Map rank to rank_int_value
    rank_int_value = get(rankdict, rank, 1)

    new_card = Card(rank_int_value, suit_int_value, rank, suit)
    return new_card
end

function create_card_str(string_card::String)
    rank = string_card[1:2]
    suit = string_card[3:3]
    new_card = create_card(rank, suit)
    return new_card
end

function card_to_string(this::Card)
    return this.rank * this.suit
end

function card_to_string_opt(this::Card, opt::Int)
    if this.rank_int == 10
        if opt == 2
            return this.rank * this.suit * ", "
        elseif opt == 1
            return this.rank * this.suit * " "
        else
            return this.rank * this.suit
        end
    else
        if opt == 2
            return lstrip(this.rank[2:end] * this.suit * ", ")
        elseif opt == 1
            return lstrip(this.rank[2:end] * this.suit * " ")
        else
            return this.rank * this.suit
        end
    end
end

function are_cards_equal(this::Card, other::Card)
    return this.rank == other.rank && this.suit == other.suit
end

function getRankInt(this::Card)
    return this.rank_int
end

function getSuitInt(this::Card)
    return this.suit_int
end


#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################

using Random



mutable struct Deck
    cards::Vector{Card}
end

function create_deck()
    ranks = [" A", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", "10", " J", " Q", " K"]
    suits = ["D", "C", "H", "S"]
    cards = Card[]

    for rank in ranks, suit in suits
        push!(cards, create_card(rank, suit))
    end
    new_deck = Deck(cards)

    shuffle!(cards)
    print_deck(new_deck)

    return new_deck
end

function import_deck(fileName)
    f = open(fileName,"r")
    hands = Array{Card, 2}(undef, 6, 5)

    # Read in ALL of the hand into a single string
    allhands = read(f, String)
    close(f)

    # Print out the hands
    println("*** USING TEST DECK ***\n")
    println("*** File: " * fileName)
    println(allhands)
    println("")


    # Create a card token array by splitting the allhands string
    cardStrings = split(allhands,[',','\n'], keepempty=false)

    currentCard = 0
    cardsFound = Array{Card, 1}(undef, 30)
    dupeFound = false
    dupeCard = create_card_str(" AD") #lowest val card
    # Deal Cards to hands
    for i in 1:6
        for j in 1:5
            currentCard += 1 
            newCard = create_card_str(string(cardStrings[currentCard]))
            cardsFound[currentCard] = newCard

            for i in 1:currentCard-1
                if are_cards_equal(cardsFound[i], newCard)
                    dupeFound = true
                    dupeCard = newCard
                end
            end

            hands[i, j] = newCard
        end
    end

    if dupeFound
        println("** ERROR - DUPLICATED CARD FOUND IN DECK ***\n")
        println("*** DUPLICATE: ", card_to_string(dupeCard)," ***")
        exit(0)
    else
        print_hands(hands)
    end

    return hands

end #import_deck

function deal_card(deck::Deck)
    if length(deck.cards) == 0
        return create_card(" A", "D")
    else
        return pop!(deck.cards)
    end
end

function print_deck(deck::Deck)
    if length(deck.cards) > 22
        println("*** Shuffled 52 card deck:")
        for (i, card) in enumerate(deck.cards)
            print(card_to_string_opt(card, 1))
            if i % 13 == 0
                println()
            end
        end
        println()
    else
        println("*** Here is what remains in the deck...")

        newLineTracker = 1
        for card in deck.cards
            print(card_to_string_opt(card, 1))
            newLineTracker += 1

            if newLineTracker > 13
                println("")
                newLineTracker = 1
            end
        end
        println("")
    end
end

function print_deck_test(deck::Deck)
    for card in deck.cards
        println("Card: ", card)
    end
end
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################


# Methods

function handRanktoInt(rank)
    if rank == "High Card"
        return 0
    elseif rank == "Pair"
        return 1
    elseif rank == "Two Pair"
        return 2
    elseif rank == "Three of a Kind"
        return 3
    elseif rank == "Straight"
        return 4
    elseif rank == "Flush"
        return 5
    elseif rank == "Full House"
        return 6
    elseif rank == "Four of a Kind"
        return 7
    elseif rank == "Straight Flush"
        return 8
    elseif rank == "Royal Straight Flush"
        return 9
    else
        return 0
    end
end


# getFinalScorePrint function
function getFinalScorePrint(hands::Matrix{Card})
    handStrings = ["", "", "", "", "", ""]
    playerHandRanks = ["", "", "", "", "", ""]
    scoreKeeperAll = zeros(Int, 6, 7)


    # Get hand rank and build strings for printing
    for i in 1:6
        scoreKeeper = zeros(Int, 7)
        rank = getHandRank(hands[i, :], scoreKeeper)
        playerHandRanks[i] = rank
        # scoreKeeper[1] = handRanktoInt(rank)

        # Updates master scoreKeeper
        scoreKeeperAll[i, :] .= scoreKeeper

        # Build out hands to print, stored in order of players 1->6
        handStringStream = IOBuffer()
        for j = 1:5
            write(handStringStream, string(" ", lpad(hands[i][j].toString(), 4)))
        end

        handStrings[i] = String(take!(handStringStream))
    end

    # Sort out winners and implement tie-breaking via bubblesorting
    for playerRankIndexLimit = 1:6
        for currentPlayer = 1:5
            if scoreKeeperAll[currentPlayer, 1] < scoreKeeperAll[currentPlayer + 1, 1]
                swapHands(currentPlayer, currentPlayer + 1, handStrings)
            elseif scoreKeeperAll[currentPlayer, 1] == scoreKeeperAll[currentPlayer + 1, 1]
                for criteriaIndex = 2:7
                    if scoreKeeperAll[currentPlayer, criteriaIndex] < scoreKeeperAll[currentPlayer + 1, criteriaIndex]
                        swapHands(currentPlayer, currentPlayer + 1, handStrings)
                        break
                    elseif scoreKeeperAll[currentPlayer, criteriaIndex] > scoreKeeperAll[currentPlayer + 1, criteriaIndex]
                        break
                    end
                end
            end
        end
    end

    # Print the sorted hands with their ranks
    println("--- WINNING HAND ORDER ---")
    for i = 1:6
        println(handStrings[i], " - ", playerHandRanks[i])
    end
end

# Helper method to swap hands and corresponding data
function swapHands(player1, player2, handStrings)
    # Swaps scoreKeeper[p1] and [p2]
    scoreKeeperAll[[player1, player2], :] = scoreKeeperAll[[player2, player1], :]

    tempRank = playerHandRanks[player1]
    playerHandRanks[player1] = playerHandRanks[player2]
    playerHandRanks[player2] = tempRank

    tempHand = handStrings[player1]
    handStrings[player1] = handStrings[player2]
    handStrings[player2] = tempHand
end

# getHandRank function
function getHandRank(hand::Vector{Card}, scoreKeeper::Vector{Int})
    if isStraightRoyalFlush(hand, scoreKeeper)
        scoreKeeper[1] = 9
        return "Royal Straight Flush"
    elseif isStraightFlush(hand, scoreKeeper)
        scoreKeeper[1] = 8
        return "Straight Flush"
    elseif isFourOfAKind(hand, scoreKeeper)
        scoreKeeper[1] = 7
        return "Four of a Kind"
    elseif isFullHouse(hand, scoreKeeper)
        scoreKeeper[1] = 6
        return "Full House"
    elseif isFlush(hand, scoreKeeper)
        scoreKeeper[1] = 5
        return "Flush"
    elseif isStraight(hand, scoreKeeper)
        scoreKeeper[1] = 4
        return "Straight"
    elseif isThreeOfAKind(hand, scoreKeeper)
        scoreKeeper[1] = 3
        return "Three of a Kind"
    elseif numOfPairs(hand, scoreKeeper) == 2
        scoreKeeper[1] = 2
        return "Two Pair"
    elseif numOfPairs(hand, scoreKeeper) == 1
        scoreKeeper[1] = 1
        return "Pair"
    elseif scoreKeeper[1] == 0
        getHighCard(hand, scoreKeeper)
        getHighCardTieBreakers(hand, scoreKeeper) 
    end
    return "High Card"
end

# isStraight function
function isStraight(hand, scoreKeeper)
    ranks = zeros(Int, 5)
    highestCard = hand[1]

    for i = 1:5
        ranks[i] = getRankInt(hand[i])

        if getRankInt(hand[i]) > getRankInt(highestCard)
            highestCard = hand[i]
        end
    end

    sort!(ranks)

    if isStraightRoyal(hand, scoreKeeper)
        return true
    else
        for i = 1:4
            if ranks[i] + 1 != ranks[i + 1]
                return false
            end
        end
    end

    getHighCard(hand, scoreKeeper)
    return true
end

# isFlush function
function isFlush(hand, scoreKeeper)
    for i = 1:4
        if getSuitInt(hand[i]) != getSuitInt(hand[i + 1])
            return false
        end
    end
    getHighCard(hand, scoreKeeper)
    getHighCardTieBreakers(hand, scoreKeeper)
    return true
end

# isStraightFlush function
function isStraightFlush(hand, scoreKeeper)
    return isFlush(hand, scoreKeeper) && isStraight(hand, scoreKeeper)
end

# isStraightRoyalFlush function
function isStraightRoyalFlush(hand, scoreKeeper)
    loopCounter = 1
    countsPerRank = zeros(Int, 13)
    suitPerCard = zeros(Int, 5)

    # Array with hard coded rank values of A, 10, J, Q, K
    cardsToCheck = [1, 10, 11, 12, 13]

    for i = 1:5
        card = hand[i]
        countsPerRank[getRankInt(card)] += 1
        suitPerCard[loopCounter] = getSuitInt(card)
        loopCounter += 1
    end

    for i in cardsToCheck
        if countsPerRank[i] != 1
            return false
        end
    end

    for i = 1:4
        if suitPerCard[i] != suitPerCard[i + 1]
            return false
        end
    end

    scoreKeeper[7] = getSuitInt(hand[1])
    return true
end

# isStraightRoyal function
function isStraightRoyal(hand, scoreKeeper)
    countsPerRank = zeros(Int, 13)
    # Array with hard coded int values for A, 10, J, Q, K
    cardsToCheck = [1, 10, 11, 12, 13]
    aceSuit = 0

    for i = 1:5
        card = hand[i]
        countsPerRank[getRankInt(card)] += 1
        if getRankInt(card) == 1
            aceSuit = getSuitInt(card)
        end
    end

    for i in cardsToCheck
        if countsPerRank[i] != 1
            return false
        end
    end

    scoreKeeper[2] = 14  # Ace High value hard coded, since it will be in every SRF
    scoreKeeper[7] = aceSuit
    return true
end

# numOfPairs function
function numOfPairs(hand, scoreKeeper)
    numofPairs = 0
    iterator = 1
    kickerRank = 0
    rankofPair = zeros(Int, 2)
    countsPerRank = zeros(Int, 13)

    for i = 1:5
        countsPerRank[getRankInt(hand[i])] += 1
    end

    for i = 1:13
        if countsPerRank[i] == 2
            numofPairs += 1
            # check for aces, make high
            if i == 1
                rankofPair[iterator] = 14
            else
                rankofPair[iterator] = i
            end
            iterator += 1
        elseif countsPerRank[i] == 1
            kickerRank = i
        end
    end

    if numofPairs == 1
        # update scorekeeping if only 1 pair
        ranks = [getRankInt(hand[i]) for i = 1:5]
        # For ties, ranks ace as the highest value
        ranks = [r == 1 ? 14 : r for r in ranks]
        ranks = sort(ranks)

        sKIndex = 2  # scoreKeeper[sKIndex], [2]->[5] is the 2nd highest card -> lowest card

        # Reverses the array from [low to high], to, [high to low] when assigning values to scoreKeeper[]
        # Only assigns value if the rank does not match the pair
        for i = 5:-1:1
            if ranks[i] != rankofPair[1]
                scoreKeeper[sKIndex] = ranks[i]
                sKIndex += 1
            end
        end

        # FINISHED UPDATE
        scoreKeeper[2] = rankofPair[1]

    elseif numofPairs == 2
        scoreKeeper[2] = rankofPair[2]  # higher value pair first
        scoreKeeper[3] = rankofPair[1]  # lower value pair second
    end

    if numofPairs > 0
        # finds kicker card, then updates scorekeeper[7] with suit
        for i = 1:5
            card = hand[i]
            if getRankInt(card) == kickerRank
                scoreKeeper[7] = getSuitInt(card)
            end
        end
    end

    return numofPairs
end

# isThreeOfAKind function
function isThreeOfAKind(hand, scoreKeeper)
    countsPerRank = zeros(Int, 13)
    for i = 1:5
        card = hand[i]
        countsPerRank[getRankInt(card)] += 1
    end

    for i = 1:13
        if countsPerRank[i] == 3
            getHighCardTieBreakers(hand, scoreKeeper)
            getHighCard(hand, scoreKeeper)
            return true
        end
    end
    return false
end

# isFullHouse function
function isFullHouse(hand, scoreKeeper)
    if isThreeOfAKind(hand, scoreKeeper) && (numOfPairs(hand, scoreKeeper) == 1)
        getHighCard(hand, scoreKeeper)
        return true
    end
    return false
end

# isFourOfAKind function
function isFourOfAKind(hand, scoreKeeper)
    countsPerRank = zeros(Int, 13)
    for i = 1:5
        card = hand[i]
        countsPerRank[getRankInt(card)] += 1
    end

    for i = 1:13
        if countsPerRank[i] == 4
            getHighCard(hand, scoreKeeper)
            return true
        end
    end
    return false
end

# getHighCard function
function getHighCard(playerHand, scoreKeeper)
    highCard = playerHand[1]
    isAce = false

    for i = 1:5
        cardToBeChecked = playerHand[i]

        if getRankInt(cardToBeChecked) == 1
            if getRankInt(highCard) != 1
                highCard = cardToBeChecked
            elseif getSuitInt(cardToBeChecked) > getSuitInt(highCard)
                highCard = cardToBeChecked
            end
            isAce = true
        elseif getRankInt(highCard) < getRankInt(cardToBeChecked)
            highCard = cardToBeChecked
        elseif (getRankInt(highCard) == getRankInt(cardToBeChecked)) && (getSuitInt(highCard) < getSuitInt(cardToBeChecked))
            highCard = cardToBeChecked
        end
    end

    if isAce
        scoreKeeper[2] = 14
    else
        scoreKeeper[2] = getRankInt(highCard)
    end

    scoreKeeper[7] = getSuitInt(highCard)

    return highCard
end

# getHighCardTieBreakers function
function getHighCardTieBreakers(hand, scoreKeeper)
    ranks = [getRankInt(hand[i]) for i = 1:5]

    for i = 1:5
        if ranks[i] == 1
            ranks[i] = 14
        end
    end

    sort!(ranks)

    sKIndex = 3

    for i = 4:-1:1
        scoreKeeper[sKIndex] = ranks[i]
        sKIndex += 1
    end
end


#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################


function print_hands(hands)
    println("*** Here are the six hands...")
    for i in 1:6
        thisHand = ""
        for j in 1:5
            thisCard = hands[i, j]
            print(card_to_string_opt(thisCard, 1))

        end
        println(" ")
    end
    println(" ")
end

function main(ARGS)
    game_mode = true  # true = Random, false = PreFab Deck
    file_name = " "

    if length(ARGS) > 0
        game_mode = false
        file_name = ARGS[1]
    end

    hands = Array{Card, 2}(undef, 6, 5)

    println("*** P O K E R  H A N D  A N A L Y Z E R ***\n\n")

    if game_mode
        println("*** USING RANDOMIZED DECK OF CARDS ***\n")
        deck = create_deck()

        for player_index in 1:6
            for i in 1:5
                hands[player_index, i] = deal_card(deck)
            end
        end

        print_hands(hands)
        print_deck(deck)
    else
        hands = import_deck(file_name)
        
    end

    # Create analyzer to analyze the entire set of hands, then print results
    getFinalScorePrint(hands)


    return 0
end


# Executes the main program
main(ARGS)

