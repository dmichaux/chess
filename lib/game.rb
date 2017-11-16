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
		puts "\nNew game!\n"
		@player1 = Player.new("Player 1", "white")
		@player2 = Player.new("Player 2", "black")
		@board = Board.new(@player1.pieces, @player2.pieces)
		game_action
	end

	def load_game
	end

	def game_action
		until game_over?
			player1_turn
			player2_turn unless game_over?
		end
	end

	def player1_turn
		@board.print_board
		@player1.take_turn
		@board.update_board(@player1.id, @player1.pieces)
		game_over if game_over?
	end

	def player2_turn
		@board.print_board
		@player2.take_turn
		@board.update_board(@player2.id, @player2.pieces)
		game_over if game_over?
	end

	def game_over
		puts "Good game! Pieces go back in the box."
	end

	def game_over?
		# King in check. No valid moves.
		# Stalemate
	end
end

game = Chess.new
