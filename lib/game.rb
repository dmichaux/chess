class Chess
	require_relative 'board'
	require_relative 'player'

	def initialize
		start
	end

	private

	def start
		print_menu
		input = get_input
		input == 1 ? new_game : load_game
	end

	def print_menu
		puts "Welcome to Chess!\n\nPlease select a number:\n1) New Game\n2) Load Game"
	end

	def get_input
		input = ""
		until (input == 1 || input == 2)
			input = gets.chomp.to_i
			puts "Invalid selection. Please try again:" unless (input == 1 || input == 2)
		end
		input
	end

	def new_game
		@player1 = Player.new
		@player2 = Player.new
		@board = Board.new(@player1.pieces, @player2.pieces)
		@board.print_board
	end

	def load_game
	end
end

game = Chess.new
