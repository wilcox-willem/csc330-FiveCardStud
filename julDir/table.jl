
include("HandAlyzer.jl")  
using ..DeckModule
using ..HandAlyzerModule

function import_deck(fileName, hands)
    println("*** USING TEST DECK ***")
    println("*** File: ", fileName)

    # Vector to store cards after construction
    imported_cards = Vector{Card}()

    # Duplication check variables
    duplicate_card_bool = false
    duplicate_card_str = ""

    open(fileName) do file
        for line in eachline(file)
            println(line)
            pos = 1

            while pos < length(line) - 1
                rank_parse = line[pos:pos+1]
                pos += 2
                suit_parse = line[pos:pos]
                pos += 2

                input_card = Card(rank_parse, suit_parse)

                # Check for duplicates pt1, if found set duplicate_card_bool to true
                for check_card in imported_cards
                    if check_card == input_card
                        duplicate_card_bool = true
                        duplicate_card_str = string(input_card)
                    end
                end

                # Add card to queue
                push!(imported_cards, input_card)
            end
        end
    end

    # Check for duplicates pt2
    if duplicate_card_bool
        println("*** ERROR - DUPLICATED CARD FOUND IN DECK ***")
        println("*** DUPLICATE: ", duplicate_card_str, " ***")
        exit(1)
    end

    # Deal cards to players from imported_cards Vector
    # For each 6 players, fill all 5 slots with a card then go to the next player
    for i in 1:6
        for j in 1:5
            hands[i, j] = imported_cards[j + (i - 1) * 5]
        end
    end
end

function print_hands(hands)
    println("\n*** Here are the six hands...")
    for i in 1:6
        for j in 1:5
            print(string(hands[i, j]), " ")
        end
        println()
    end
end

function main(argv)
    game_mode = true  # true = Random, false = PreFab Deck
    file_name

    if length(argv) > 1
        game_mode = false
        file_name = argv[2]
    end

    hands = fill(Card("", ""), (6, 5))

    println("*** P O K E R  H A N D  A N A L Y Z E R ***\n\n\n")

    if game_mode
        println("*** USING RANDOMIZED DECK OF CARDS ***\n\n",
                "*** Shuffled 52 card deck:")
        deck = Deck()
        deck.print_deck()

        for player_index in 1:6
            for i in 1:5
                hands[player_index, i] = deck.deal_card()
            end
        end

        print_hands(hands)

        println("\n*** Here is what remains in the deck...")
        deck.print_deck()
    else
        import_deck(file_name, hands)
        print_hands(hands)
    end

    # Create analyzer to analyze the entire set of hands, then print results
    analyzer = HandAlyzer(hands)
    println("\n")
    analyzer.get_final_score_print()

    return 0
end

# Example usage
main(ARGS)
