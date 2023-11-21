module DeckModule

export Card, Deck, rank_to_string, suit_to_string, toString

# Enumeration for card ranks
@enum Rank A=0 TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE TEN J Q K

# Enumeration for card suits
@enum Suit D=0 C H S

# Card struct
mutable struct Card
    rank::Rank
    suit::Suit
end

# Deck struct
mutable struct Deck
    cards::Vector{Card}
    
    function Deck()
        # Make deck
        for suit in [D, C, H, S]
            for rank in [A, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, J, Q, K]
                push!(cards, Card(rank, suit))
            end
        end
        # Shuffle deck
        shuffle_deck()
    end
    
    function shuffle_deck()
        # Get the current time in seconds since the Unix epoch
        current_time = time()
        
        # Seed the random number generator with the current time
        srand(current_time)
        
        # Shuffle the deck
        shuffle!(cards)
    end

    function print_deck()
        i = 0
        if length(cards) == 52
            for card in cards
                println(toString(card))
                i += 1
                if i % 13 == 0
                    println()
                end
            end
        else
            for card in cards
                print(toString(card), " ")
            end
            println()
        end
    end

    function deal_card()
        if !isempty(cards)
            top_card = pop!(cards)
            return top_card
        end
        return Card(A, D)  # Return a default card if the deck is empty
    end
end

# Convert rank to string
function rank_to_string(rank::Rank)::String
    return switch(rank) do r
        A => "A"
        TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN => string(Int(rank))
        J => "J"
        Q => "Q"
        K => "K"
    end
end

# Convert suit to string
function suit_to_string(suit::Suit)::String
    return switch(suit) do s
        D => "D"
        C => "C"
        H => "H"
        S => "S"
    end
end

# Convert card to string
function toString(card::Card)::String
    return rank_to_string(card.rank) * suit_to_string(card.suit)
end

end  # module
