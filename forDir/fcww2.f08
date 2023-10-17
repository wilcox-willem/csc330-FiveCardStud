! Willem Wilcox, CSC330, Dr. Pounds, 10/08/23
!-------------------------------------------------------------------------------
! CardModule
!-------------------------------------------------------------------------------
module CardModule
  implicit none

  type Card
    integer :: rank_int, suit_int
    character(2) :: rank
    character(1) :: suit
  end type Card
  
  contains

    function create_card(rank, suit) result(new_card)
      character(2), intent(in) :: rank
      character(1), intent(in) :: suit
      integer :: rank_int_value, suit_int_value
      type(Card) :: new_card
      new_card%rank = rank
      new_card%suit = suit

      ! get suit int value
      select case (suit)
        case ("D")
          suit_int_value = 1
        case ("C")
          suit_int_value = 2
        case ("H")
          suit_int_value = 3
        case ("S")
          suit_int_value = 4
        case default
          suit_int_value = 1
      end select
      new_card%suit_int = suit_int_value

      ! get rank int value
      select case (rank)
        case (" A")
          rank_int_value = 1
        case (" 2")
          rank_int_value = 2
        case (" 3")
          rank_int_value = 3
        case (" 4")
          rank_int_value = 4
        case (" 5")
          rank_int_value = 5
        case (" 6")
          rank_int_value = 6
        case (" 7")
          rank_int_value = 7
        case (" 8")
          rank_int_value = 8
        case (" 9")
          rank_int_value = 9
        case ("10")
          rank_int_value = 10
        case (" J")
          rank_int_value = 11
        case (" Q")
          rank_int_value = 12
        case (" K")
          rank_int_value = 13
        case default
          rank_int_value = 1
      end select
      new_card%rank_int = rank_int_value

    end function create_card

    function create_card_str(string_card) result(new_card)
      ! for creating imported cards with "RRS"
      character(3), intent(in) :: string_card
      type(Card) :: new_card
      character(2) :: rank
      character(1) :: suit

      rank = string_card(1:2)
      suit = string_card(3:3)
      new_card = create_card(rank, suit)
    end function create_card_str

    function card_to_string(this) result(card_str)
      type(Card), intent(in) :: this
      character(4) :: card_str
      card_str = this%rank // this%suit
    end function card_to_string

    function card_to_string_opt(this, opt) result(card_str)
      type(Card), intent(in) :: this
      integer, intent(in) :: opt
      character(:), allocatable :: card_str

      ! opt = 2: "RS, " // trimmed w/ ", "
      ! opt = 1: "RS " // trimmed, w/ " "
      ! opt = 0: "RRS" // untrimmed, ie regular to string
      ! two seperate handlings for if card is a 10 or not
      if (this%rank_int .eq. 10) then
        if (opt .eq. 2) then
          card_str = this%rank // this%suit // ", "
        else if (opt .eq. 1) then
          card_str = this%rank // this%suit // " "
        else if (opt .eq. 0) then 
          card_str = this%rank // this%suit
        end if
      else 
        if (opt .eq. 2) then
          card_str = this%rank // this%suit
          card_str = trim(adjustl(card_str(2:))) // ", "
        else if (opt .eq. 1) then
          card_str = this%rank // this%suit
          card_str = trim(adjustl(card_str(2:))) // " "
        else if (opt .eq. 0) then 
          card_str = this%rank // this%suit
        end if
      end if
    end function card_to_string_opt

    logical function are_cards_equal(this, other)
      type(Card), intent(in) :: this, other
      are_cards_equal = this%rank .eq. other%rank .and. this%suit .eq. other%suit
    end function are_cards_equal

end module CardModule

