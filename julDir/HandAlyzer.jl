include("Deck.jl")
module HandAlyzerModule

export HandRank, HandAlyzer




# Enum for HandRank
@enum HandRank HIGH_CARD=0 PAIR TWO_PAIR THREE_OF_A_KIND STRAIGHT FLUSH FULL_HOUSE FOUR_OF_A_KIND STRAIGHT_FLUSH ROYAL_STRAIGHT_FLUSH

mutable struct HandAlyzer
    hands::Vector{Vector{Card}}
    playerHandRanks::Vector{HandRank}

    # Constructor
    function HandAlyzer(handsImport::Matrix{Card})
        new(Vector{Card}(undef, 6, 5), HandRank[])
        
        # update players1-6 hands#[]
        for i in 1:5
            hands[1][i] = handsImport[1, i]
            hands[2][i] = handsImport[2, i]
            hands[3][i] = handsImport[3, i]
            hands[4][i] = handsImport[4, i]
            hands[5][i] = handsImport[5, i]
            hands[6][i] = handsImport[6, i]
        end

        # update master hands[][]
        for i in 1:6
            for j in 1:5
                hands[i][j] = handsImport[i, j]
            end
        end
    end

    # Methods
    function handRanktoString(rank::HandRank)::String
        return switch(rank) do r
            HIGH_CARD => "High Card"
            PAIR => "Pair"
            TWO_PAIR => "Two Pair"
            THREE_OF_A_KIND => "Three of a Kind"
            STRAIGHT => "Straight"
            FLUSH => "Flush"
            FULL_HOUSE => "Full House"
            FOUR_OF_A_KIND => "Four of a Kind"
            STRAIGHT_FLUSH => "Straight Flush"
            ROYAL_STRAIGHT_FLUSH => "Royal Straight Flush"
        end
    end

    function handRanktoInt(rank::HandRank)::Int
        return Int(rank)
    end

    function getFinalScorePrint()
        handStrings = Vector{String}(undef, 6)

        # Get hand rank and build strings for printing
        for i in 1:6
            scoreKeeper = zeros(Int, 7)
            rank = getHandRank(hands[i], scoreKeeper)
            playerHandRanks[i] = rank
            scoreKeeper[1] = handRanktoInt(rank)

            # updates master scoreKeeper
            scoreKeeperAll[i, :] .= scoreKeeper

            # Build out Hands to print, stored in order of players 1->6
            handStringStream = IOBuffer()
            for j in 1:5
                print(handStringStream, lpad(string(hands[i][j]), 4))
            end
            handStrings[i] = String(take!(handStringStream))
        end

        # Sort out winners and implement tie breaking via bubblesorting
        for playerRankIndexLimit in 1:6
            for currentPlayer in 1:5
                if scoreKeeperAll[currentPlayer, 1] < scoreKeeperAll[currentPlayer + 1, 1]
                    swapHands(currentPlayer, currentPlayer + 1, handStrings)
                elseif scoreKeeperAll[currentPlayer, 1] == scoreKeeperAll[currentPlayer + 1, 1]
                    for criteriaIndex in 2:7
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
        for i in 1:6
            println(handStrings[i], " - ", handRanktoString(playerHandRanks[i]))
        end
    end

    # Helper method to swap hands and corresponding data
    function swapHands(player1, player2, handStrings)
        scoreKeeperAll[player1, :], scoreKeeperAll[player2, :] = scoreKeeperAll[player2, :], scoreKeeperAll[player1, :]
        playerHandRanks[player1], playerHandRanks[player2] = playerHandRanks[player2], playerHandRanks[player1]
        handStrings[player1], handStrings[player2] = handStrings[player2], handStrings[player1]
    end

    function getHandRank(hand, scoreKeeper)
        if isStraightRoyalFlush(hand, scoreKeeper)
            scoreKeeper[1] = 9
            return ROYAL_STRAIGHT_FLUSH
        elseif isStraightFlush(hand, scoreKeeper)
            scoreKeeper[1] = 8
            return STRAIGHT_FLUSH
        elseif isFourOfAKind(hand, scoreKeeper)
            scoreKeeper[1] = 7
            return FOUR_OF_A_KIND
        elseif isFullHouse(hand, scoreKeeper)
            scoreKeeper[1] = 6
            return FULL_HOUSE
        elseif isFlush(hand, scoreKeeper)
            scoreKeeper[1] = 5
            return FLUSH
        elseif isStraight(hand, scoreKeeper)
            scoreKeeper[1] = 4
            return STRAIGHT
        elseif isThreeOfAKind(hand, scoreKeeper)
            scoreKeeper[1] = 3
            return THREE_OF_A_KIND
        elseif numOfPairs(hand, scoreKeeper) == 2
            scoreKeeper[1] = 2
            return TWO_PAIR
        elseif numOfPairs(hand, scoreKeeper) == 1
            scoreKeeper[1] = 1
            return PAIR
        elseif scoreKeeper[1] == 0
            getHighCard(hand, scoreKeeper)
            getHighCardTieBreakers(hand, scoreKeeper)
        end
        return HIGH_CARD
    end

    # Hand Rank Identifiers
    function isStraight(hand, scoreKeeper)
        ranks = [c.getRankInt() for c in hand]
        highestCard = maximum(hand)

        if isStraightRoyal(hand, scoreKeeper)
            return true
        else
            for i in 1:4
                if ranks[i] + 1 != ranks[i + 1]
                    return false
                end
            end
        end

        getHighCard(hand, scoreKeeper)
        return true
    end

    function isFlush(hand, scoreKeeper)
        for i in 1:4
            if hand[i].getSuitInt() != hand[i + 1].getSuitInt()
                return false
            end
        end
        getHighCard(hand, scoreKeeper)
        getHighCardTieBreakers(hand, scoreKeeper)
        return true
    end

    function isStraightFlush(hand, scoreKeeper)
        return isFlush(hand, scoreKeeper) && isStraight(hand, scoreKeeper)
    end

    function isStraightRoyalFlush(hand, scoreKeeper)
        loopCounter = 0
        countsPerRank = zeros(Int, 13)
        suitPerCard = zeros(Int, 5)
        cardsToCheck = [0, 9, 10, 11, 12]

        for i in 1:5
            card = hand[i]
            countsPerRank[card.getRankInt()] += 1
            suitPerCard[loopCounter] = card.getSuitInt()
            loopCounter += 1
        end

        for i in cardsToCheck
            if countsPerRank[i] != 1
                return false
            end
        end

        for i in 1:4
            if suitPerCard[i] != suitPerCard[i + 1]
                return false
            end
        end

        scoreKeeper[7] = hand[1].getSuitInt()
        return true
    end

    function isStraightRoyal(hand, scoreKeeper)
        countsPerRank = zeros(Int, 13)
        cardsToCheck = [0, 9, 10, 11, 12]
        aceSuit = 0

        for i in 1:5
            card = hand[i]
            countsPerRank[card.getRankInt()] += 1
            if card.getRankInt() == 0
                aceSuit = card.getSuitInt()
            end
        end

        for i in cardsToCheck
            if countsPerRank[i] != 1
                return false
            end
        end

        scoreKeeper[2] = 14
        scoreKeeper[7] = aceSuit
        return true
    end

    function numOfPairs(hand, scoreKeeper)
        numofPairs = 0
        iterator = 0
        kickerRank = 0
        rankofPair = zeros(Int, 2)
        countsPerRank = zeros(Int, 13)

        for i in 1:5
            countsPerRank[hand[i].getRankInt()] += 1
        end

        for i in 1:13
            if countsPerRank[i] == 2
                numofPairs += 1
                if i == 0
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
            ranks = [c.getRankInt() for c in hand]
            sort!(ranks)

            sKIndex = 3
            for i in 5:-1:1
                if ranks[i] != rankofPair[1]
                    scoreKeeper[sKIndex] = ranks[i]
                    sKIndex += 1
                end
            end

            scoreKeeper[2] = rankofPair[1]
        elseif numofPairs == 2
            scoreKeeper[2] = rankofPair[2]
            scoreKeeper[3] = rankofPair[1]
        end

        if numofPairs > 0
            for i in 1:5
                card = hand[i]
                if card.getRankInt() == kickerRank
                    scoreKeeper[7] = card.getSuitInt()
                end
            end
        end

        return numofPairs
    end

    function isThreeOfAKind(hand, scoreKeeper)
        countsPerRank = zeros(Int, 13)
        for i in 1:5
            card = hand[i]
            countsPerRank[card.getRankInt()] += 1
        end

        for i in 1:13
            if countsPerRank[i] == 3
                getHighCardTieBreakers(hand, scoreKeeper)
                getHighCard(hand, scoreKeeper)
                return true
            end
        end
        return false
    end

    function isFullHouse(hand, scoreKeeper)
        if isThreeOfAKind(hand, scoreKeeper) && (numOfPairs(hand, scoreKeeper) == 1)
            getHighCard(hand, scoreKeeper)
            return true
        end
        return false
    end

    function isFourOfAKind(hand, scoreKeeper)
        countsPerRank = zeros(Int, 13)
        for i in 1:5
            card = hand[i]
            countsPerRank[card.getRankInt()] += 1
        end

        for i in 1:13
            if countsPerRank[i] == 4
                getHighCard(hand, scoreKeeper)
                return true
            end
        end
        return false
    end

    function getHighCard(playerHand, scoreKeeper)
        highCard = nothing
        isAce = false
        for i in 1:5
            cardToBeChecked = playerHand[i]
    
            # Check for aces, if found only looks for other possible aces to compare
            if cardToBeChecked.getRankInt() == 0
                if isnothing(highCard)
                    highCard = cardToBeChecked
                elseif cardToBeChecked.getSuitInt() > highCard.getSuitInt()
                    highCard = cardToBeChecked
                end
                isAce = true
            # Else, find the highest rank card
            elseif isnothing(highCard) || highCard.getRankInt() < cardToBeChecked.getRankInt()
                highCard = cardToBeChecked
            # If tied for rank, compare suit
            elseif highCard.getRankInt() == cardToBeChecked.getRankInt() && highCard.getSuitInt() < cardToBeChecked.getSuitInt()
                highCard = cardToBeChecked
            end
        end
    
        # Keeps Aces High for high card
        if isAce
            scoreKeeper[1] = 14
        else
            scoreKeeper[1] = highCard.getRankInt()
        end
    
        scoreKeeper[6] = highCard.getSuitInt()
    
        return highCard
    end
    
    function getHighCardTieBreakers(hand, scoreKeeper)
        ranks = [c.getRankInt() == 0 ? 14 : c.getRankInt() for c in hand]
        sort!(ranks)  # Sorted from low to high
        sKIndex = 2
    
        # Assigns the scoreKeeper[][][3][2][1][0][]
        # Where 3-0 is:
        # ranks[3] ~ 2nd highest card, to , ranks[0] ~ lowest card
        for i in 3:-1:0
            scoreKeeper[sKIndex] = ranks[i]
            sKIndex += 1
        end
    end
    
end
end