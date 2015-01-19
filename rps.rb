# rps.rb 
# Rock, Paper, Scissors game

# We have two players. 
# Every turn, they both select either rock, paper or Scissors
# We compare their hands. 
# Rock beats scissors beats paper beats rock 

class Player
  include Comparable
  attr_accessor :name, :hand
  
  def to_s
    "#{name} currently has a choice of #{self.hand}!"
  end

  def <=>(another_player)
    if  self.hand == another_player.hand 
      0
    elsif (self.hand == 'p' && another_player.hand == 'r') || (self.hand == 'r' && another_player.hand = 's') ||
          (self.hand == 's' && another_player.hand == 'p')
      1
    else
      -1
    end 
  end


  def display_winning_message
    case hand
    when 'p'
      puts "Paper wraps Rock!"
    when 'r'
      puts "Rock smashes Scissors!"
    when 's'
      puts "Scissors cuts paper!"
    end
  end
end

class User < Player
  def initialize
    puts "What's your name?"
    @name = gets.chomp
  end

  def pick_hand
    begin
      puts "Chose either Rock (r), Paper (p) or Scissors (s). Use the letter."
      choice = gets.chomp.downcase.to_s
    end until Game::CHOICES.keys.include?(choice)
    self.hand = choice 
  end

end

class Cpu < Player

  def initialize(n)
    @name = n
  end

  def pick_hand
    self.hand = Game::CHOICES.keys.sample
  end

end

class Game 
  CHOICES = {'p' => 'Paper', 'r'=> 'Rock', 's' => "Scissors"}
  attr_reader :user, :computer


  def initialize
    @user = User.new
    @computer = Cpu.new("Computer")
  end

  def compare_hands
    if user.hand == computer.hand
      puts "It's a tie!"
    elsif user.hand > computer.hand
      user.display_winning_message
      puts "#{user.name} won!"
    else 
      computer.display_winning_message
      puts "#{computer.name} won!"
    end
  end

  def wants_to_play?
    puts "Do you want to play again? (y/n)"
    answer = gets.chomp.downcase
    if (answer == 'y' )|| (answer == 'yes')
      true
    else 
      false
    end
  end


  def run
    begin
      user.pick_hand
      computer.pick_hand
      sleep 0.5
      puts user
      puts computer 
      sleep 0.25
      compare_hands
    end until wants_to_play? == false
  end
end

game = Game.new.run