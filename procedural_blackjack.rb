# Blackjack.rb

# Constants
ACE   = "ACE"
JACK  = "JACK"
QUEEN = "QUEEN"
KING  = "KING"

def say(msg)
  puts ("=> #{msg}")
end

def hand_card_to_player(player_hand, deck)
  card = deck.shift 
  player_hand.push(card)
end

def describe_player_hand(player_hand)
    puts
    player_hand.each do |card|
      puts "#{card[1]} of #{card[0]}"
    end
    puts
end

def calculate_hand_total(player_hand, player_total)
  player_total = 0 
  player_hand.each do |card|
    if card[1] == ACE
      player_total += 11
    elsif (card[1] == JACK) || (card[1] == QUEEN) || (card[1] == KING)
      player_total += 10
    else
      player_total += card[1]
    end
  end

  player_hand.select{|card| card[1] == ACE}.count.times do
    player_total -= 10 if player_total > 21
  end

  player_total
end 

def assert_if_blackjack_or_bust(player_hand, player_total)
  if calculate_hand_total(player_hand, player_total) == 21
    say "BLACKJACK!"
    @game_still_on = false
    @blackjack = true 
  elsif calculate_hand_total(player_hand, player_total) > 21
    say "BUST!"
    @game_still_on = false
  else 
    @game_still_on = true
  end
end

def dealer_winning?(player_hand, player_total, dealer_hand, dealer_total)
  calculate_hand_total(player_hand, player_total) < calculate_hand_total(dealer_hand,dealer_total)
end

puts
say "Good evening sir, welcome to the blackjack table at Tim's Casino."
puts
sleep 0.25
say "May I have your name ?"
USER_NAME = gets.chomp
say "Thank you, #{USER_NAME}."
sleep 0.25


begin

  system 'cls'

  want_to_play = true
  @game_still_on = true
  @blackjack = false
  want_to_hit = true 

  game_deck = []
  suits = ['HEARTS', 'DIAMONDS', 'SPADES', 'CLOVES']
  cards = [ACE,2,3,4,5,6,7,8,9,10,JACK,QUEEN,KING]

  game_deck = suits.product(cards)
  game_deck.shuffle!

  # Hand the player two cards
  user_hand = []
  user_total = 0 
  2.times {hand_card_to_player(user_hand, game_deck)}
  # Tell the player his hand
  say "Your cards are:"
  describe_player_hand(user_hand)
  sleep 0.5
  calculate_hand_total(user_hand, user_total)
  assert_if_blackjack_or_bust(user_hand, user_total)

  # Only way this won't run is if blackjack on opening.
  if @game_still_on
    # Hand the dealer one card 
    dealer_hand = []
    dealer_total = 0

    hand_card_to_player(dealer_hand, game_deck)
    # tell the player the dealers hand 
    say "The dealer's first card is:"
    describe_player_hand(dealer_hand)
    sleep 0.5
  end

  # Ask the player if he wants to hit or pass.
  # This will run until Bust/Blackjack or the player stops it.
  while want_to_hit && @game_still_on
    begin
      say "Do you want another card, #{USER_NAME} ? (yes/no)"
      wants_another_card = gets.chomp.downcase
      if wants_another_card == 'yes'
        say "There you go."
        sleep 0.5
        hand_card_to_player(user_hand, game_deck)
      elsif wants_another_card == 'no'
        say "Okay then."
        want_to_hit = false
      else
        say "I'm sorry, I didn't get that. Please answer by 'yes' or 'no' "
      end
      say "Your cards are:"
      describe_player_hand(user_hand)
      calculate_hand_total(user_hand, user_total)
      assert_if_blackjack_or_bust(user_hand, user_total)
    end until (wants_another_card == 'yes') || (wants_another_card == 'no')
  end 

  puts "Your total is:"
  say calculate_hand_total(user_hand, user_total)
  sleep 0.5

  # If the player hasn't busted or blackjacked, the dealer must hit until having at least 17.
  if @game_still_on
    while calculate_hand_total(dealer_hand, dealer_total)<17
      puts "Another card is handed to the dealer"
      hand_card_to_player(dealer_hand, game_deck)
      sleep 1
      say "The dealer's cards are:"
      describe_player_hand(dealer_hand)
      sleep 1
      calculate_hand_total(dealer_hand, dealer_total)
      assert_if_blackjack_or_bust(dealer_hand, dealer_total)
      if @game_still_on == false && @blackjack == false
        puts "You win the hand!"
      end
    end 
  end 

  # If both players have the same hand, it's a tie. This can only happen when the dealer's total is >= 17
  unless @blackjack
    if calculate_hand_total(dealer_hand, dealer_total) == calculate_hand_total(user_hand, user_total)
      say "It's a tie."
      @game_still_on = false
    end
  end

  # If the dealer total is > 17 and he has a larger total than the user, the dealer wins.
  if @game_still_on && dealer_winning?(user_hand, user_total, dealer_hand, dealer_total)
    say "The dealer beat you."
    @game_still_on = false 
  end

  # If the dealer total is > 17 and he has a lower total than the user, he will continue until either he wins or busts.
  if @game_still_on && !dealer_winning?(user_hand, user_total, dealer_hand, dealer_total)
  
    say "Things are getting serious."
    sleep 0.25

    begin 

      puts "Another card is handed to the dealer"
      hand_card_to_player(dealer_hand, game_deck)
      sleep 1
      say "The dealer's cards are:"
      describe_player_hand(dealer_hand)
      sleep 1
      calculate_hand_total(dealer_hand, dealer_total)
      assert_if_blackjack_or_bust(dealer_hand, dealer_total)
      if @game_still_on == false && @blackjack == false 
        puts "You win the hand!"
      end

    end until !@game_still_on || dealer_winning?(user_hand, user_total, dealer_hand, dealer_total)

  if dealer_winning?(user_hand, user_total, dealer_hand, dealer_total) && @game_still_on 
    puts "The dealer won the hand."
    @game_still_on = false
  end

  end

  puts "The dealer's total is:"
  say calculate_hand_total(dealer_hand, dealer_total)

  say "Another hand, #{USER_NAME}? (yes/no)"
  wants_to_play_again = gets.chomp.downcase
  if (wants_to_play_again == "yes") || (wants_to_play_again == "y")
    want_to_play == true
  else
    want_to_play == false
    break
  end

end until want_to_play == false

say "Thank you for playing, #{USER_NAME}."
say "I hope we'll see you again soon!"