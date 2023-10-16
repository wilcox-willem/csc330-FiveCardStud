! Willem Wilcox, CSC330, Dr. Pounds, 10/08/23
!-------------------------------------------------------
! CardModule
!-------------------------------------------------------
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
      if (this%rank_int == 10) then
        if (opt == 2) then
          card_str = this%rank // this%suit // ", "
        else if (opt == 1) then
          card_str = this%rank // this%suit // " "
        else if (opt == 0) then 
          card_str = this%rank // this%suit
        end if
      else 
        if (opt == 2) then
          card_str = this%rank // this%suit
          card_str = trim(adjustl(card_str(2:))) // ", "
        else if (opt == 1) then
          card_str = this%rank // this%suit
          card_str = trim(adjustl(card_str(2:))) // " "
        else if (opt == 0) then 
          card_str = this%rank // this%suit
        end if
      end if
    end function card_to_string_opt

    logical function are_cards_equal(this, other)
      type(Card), intent(in) :: this, other
      are_cards_equal = this%rank == other%rank .and. this%suit == other%suit
    end function are_cards_equal

end module CardModule

!-------------------------------------------------------
! DeckModule
!-------------------------------------------------------
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

      if (size(this%cards) == 0) then
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
          if (mod(i, 13) == 0) then
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

!-------------------------------------------------------
! tableTest program // MAIN!
!-------------------------------------------------------
program tableTest
  use DeckModule
  use CardModule
  implicit none

  character(80) :: file_name  !Character variable to store input file name
  character(len=*), parameter :: file_path = "/home/wilcox_we/FCWW/forDir/handsets/"
  character(:), allocatable :: full_file_path
  integer :: i, j, num_args, game_mode  ! Variables to hold argument count
  type(Card), dimension(6, 5) :: player_hands
  type(Deck) :: deck_reg_game
  type(Card) :: card_drawn
  
  ! Get the number of command-line arguments
  num_args = COMMAND_ARGUMENT_COUNT()

  ! Initialize deck_reg_game
  call create_deck(deck_reg_game) 

  ! Check if any arguments were provided
  if (num_args == 0) then
      game_mode = 0 ! Standard Game Mode
  else
      game_mode = 1 ! File input Game Mode
  end if

  print *, "*** P O K E R  H A N D  A N A L Y Z E R ***"
  print *
  print *

  if (game_mode == 0) then
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
      call print_hands(player_hands)
  else
      print *, "*** USING TEST DECK ***"
      print *
      call GET_COMMAND_ARGUMENT(1, file_name)
      full_file_path = file_path // file_name
      !call print_imported_file(full_file_path) ! TEST TEST TEST TEST TEST
      print *, "***File: " // file_name
      player_hands = create_deck__from_filename(full_file_path)
      call print_hands(player_hands)
  endif


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

  ! modified version of in class example csv tokenizer
  subroutine get_next_token( inline, outline, token)
    character (*) :: inline
    character(:), allocatable :: outline, token
    integer :: i, j
    logical :: foundFirst, foundLast
    ! Initialize variables used to control loop
    foundFirst = .false.
    foundLast  = .false.
    i = 0
    ! find first comma
    do while ( .not. foundFirst .and. (i < len(inline)))
        if (inline(i:i) .eq. ",") then
            i = i + 1
        else
            foundFirst = .true.
        endif
    enddo
    j = i
    do while ( foundFirst .and. .not. foundLast .and. ( j < len(inline)))
        if (inline(j:j) .ne. ",") then
            j = j + 1
        else
            foundLast = .true.
        endif
    enddo
    ! WW: Changes made
      !previous version
        ! token = trim(inline(i:j))
        ! outline = trim(inline(j+1:len(inline)))
    !New version below, checks if foundFirst or foundLast, to handle if last item or not
    if (.not. foundLast) then
      token = trim(inline(i:j))
      outline = trim(inline(j+2:len(inline)))
    else
      token = trim(inline(i:j -1)) !the (i:j -1) removes comma from first 4 items
      outline = trim(inline(j+2:len(inline)))
    endif
  end subroutine get_next_token

  ! modified version of in class example csv tokenizer
  function create_deck_str(file_name) result(imported_hands)
    character(80), intent(in) :: file_name
    type(Card), dimension(6, 5) :: imported_hands
    type(Card) :: imported_card
    integer :: i, j, io
    character(:), allocatable :: line, outline, word

    i = 1 ! tracks the current player to give cards
    j = 1 ! tracks the position in hand to give the card    
    
    open(unit=5, file=file_name, status='old')
    do
      read(5,'(a19)',iostat=io) line
      if (io/=0) exit
      print *, line

      outline = line
  
      do while (len(outline) .ne. 0)
        call get_next_token( line, outline, word)
        print *, word
        imported_card = create_card_str(word)
        imported_hands(i, j) = imported_card
        j = j + 1
        
        if (j .eq. 7) then
          i = i + 1
          j = 1
        endif
        line = outline
      end do
    end do
    6 close(50)
  end function create_deck_str

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

  function create_deck__from_filename(full_file_path) result(player_hands)
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
  end function create_deck__from_filename



  subroutine print_imported_file(full_file_path)
    character(19) :: lineOfText
    character(:), allocatable :: full_file_path
    integer :: io
  
    open(unit=5,file=full_file_path,status="old")
    do
      read (5,"(a19)",iostat=io) lineOfText
      if (io/=0) exit
      print *, lineOfText
    end do

    close(5)
  end subroutine print_imported_file
end program tableTest