!-------------------------------------------------------------------------------
! DeckModule
!-------------------------------------------------------------------------------
module DeckModule
  use CardModule
  implicit none

  type Deck
    type(Card), dimension(:), allocatable :: cards
  end type Deck

  contains

    subroutine create_deck(this)
      type(Deck) :: this
      integer :: i, j, card_idx
      real :: random_num
      type(Card) :: temp
      character(2), dimension(13) :: ranks
      character(1), dimension(4) :: suits
      
      ranks = [" A", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", "10", " J", " Q", " K"]
      suits = ["D", "C", "H", "S"]
      card_idx = 1
      
      allocate(this%cards(52))  ! Allocate the cards array
      
      do i = 1, size(ranks)
        do j = 1, size(suits)
          this%cards(card_idx) = create_card(ranks(i), suits(j))
          card_idx = card_idx + 1
        end do
      end do
      
      call random_seed()
      do i = size(this%cards), 3, -1
        call random_number(random_num)
        j = int(random_num * real(i)) + 1
        temp = this%cards(i)
        this%cards(i) = this%cards(j)
        this%cards(j) = temp
      end do

    end subroutine create_deck

    function deal_card(this) result(dealt_card)
      type(Deck), intent(inout) :: this
      type(Card) :: dealt_card

      if (size(this%cards) .eq. 0) then
        dealt_card = create_card(" A", "D")
      else
        dealt_card = this%cards(size(this%cards))
        this%cards = this%cards(1:size(this%cards) - 1)
      end if
    end function deal_card

    subroutine print_deck(this)
      type(Deck), intent(in) :: this
      integer :: i

      if (size(this%cards) > 22) then
        ! Shuffled 52 card deck
        print *, "*** Shuffled 52 card deck:"
        do i = 1, 52
          write (*, '(A)', advance="no") card_to_string_opt(this%cards(i), 1) ! 1 to_string trims leading space
          if (mod(i, 13) .eq. 0) then
            print *
          end if
        end do
      else
        ! Here is what remains in the deck...
        print *, "*** Here is what remains in the deck..."
        do i = 1, size(this%cards)
          write (*, '(A)', advance="no") card_to_string_opt(this%cards(i), 1)
        end do
      end if
    end subroutine print_deck
    
    subroutine print_deck_test(this)
      type(Deck), intent(in) :: this
      integer :: i
      
      do i = 1, size(this%cards)
        write(*, *) "Card:", this%cards(i)
      end do
    end subroutine print_deck_test

end module DeckModule

!-------------------------------------------------------------------------------
! HandAlyzerModule
!-------------------------------------------------------------------------------

module HandAlyzerModule
  use CardModule
  implicit none

  type HandAlyzer
    type(Card), dimension(6, 5) :: player_hands
    integer, dimension(6, 7) :: score_keeper_all
    integer, dimension(6) :: score_keeper_winning_order
    integer, dimension(7) :: score_keeper_player 
    integer, dimension(7) :: score_keeper_player2
    character(30), dimension(6) :: player_hand_ranks
  end type HandAlyzer

  contains

    subroutine init_HandAlyzer(this, player_hands)
      type(HandAlyzer), intent(inout) :: this
      type(Card), dimension(6, 5), intent(inout) :: player_hands
      integer :: i, j

      do i = 1, 6 ! copy over player_hands
        do j = 1, 5
          this%player_hands(i, j) = player_hands(i, j)
        end do 
      end do 

      do i = 1, 6 ! set score keeper to 0
        do j = 1, 7
          this%score_keeper_all(i, j) = 0
        end do 
      end do  
    end subroutine init_HandAlyzer

    function get_hand_rank_string(handrank_val) result(handrank_str)
      character(20) :: handrank_str
      integer, intent(in) :: handrank_val
      
      select case (handrank_val)
          case (0)
            handrank_str = "High Card"
          case (1)
            handrank_str = "Pair"
          case (2)
            handrank_str = "Two Pair"
          case (3)
            handrank_str = "Three of a Kind"
          case (4)
            handrank_str = "Straight"
          case (5)
            handrank_str = "Flush"
          case (6)
            handrank_str = "Full House"
          case (7)
            handrank_str = "Four of a Kind"
          case (8)
            handrank_str = "Straight Flush"
          case (9)
            handrank_str = "Royal Straight Flush"
          case default
            handrank_str = "High Card"
        end select

    end function get_hand_rank_string

    ! --------------------------------------------------------------------
    ! HandAlyzer Hand Analysis and ranking functions
    !---------------------------------------------------------------------
    ! The general idea is that scores are tracked in a 2D array
    !   - integer score_keeper_all(6, 7) with 6 players, 7 tie breaking criteria
    !     -(p, 1) : handrank_val, value of the hand rank, 0->9 :: high card -> rsf
    !     -(p, 2) : value of highest card, first tier or handrank_val tiebreaking
    !     -(p, 3-6) : value of remaining tiers for tiebreaking
    !     -(p, 7) : value of suit of (p, 1), 1->4 :: D,C,H,S
    ! Once each player's hand is evaluated, each player is bubble sorted
    ! using score_keeper_all(6, 7) and adjusting integer(6) score_keeper_winning_order.
    ! The player(1-6) with the highest score will be score_keeper_winning_order(1)
    ! and the lowest score_keeper_winning_order(6). iterate through the winning order
    ! to print the corresponding player's hand and handrank_string
    !--------------------------------------------------------------------- 
    ! Below begins the process for printing the outcome and winners, 
    ! Further down are the functions and subroutines to determine handranks/ties
    !---------------------------------------------------------------------

    subroutine get_final_score_print(this)
      type(HandAlyzer), intent(inout) :: this
      character(30), dimension(6) :: hand_strings
      type(Card) :: temp_card
      integer :: player_rank_index_limit, player, criteria, current_hand_rank, i, j
      character(4) :: temp_card_str

      do i = 1, 6
          hand_strings(i) = ""
      end do
      
      do i = 1, 6
        current_hand_rank = get_hand_rank_int(this%player_hands(i, :), this%score_keeper_all(i, :))
        this%player_hand_ranks(i) = get_hand_rank_string(current_hand_rank)
        this%score_keeper_all(i, 1) = current_hand_rank
        
        do j = 1, 5
          temp_card = this%player_hands(i, j)
          temp_card_str = card_to_string_opt(temp_card, 1)
          hand_strings(i) = trim(hand_strings(i)) // " " // temp_card_str
          ! write (hand_strings(i), '(A)', advance="no") card_to_string_opt(this%player_hands(i, j), 1)
        end do

      end do
            
      do player_rank_index_limit = 1, 6
        do player = 1, 5
          if (this%score_keeper_all(player, 1) < this%score_keeper_all(player + 1, 1)) then
            call swap_hands(this, player, player + 1, hand_strings)
          else if (this%score_keeper_all(player, 1) .eq. this%score_keeper_all(player + 1, 1)) then
            do criteria = 2, 7
              if (this%score_keeper_all(player, criteria) < this%score_keeper_all(player + 1, criteria)) then
                call swap_hands(this, player, player + 1, hand_strings)
                exit
              else if (this%score_keeper_all(player, criteria) > this%score_keeper_all(player + 1, criteria)) then
                exit
              end if
            end do
          end if
        end do
      end do
                        
      print *, "--- WINNING HAND ORDER ---"
      do i = 1, 6
          print *, hand_strings(i), "-", get_hand_rank_string(this%score_keeper_all(i, 1))
      end do        
    end subroutine get_final_score_print

    function get_hand_rank_int(this_player_hand, this_score_keeper) result(handrank_int)
      type(Card), dimension(5), intent(in) :: this_player_hand
      integer, dimension(7), intent(inout) :: this_score_keeper
      integer :: handrank_int, temp_NOP

      handrank_int = 0
      temp_NOP = num_of_pairs(this_player_hand, this_score_keeper)

      if (is_straight_royal_flush(this_player_hand, this_score_keeper)) then 
        handrank_int = 7
      else if (is_straight_flush(this_player_hand, this_score_keeper)) then 
        handrank_int = 8
      else if (is_four_of_a_kind(this_player_hand, this_score_keeper)) then 
        handrank_int = 7
      else if (is_full_house(this_player_hand, this_score_keeper)) then 
        handrank_int = 6
      else if (is_three_of_a_kind(this_player_hand, this_score_keeper)) then 
        handrank_int = 3
      else if (temp_NOP == 2) then 
        handrank_int = 2
      else if (temp_NOP == 1) then 
        handrank_int = 1
      else  
        call get_high_card(this_player_hand, this_score_keeper)
        call get_high_card_tie_breakers(this_player_hand, this_score_keeper)
      end if 
    end function get_hand_rank_int

    subroutine swap_hands(this_handalyzer, player1, player2, hand_strings)
      type(HandAlyzer), intent(inout) :: this_handalyzer
      integer, intent(in) :: player1, player2
      character(30), dimension(6), intent(inout) :: hand_strings
      integer, dimension(7) :: temp_score_keeper
      character(20) :: temp_rank
      character(30) :: temp_hand
    
      ! Swap score_keeper_all arrays for player1 and player2
      temp_score_keeper = this_handalyzer%score_keeper_all(player1, :)
      this_handalyzer%score_keeper_all(player1, :) = this_handalyzer%score_keeper_all(player2, :)
      this_handalyzer%score_keeper_all(player2, :) = temp_score_keeper
    
      ! Swap player_hand_ranks for player1 and player2
      temp_rank = this_handalyzer%player_hand_ranks(player1)
      this_handalyzer%player_hand_ranks(player1) = this_handalyzer%player_hand_ranks(player2)
      this_handalyzer%player_hand_ranks(player2) = temp_rank
    
      ! Swap hand_strings for player1 and player2
      temp_hand = hand_strings(player1)
      hand_strings(player1) = hand_strings(player2)
      hand_strings(player2) = temp_hand
    end subroutine swap_hands


    !---------------------------------------------------------------------
    ! Logic for analyzing Hand Ranks
    !---------------------------------------------------------------------
    function is_straight_royal_flush(this_player_hand, this_score_keeper) result(is_rsf)
      type(Card), dimension(5) :: this_player_hand
      integer, dimension(7) :: this_score_keeper
      integer, dimension(13) :: cards_in_hand
      integer, dimension(5) :: rsf_values
      integer :: i, card_value, temp_rsf, temp_player
      logical :: is_rsf

      is_rsf = .true.
      rsf_values(1) = 13
      rsf_values(2) = 12
      rsf_values(3) = 11
      rsf_values(4) = 10
      rsf_values(5) = 1 ! predefined array of RSF rank values post high sort

      do i = 1, 13
        cards_in_hand(i) = 0 
      end do

      do i = 1, 5 
        card_value = this_player_hand(i)%rank_int
        cards_in_hand(card_value) = cards_in_hand(card_value) + 1
      end do 

      cards_in_hand = sort_array_high(cards_in_hand)

      do i = 1, 5 
        temp_player = cards_in_hand(i)
        temp_rsf = rsf_values(i) 
        if (temp_player /= temp_rsf) then 
          is_rsf = .false.
        else
          exit
        end if 
      end do

      if (is_flush(this_player_hand, this_score_keeper) .neqv. .true.) then 
        is_rsf = .false.
      end if 
    end function is_straight_royal_flush

    function is_straight(this_player_hand, this_score_keeper) result(bool)
      type(Card), dimension(5) :: this_player_hand
      integer, dimension(7) :: this_score_keeper
      integer, dimension(5) :: cards_in_hand
      integer :: i, card_value, j
      logical :: bool

      j = 0
      bool = .true.

      do i = 1, 5
        cards_in_hand(i) = this_player_hand(i)%rank_int
      end do
      cards_in_hand = sort_array_high(cards_in_hand)

      do i = 1, 4
        if ((cards_in_hand(i) + 1) .ne. (cards_in_hand(i + 1))) then 
          bool = .false.
        end if
      end do 

      if (bool) then 
        call get_high_card(this_player_hand, this_score_keeper)
      end if
    end function is_straight

    function is_flush(this_player_hand, this_score_keeper) result(bool)
      type(Card), dimension(5) :: this_player_hand
      integer, dimension(7) :: this_score_keeper
      integer, dimension(5) :: suits_in_hand
      integer :: i, suit_value
      logical :: bool

      bool = .true.
      
      do i = 1, 5
        suits_in_hand(i) = 0
      end do

      do i = 1, 5
        suits_in_hand(i) = this_player_hand(i)%suit_int
      end do

      do i = 1, 4
        if (suits_in_hand(i) .ne. suits_in_hand(i + 1)) then 
          bool = .false.
        end if
      end do

      if (bool) then 
        call get_high_card(this_player_hand, this_score_keeper)
        call get_high_card_tie_breakers(this_player_hand, this_score_keeper)
      end if
    end function is_flush

    function is_straight_flush(this_player_hand, this_score_keeper) result(bool)
      type(Card), dimension(5) :: this_player_hand
      integer, dimension(7) :: this_score_keeper
      logical :: bool

      bool = .false.

      if (is_straight(this_player_hand, this_score_keeper) .and. is_flush(this_player_hand, this_score_keeper)) then 
      call get_high_card(this_player_hand, this_score_keeper)
        bool = .true.
      end if
    end function is_straight_flush

    function is_full_house(this_player_hand, this_score_keeper) result(bool)
      type(Card), dimension(5) :: this_player_hand
      integer, dimension(7) :: this_score_keeper
      logical :: bool, temp_IS, temp_IF

      bool = .false.
      temp_IS = is_straight(this_player_hand, this_score_keeper)
      temp_IF = is_flush(this_player_hand, this_score_keeper)

      if (temp_IS .and. temp_IF) then 
      call get_high_card(this_player_hand, this_score_keeper)
        bool = .true.
      end if
    end function is_full_house

    function num_of_pairs(this_player_hand, this_score_keeper) result(pairs_found)
      type(Card), dimension(5) :: this_player_hand
      type(Card) :: temp_card
      integer, dimension(7) :: this_score_keeper
      integer, dimension(13) :: cards_in_hand
      integer, dimension(2) :: pair_ranks
      integer :: i, j, card_value, pairs_found, kicker_rank, temp_PR, temp_CHR

      do i = 1, 13
        cards_in_hand(i) = 0 
      end do
      pair_ranks(1) = 0
      pair_ranks(2) = 0
      pairs_found = 0
      j = 3

      do i = 1, 5 
        temp_card = this_player_hand(i)
        card_value = temp_card%rank_int
        cards_in_hand(card_value) = cards_in_hand(card_value) + 1
      end do 

      do i = 1, 13
        card_value = cards_in_hand(i)
        if (card_value == 2) then 
          pairs_found = pairs_found + 1 
          pair_ranks(pairs_found) = 14 ! hard coded for aces tie breaking
        else if (cards_in_hand(i) .eq. 1) then 
          kicker_rank = i
        end if 
      end do 

      if (pairs_found == 1) then 
        cards_in_hand = sort_array_high(cards_in_hand)
        do i = 1, 5 
          temp_CHR = cards_in_hand(i)
          temp_PR = pair_ranks(1) 
          if (temp_CHR /= temp_PR) then
            this_score_keeper(j) = cards_in_hand(i)
            j = j + 1
          end if
        end do
        this_score_keeper(2) = pair_ranks(1) 
        this_score_keeper(7) = kicker_rank
      else if (pairs_found .eq. 2) then 
        this_score_keeper(2) = pair_ranks(1)
        this_score_keeper(3) = pair_ranks(2)
        this_score_keeper(7) = kicker_rank
      end if
    end function num_of_pairs

    function is_three_of_a_kind(this_player_hand, this_score_keeper) result(bool)
      type(Card), dimension(5), intent(in) :: this_player_hand
      integer, dimension(7), intent(inout) :: this_score_keeper
      integer, dimension(13) :: cards_in_hand
      integer :: i, card_value
      logical :: bool

      bool = .false.

      do i = 1, 13
        cards_in_hand(i) = 0 
      end do

      do i = 1, 5 
        card_value = this_player_hand(i)%rank_int
        cards_in_hand(card_value) = cards_in_hand(card_value) + 1
      end do 

      do i = 1, 13
        if (cards_in_hand(i) .eq. 3) then 
          bool = .true.
          if (i .eq. 0) then 
            this_score_keeper(2) = 14 ! hard coded for aces tie breaking
          else
            this_score_keeper(2) = i
          end if
        end if 
      end do 
    end function is_three_of_a_kind

    function is_four_of_a_kind(this_player_hand, this_score_keeper) result(bool)
      type(Card), dimension(5) :: this_player_hand
      integer, dimension(7) :: this_score_keeper
      integer, dimension(13) :: cards_in_hand
      integer :: i, card_value
      logical :: bool

      bool = .false.

      do i = 1, 13
        cards_in_hand(i) = 0 
      end do

      do i = 1, 5 
        card_value = this_player_hand(i)%rank_int
        cards_in_hand(card_value) = cards_in_hand(card_value) + 1
      end do 

      do i = 1, 13
        if (cards_in_hand(i) .eq. 4) then 
          bool = .true.
          if (i .eq. 0) then 
            this_score_keeper(2) = 14 ! hard coded for aces tie breaking
          else
            this_score_keeper(2) = i
          end if
        end if 
      end do 
    end function is_four_of_a_kind


    ! --------------------------------------------------------------------
    ! get High Card, and get High Card Tie breakers below
    ! --------------------------------------------------------------------
    subroutine get_high_card(this_player_hand, this_score_keeper)
      type(Card), dimension(5) :: this_player_hand
      integer, dimension(7) :: this_score_keeper
      integer :: i, j, temp_TPH_R, temp_TPH_S, temp_CHC_R, temp_CHC_S 
      type(Card) :: current_high_card
      logical :: ace_found

      current_high_card = create_card_str(" AD") ! the lowest value card for comparison
      ace_found = .false.

      do i = 1, 5 
        temp_CHC_R = current_high_card%rank_int
        temp_TPH_R = this_player_hand(i)%rank_int
        temp_CHC_S = current_high_card%suit_int
        temp_TPH_S = this_player_hand(i)%suit_int

        if (temp_TPH_R .eq. 1) then 
          if (temp_TPH_R .ne. 1) then 
            current_high_card = this_player_hand(i)
          else if (temp_TPH_S > temp_CHC_S) then 
            current_high_card = this_player_hand(i)
          end if
          ace_found = .true.
        else if (temp_TPH_R > temp_CHC_R)  then
          current_high_card = this_player_hand(i)
          else if (temp_TPH_R .eq. temp_CHC_R) then 
            if (temp_TPH_S > temp_CHC_S)  then 
              current_high_card = this_player_hand(i)
            end if 
          end if
      end do

      if (ace_found) then 
        this_score_keeper(2) = 14 ! hard coded aces as 14 for tie breakers
      else
        this_score_keeper(2) = current_high_card%rank_int
      end if 
      this_score_keeper(7) = current_high_card%suit_int
    end subroutine get_high_card

    subroutine get_high_card_tie_breakers(this_player_hand, this_score_keeper) 
      type(Card), dimension(5) :: this_player_hand
      integer, dimension(7) :: this_score_keeper
      integer, dimension(5) :: current_hand_ranks
      integer :: i, j 

      do i = 1, 5 
        current_hand_ranks(i) = this_player_hand(i)%rank_int
        if (current_hand_ranks(i) .eq. 1) then 
          current_hand_ranks(i) = 14 ! hard coded aces as 14 for tie breakers
        end if
      end do

      current_hand_ranks = sort_array_high(current_hand_ranks)

      do i = 3, 6 
        this_score_keeper(i) = current_hand_ranks(i - 1)
      end do
    end subroutine get_high_card_tie_breakers

    ! helper function to sort int(x) highest to lowest
    function sort_array_high(this_array) result(sorted_array)
      integer, dimension(:), intent(in) :: this_array
      integer, dimension(size(this_array)) :: sorted_array
      integer :: i, j, temp
        
      ! copy original array
      sorted_array = this_array
        
      ! bubble sort algorithm to sort in descending order
      do i = 1, size(sorted_array) - 1
        do j = 1, size(sorted_array) - i
          if (sorted_array(j) < sorted_array(j + 1)) then
            ! Swap elements if they are out of order
            temp = sorted_array(j)
            sorted_array(j) = sorted_array(j + 1)
            sorted_array(j + 1) = temp
          end if
        end do
      end do
    end function sort_array_high

end module HandAlyzerModule

!-------------------------------------------------------------------------------
! tableTest program // MAIN!
!-------------------------------------------------------------------------------
program tableTest
  use DeckModule
  use CardModule
  use HandAlyzerModule

  implicit none


  character(80) :: file_name  !Character variable to store input file name
  character(len=*), parameter :: file_path = "/home/wilcox_we/FCWW/forDir/handsets/"
  character(:), allocatable :: full_file_path
  integer :: i, j, num_args, game_mode  ! Variables to hold argument count
  type(Card), dimension(6, 5) :: player_hands
  type(Deck) :: deck_reg_game
  type(Card) :: card_drawn
  type(HandAlyzer) :: game_handalyzer
  
  ! Get the number of command-line arguments
  num_args = COMMAND_ARGUMENT_COUNT()

  ! Initialize deck_reg_game
  call create_deck(deck_reg_game) 

  ! Check if any arguments were provided
  if (num_args .eq. 0) then
      game_mode = 0 ! Standard Game Mode
  else
      game_mode = 1 ! File input Game Mode
  end if

  print *, "*** P O K E R  H A N D  A N A L Y Z E R ***"
  print *
  print *

  if (game_mode .eq. 0) then ! creates player_hands based on gamemode
      print *, "*** USING RANDOMIZED DECK OF CARDS ***"
      print *
      call print_deck(deck_reg_game)
      print *
      ! Deal cards to player_hands
      do i = 1, 6
          do j = 1, 5
              card_drawn = deal_card(deck_reg_game)
              player_hands(i, j) = card_drawn
          end do 
      end do 
  else
      print *, "*** USING TEST DECK ***"
      print *
      call GET_COMMAND_ARGUMENT(1, file_name)
      full_file_path = file_path // file_name
      print *, "***File: " // file_name
      player_hands = create_deck_from_filename(full_file_path) ! also prints file out
  end if

  call print_hands(player_hands)
  print *

  ! initialize and pass 
  call init_HandAlyzer(game_handalyzer, player_hands)
  call get_final_score_print(game_handalyzer)


  ! ----------------------------------------
  ! Main Program Functions/Subroutines below
  ! ----------------------------------------
  contains

  subroutine print_hands(player_hands)
      type(Card), dimension(6, 5), intent (in) :: player_hands
      integer :: i, j

      print *, "*** Here are the six hands..."

      do i = 1, 6
          do j = 1, 5
          write (*, '(A)', advance="no") card_to_string_opt(player_hands(i, j), 1)
          end do
        print *  
      end do 
  end subroutine print_hands

  function create_card_from_parse(lineOfText, card_number) result(new_card)
    character(19) :: lineOfText
    character(3) :: string_card
    type(Card) :: new_card
    integer, intent(in) :: card_number
    integer :: card_location
    
    card_location = ((card_number - 1) * 4) + 1 ! determines where in lineOfText to search

    string_card = lineOfText(card_location:card_location + 2)

    new_card = create_card_str(string_card)
  end function create_card_from_parse

  function create_deck_from_filename(full_file_path) result(player_hands)
    character(19) :: lineOfText
    character(:), allocatable :: full_file_path
    type(Card), dimension(6, 5) :: player_hands
    type(Card) :: new_card
    integer :: io, i, j
    
    open(unit=5,file=full_file_path,status="old")
    do i = 1, 6
      read (5,"(a19)",iostat=io) lineOfText
      if (io/=0) exit
      print *, lineOfText 
      do j = 1, 5
        new_card = create_card_from_parse(lineOfText, j)
        player_hands(i, j) = new_card
      end do
    end do
    close(5)
  end function create_deck_from_filename

end program tableTest
