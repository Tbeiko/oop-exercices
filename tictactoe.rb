# tictactoe.rb 
# Tic Tac Toe Game created with OOP programming 

# REQUIREMENTS
# We want to have two players who take turns putting their mark on a 9X9 board. 
# To win, a player must have three consectutive marks.
# When playing, the player must first asses if his opponent has two of his marks in a row.
# If so, the player blocks the third spot.
# elsif the player must asses if HE has two of his marks in a row
#   If so, and the third spot is empty, he puts his mark and win
# else the player simply choses an empty square at random

# After each players turn, we asses if there is a winner.
# If there is no winner, we asses if there are any empty spots left
#   if so -> next player plays 
#   else TIE 

# After the game, we ask the player if he wants to play again.

class Player 
  attr_accessor :name, :marker

  def initialize(name, marker)
    @name   = name
    @marker = marker
  end

  def choose_a_square(board)
    if board.available_squares

      begin
      puts "Choose an empty square from #{board.available_squares}"
      choice = gets.chomp.to_i 
      end until board.available_squares.include?(choice)
      board.mark_square(choice, self.marker)
    end
  end

end

class User < Player
  attr_accessor :name

  def initialize(marker)
    puts "What is your name ?"
    @name = gets.chomp
    puts "Welcome to Tic Tac Toe, #{self.name}"
    sleep 0.5
    @marker = marker
  end

end

class Cpu < Player 

  def choose_a_square(board)
    count_1 = board.available_squares.count 
    attack(board)
    count_2 = board.available_squares.count 
    if count_1 == count_2
      defend(board)
    end
    count_3 = board.available_squares.count 
    if count_1 == count_3
      pick_random_square(board)
    end
  end

  def attack(board)
    board.square_to_attack?(self)
  end

  def defend(board)
    board.square_to_defend?(self)
  end

  def pick_random_square(board)
    choice = board.available_squares.sample 
    board.mark_square(choice, self.marker)
  end

end

class Board 

  attr_accessor :squares
  attr_reader :name, :marker

  WINNING_LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

  def initialize
    @squares = {1 => " ", 2 => " ", 3 => " ",
                4 => " ", 5 => " ", 6 => " ",
                7 => " ", 8 => " ", 9 => " "}
  end

  def draw_board
    system 'cls'
    puts "   |   |   "
    puts " #{squares[1]} | #{squares[2]} | #{squares[3]}"
    puts "   |   |   "
    puts "---+---+---"
    puts "   |   |   "
    puts " #{squares[4]} | #{squares[5]} | #{squares[6]}"
    puts "   |   |   "
    puts "---+---+---"
    puts "   |   |   "
    puts " #{squares[7]} | #{squares[8]} | #{squares[9]}"
    puts "   |   |   "
  end

  def available_squares
    @squares.select{|_,v| v == " "}.keys
  end

  def all_squares_taken
    available_squares == []
  end

  def mark_square(choice, marker)
    @squares[choice] = marker
  end

  # Checks if two of the same marker in a winning row, if so, returns the empty square from that row.
  def two_in_a_row(hash, marker)
    if hash.values.count(marker) == 2
      hash.select{|k,v| v == " "}.keys.first
    else
      false
    end
  end 

  def square_to_defend?(player)
    WINNING_LINES.each do |line|
    @defendable_square = self.two_in_a_row({line[0] => @squares[line[0]], line[1] => @squares[line[1]],  
                         line[2] => @squares[line[2]]}, "X")
      if @defendable_square
        mark_square(@defendable_square, player.marker)
        break
      end
    end
  end

  def square_to_attack?(player)
    WINNING_LINES.each do |line|
    @attackable_square = self.two_in_a_row({line[0] => @squares[line[0]], line[1] => @squares[line[1]],  
                         line[2] => @squares[line[2]]}, "O")
      if @attackable_square
        mark_square(@attackable_square, player.marker)
        break
      end
    end
  end

  def three_in_a_row(marker)
    WINNING_LINES.each do |line|
      return true if (@squares[line[0]] == marker) && (@squares[line[1]] == marker) &&
      (@squares[line[2]] == marker)
      end
    false
  end

  def assert_if_win(player)
    if all_squares_taken
      puts "It's a tie!"
      sleep 1
    elsif three_in_a_row(player.marker)
      puts "TIC TAC TOE"
      sleep 0.5
      puts "#{player.name} wins!"
      sleep 1
    else
    end
  end

end


class TicTacToe


  def initialize
    @user1      = User.new("X")
    @computer   = Cpu.new("Computer", "O")
  end

  def select_first_player
    random = [1,2].sample
    if random == 1
      @current_player = @user1
    else
      @current_player = @computer
    end
  end


  def alternate_player
    if @current_player == @user1
      @current_player = @computer
    else 
      @current_player = @user1
    end
  end

  def run
    begin
    play_again = true  
    @game_board = Board.new
    select_first_player
      begin
        alternate_player
        @game_board.draw_board
        if @current_player == @computer
          puts "Computer is strategizing"
          sleep 1
        end
        @current_player.choose_a_square(@game_board)
        @game_board.draw_board
        @game_board.assert_if_win(@current_player)
      end until @game_board.all_squares_taken || @game_board.three_in_a_row(@current_player.marker)

      puts "Play Again? (y/n)"
      again = gets.chomp.downcase
        if again == 'y' || again == 'yes'
          play_again = true
        else
          play_again = false
        end
    end until play_again == false

    puts "Thanks for playing!"
  end
end

@newgame = TicTacToe.new.run