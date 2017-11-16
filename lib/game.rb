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
		@player1 = Player.new("Player 1", "white")
		@player2 = Player.new("Player 2", "black")
		@board = Board.new(@player1.pieces, @player2.pieces)
		game_action
	end

	def load_game
	end

	def game_action
		@board.print_board
		@board.update_board(@player1.take_turn)
	end
end

game = Chess.new
