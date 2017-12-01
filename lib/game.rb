class Chess
	require_relative 'board'
	require_relative 'player'

	def initialize
		@game_over = false
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
		@board = Board.new(@player1, @player2)
		game_action
	end

	def load_game
	end

	def game_action
		until @game_over
			player1_turn
			player2_turn unless @game_over
		end
		end_the_game
	end

	def player1_turn
		@board.print_board
		move = @player1.take_turn(@player2)
		resolve_en_passant(move, @player1, @player2.pieces, "black") if en_passant_in_progress?(move, @player1.pieces) && piece_conflict? == false
		resolve_piece_capture(@player1, @player2.pieces, "black") if piece_conflict?
		@board.update_board(@player1, @player2)
		@game_over = true if game_over?(@player1, @player2)
	end

	def player2_turn
		@board.print_board
		move = @player2.take_turn(@player1)
		resolve_en_passant(move, @player2, @player1.pieces, "white") if en_passant_in_progress?(move, @player2.pieces) && piece_conflict? == false
		resolve_piece_capture(@player2, @player1.pieces, "white") if piece_conflict?
		@board.update_board(@player1, @player2)
		@game_over = true if game_over?(@player2, @player1)
	end

	def resolve_piece_capture(player, opponent_pieces, opponent_color)
		captured_piece = ""
		player.pieces.each do |player_piece|
			opponent_pieces.each do |opponent_piece|
				captured_piece = opponent_piece if (player_piece.location != [] && player_piece.location == opponent_piece.location)
			end
		end
		captured_piece.location = []
		add_to_score(player, captured_piece, opponent_color)
	end

	def add_to_score(player, captured_piece, opponent_color)
		player.points += captured_piece.points
		case opponent_color
		when "white" then player.captured_pieces += "#{captured_piece.w_symbol} "
		when "black" then player.captured_pieces += "#{captured_piece.b_symbol} "
		end
	end

	def piece_conflict?
		conflict = false
		@player1.pieces.each do |piece1|
			@player2.pieces.each do |piece2|
				conflict = true if (piece1.location != [] && piece1.location == piece2.location)
			end
		end
		conflict
	end

	def resolve_en_passant(move, player, opponent_pieces, opponent_color)
		captured_pawn = opponent_pieces.find { |piece| (piece.location == [move[1][0], (move[1][1] + 1)] || piece.location == [move[1][0], (move[1][1] - 1)]) }
		captured_pawn.location = []
		add_to_score(player, captured_pawn, opponent_color)
	end

	def en_passant_in_progress?(move, player_pieces)
		# pawn moved diagonal without conflict at destination square
		delta = [(move[1][0] - move[0][0]).abs, (move[1][1] - move[0][1]).abs]
		in_progress = false
		pawn = player_pieces.find { |piece| piece.id == "pawn" && piece.location == move[1] }
		return false if pawn.nil?
		in_progress = true if delta[0] == delta[1]
		in_progress
	end

	def end_the_game
		puts "Good game! All pieces go back in the box."
	end

	def game_over?(player, opponent)
		over = false
		over = true if opponent.in_checkmate?(player)
		over = true if opponent.in_stalemate?(player)
		over
	end
end

game = Chess.new
