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
  def assert_if_win

  end

  def choose_a_square(board,squares)
    if board.available_squares(squares)
      puts "Choose an empty square #{board.available_squares}"
    end
  end
end

class User < Player
  attr_accessor :name

  def initialize
    puts "What is your name, sir?"
    @name = gets.chomp
    puts "Welcome to Tic Tac Toe, #{self.name}"
    sleep 0.5
  end

end

class Cpu < Player 

  def choose_a_square
    attack
    defend
    pick_random_square
  end

  def attack

  end

  def defend

  end

  def pick_random_square

  end

end

class Board 

  attr_accessor :squares

  WINNING_LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

  def initialize
    @squares = {1 => " ", 2 => " ", 3 => " ",
                4 => " ", 5 => " ", 6 => " ",
                7 => " ", 8 => " ", 9 => " "}
    draw_board
  end

  def draw_board
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

  def available_squares(squares)
    squares.select{|_,v| v == " "}.keys
  end

  def two_in_a_row

  end

end


class Mark 
  attr_accessor :user_mark, :cpu_mark

  @user_mark = "X"
  @cpu_mark  = "O"

end

class TicTacToe
  attr_accessor :game_board 

  def initialize
    system 'cls'
    @user1      = User.new
    @computer   = Cpu.new
    @game_board = Board.new
  end

  def run
    @user1.choose_a_square(@game_board, @squares)

  end
end

@newgame = TicTacToe.new
@newgame.run