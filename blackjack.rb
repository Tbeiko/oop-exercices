# blackjack.rb

One or more player plays against the dealer.
The dealer hands two cards to the players, and takes ones for himself.

Each player calculates the sum of his cards
  => cards 2-10 are worth their value
  => Jack, Queen and King are worth 10
  => Ace is either worth 1 or 11

If the sum is over 21, they bust and lose.
If the sum is 21, they have a blackjack and win.
If the sum is under 21, they can either hit or stay.

If they chose to hit, they get another card. 
  The value is calculated again.
If they chose to stay, it is the next players turn
If every player has played, it is the dealers turn.

The dealer gets a second card.
  The sum of his cards is calculated 
  until the sum is >= 17, he has to hit and get another card
  The sum is calculated
    If the sum is over 21, he bust and lose
    if the sum == 21, he wins
    if the sum > each players sum, he wins.
    if the sum < player sum, he gets another card.
    The sum is calculated 

A message explaining the outcome is displayed
The totals are displayed 

the player is asked if he wants to play another hand 

class Deck 
  attr_accessor :cards

  def shuffle
  end

  def draw_card
  end

end

class Player
  attr_accessor :name, :hand 

  def calculate_hand_total
  end

  def hit
  end

  def stay
  end

end

class User < Player 
end

class Computer < Player
end

class Blackjack

end