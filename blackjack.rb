# blackjack.rb

# One or more player plays against the dealer.
# The dealer hands two cards to the players, and takes ones for himself.

# Each player calculates the sum of his cards
#   => cards 2-10 are worth their value
#   => Jack, Queen and King are worth 10
#   => Ace is either worth 1 or 11

# If the sum is over 21, they bust and lose.
# If the sum is 21, they have a blackjack and win.
# If the sum is under 21, they can either hit or stay.

# If they chose to hit, they get another card. 
#   The value is calculated again.
# If they chose to stay, it is the next players turn
# If every player has played, it is the dealers turn.

# The dealer gets a second card.
#   The sum of his cards is calculated 
#   until the sum is >= 17, he has to hit and get another card
#   The sum is calculated
#     If the sum is over 21, he bust and lose
#     if the sum == 21, he wins
#     if the sum > each players sum, he wins.
#     if the sum < player sum, he gets another card.
#     The sum is calculated 

# A message explaining the outcome is displayed
# The totals are displayed 

# the player is asked if he wants to play another hand 

module Sayable
  def say(msg)
    puts "=> #{msg}"
  end
end

class Deck 
  attr_accessor :cards
  SUITS = ['HEARTS', 'DIAMONDS', 'SPADES', 'CLOVES']
  CARDS = ['ACE', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'JACK', 'QUEEN', 'KING']

  def initialize
    @cards = SUITS.product(CARDS).shuffle!
  end

end

class Player
  attr_accessor :name, :hand, :total
  include Sayable

  def draw_card(deck)
    card = deck.cards.pop 
    self.hand.push(card)
  end

  def describe_player_hand
    puts
    if self.hand.count == 1
      puts "#{self.name}'s first card is :"
    elsif self.hand.count > 1
      puts "#{self.name}'s cards are:"
    end   
    puts
    self.hand.each do |card|
      puts "#{card[1]} of #{card[0]}"
    end
    puts
  end

  def calculate_player_total
    self.total = 0 
    self.hand.each do |card|
      if card[1] == 'ACE'
        self.total += 11
      elsif (card[1] == 'JACK') || (card[1] == 'QUEEN') || (card[1] == 'KING')
        self.total += 10
      else
        self.total += card[1]
      end
    end

    self.hand.select{|card| card[1] == 'ACE'}.count.times do
      self.total -= 10 if self.total > 21
    end

    self.total
  end 

end

class User < Player 

  def initialize
    @hand  = []
    @total = 0
  end

end

class Computer < Player
  def initialize(name)
    @name  = name
    @hand  = []
    @total = 0
  end
end

class Blackjack
  attr_accessor :name

  include Sayable
  @@game_count = 0

  def initialize
    @@game_count += 1 
    @user = User.new
  end

  def greet(user)
    puts
    say "Good evening sir, welcome to the blackjack table at Tim's Casino."
    puts
    sleep 0.25
    say "May I have your name ?"
    user.name  = gets.chomp
    say "Thank you, #{user.name}."
  end

  def assert_if_blackjack_or_bust(player)
    sleep 0.5
    if player.total == 21
      say "BLACKJACK"
      puts "#{player.name} won!"
      @blackjack = true
    elsif player.total > 21
      say "BUST"
      puts "#{player.name} lost!"
      @bust = true
    end
  end

  def hit_or_stay(player, deck)
    begin
      want_to_hit = true
      say "Do you want another card, #{player.name} ? (yes/no)"
      wants_another_card = gets.chomp.downcase
        if wants_another_card == 'yes'
          say "There you go."
          player_gets_a_card(player, deck)
        elsif wants_another_card == 'no'
          say "Okay then."
          player.describe_player_hand
          want_to_hit = false
        else
          say "I'm sorry, I didn't get that. Please answer by 'yes' or 'no' "
        end
    end until @blackjack || @bust || want_to_hit == false
  end

  def player_gets_a_card(player, deck)
    player.draw_card(deck)
    unless player.hand.count == 1 && player.class == User 
      player.describe_player_hand
    end
    player.calculate_player_total
    assert_if_blackjack_or_bust(player)
  end

  def dealer_plays(dealer, user, deck)
    # Dealer must reach at least 17
    unless @blackjack || @bust 
      begin
        sleep 1
        puts "The dealer gets another card."
        player_gets_a_card(dealer, deck)
      end until @blackjack || @bust || dealer.total >= 17
    end
    # Dealer will go on until he beats user or busts or blackjacks
    unless @blackjack || @bust
      puts "Things are getting serious!"
      sleep 1
      begin
        puts "The dealer gets another card."
        player_gets_a_card(dealer, deck)
        sleep 1
      end until @blackjack || @bust || dealer.total > user.total 
    end
  end

  def display_final_scores(user, dealer)
    unless @blackjack
      say "House total : #{dealer.total}"
      say "Your total  : #{user.total}"
      unless @bust
        if @dealer.total > @user.total
          puts "The house wins."
        else
          puts "You win."
        end
      end
    end
  end

  def reset
    @user.hand  = []
    @user.total = 0
    @dealer = Computer.new("Dealer")
    @deck   = Deck.new
    @blackjack = false 
    @bust = false 
    system 'cls'
  end

  def another_game?
    puts "Another game? (yes/no)"
    play_again = gets.chomp.downcase
    if play_again == 'yes' || play_again == 'y'
      true
    else 
      false
    end
  end

  def play
    greet(@user)
    sleep 0.5
    begin
      reset
      2.times{player_gets_a_card(@user, @deck)}
      unless @blackjack
        sleep 1
        player_gets_a_card(@dealer, @deck)
        hit_or_stay(@user, @deck)
      end
      dealer_plays(@dealer, @user, @deck)
      display_final_scores(@user, @dealer)
    end until (another_game? == false) 
    say "Thank you for playing!"
  end

end

game = Blackjack.new.play