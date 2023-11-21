module CardModule

    export Card, create_card, create_card_str, card_to_string, card_to_string_opt, are_cards_equal

    mutable struct Card
        rank_int::Int
        suit_int::Int
        rank::String
        suit::String
    end

    function create_card(rank::String, suit::String)
    	suitdict = Dict("D"=>1, "C"=>2, "H"=>3, "S"=>4)
    	rankdict = Dict(" A"=>1, " 2"=>2, " 3"=>3, " 4"=>4, " 5"=>5, " 6"=>6, " 7"=>7, " 8"=>8, " 9"=>9, "10"=>10, " J"=>11, " Q"=>12, " K"=>13)
        rank_int_value = 0
        suit_int_value = 0

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
end

module DeckModule

    export Deck, create_deck, deal_card, print_deck, print_deck_test

    using ..CardModule, Random

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

        shuffle!(cards)
        return Deck(cards)
    end

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
        else
            println("*** Here is what remains in the deck...")
            for card in deck.cards
                print(card_to_string_opt(card, 1))
            end
        end
    end

    function print_deck_test(deck::Deck)
        for card in deck.cards
            println("Card: ", card)
        end
    end
end

using ..DeckModule

deck = create_deck()

print_deck(deck)