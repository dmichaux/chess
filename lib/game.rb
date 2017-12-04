class Chess
	require 'json'
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
		until input == 1 || input == 2
			input = gets.chomp.to_i
			puts "Invalid selection. Please try again:" unless input == 1 || input == 2
		end
		input
	end

	def new_game
		puts "\nNew game!\n"
		create_game
		game_action(1)
	end

	def create_game(file_data = nil)
		if file_data.nil?
			@player1 = Player.new("Player 1", "white")
			@player2 = Player.new("Player 2", "black")
		else
			@player1 = Player.new("Player 1", "white", file_data["p1"])
			@player2 = Player.new("Player 2", "black", file_data["p2"])
		end
		@board = Board.new(@player1, @player2)
	end

	def load_game
		filename = select_a_file
		file_data = read_file(filename)
		create_game(file_data)
		game_action(file_data["current turn"])
	end

	def select_a_file
		puts "\nPlease select a game to load:"
		files = Dir.glob("saved_games/*")
		files.each { |file| puts file.slice(/\/(\w+)\./, 1) }
		filename = ""
		until files.include?("saved_games/#{filename}.txt")
			filename = gets.chomp
			puts "File does not exist. Try again:" unless files.include?("saved_games/#{filename}.txt")
		end
		filename
	end

	def read_file(filename)
		file_info_json = File.open("saved_games/#{filename}.txt", "r").readlines
		file_info = JSON.parse(file_info_json[0])
		file_info
	end

	def game_action(current_turn)
		case 
		when current_turn == 1
			until @game_over
				turn(@player1, @player2)
				turn(@player2, @player1) unless @game_over
				# player1_turn
				# player2_turn unless @game_over
			end
		when current_turn == 2
			until @game_over
				turn(@player2, @player1)
				turn(@player1, @player2) unless @game_over
				# player2_turn
				# player1_turn unless @game_over
			end
		end
		end_the_game
	end

	def turn(player, opponent)
		@board.print_board
		move = player.take_turn(opponent)
		if move.include?("resign")
			puts "\n#{move}"
			@game_over = true
		elsif move.include?("save")
			save_game(move)
		else
			resolve_en_passant(move, player, opponent.pieces, opponent.id) if en_passant_in_progress?(move, player.pieces) && piece_conflict? == false
			resolve_piece_capture(player, opponent.pieces, opponent.id) if piece_conflict?
			@board.update_board(@player1, @player2)
			@game_over = true if game_over?(@player1, @player2)
		end
	end

	def resolve_piece_capture(player, opponent_pieces, opponent_id)
		captured_piece = ""
		player.pieces.each do |player_piece|
			opponent_pieces.each do |opponent_piece|
				captured_piece = opponent_piece if (player_piece.location != [] && player_piece.location == opponent_piece.location)
			end
		end
		captured_piece.location = []
		add_to_score(player, captured_piece, opponent_id)
	end

	def add_to_score(player, captured_piece, opponent_id)
		player.points += captured_piece.points
		case opponent_id
		when "Player 1" then player.captured_pieces += "#{captured_piece.w_symbol} "
		when "Player 2" then player.captured_pieces += "#{captured_piece.b_symbol} "
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

	def resolve_en_passant(move, player, opponent_pieces, opponent_id)
		captured_pawn = opponent_pieces.find { |piece| (piece.location == [move[1][0], (move[1][1] + 1)] || piece.location == [move[1][0], (move[1][1] - 1)]) }
		captured_pawn.location = []
		add_to_score(player, captured_pawn, opponent_id)
	end

	def en_passant_in_progress?(move, player_pieces)
		delta = [(move[1][0] - move[0][0]).abs, (move[1][1] - move[0][1]).abs]
		in_progress = false
		pawn = player_pieces.find { |piece| piece.id == "pawn" && piece.location == move[1] }
		return false if pawn.nil?
		in_progress = true if delta[0] == delta[1]
		in_progress
	end

	def end_the_game
		puts "Good game. All pieces go back in the box!"
	end

	def game_over?(player, opponent)
		over = false
		over = true if opponent.in_checkmate?(player)
		over = true if opponent.in_stalemate?(player)
		over
	end

	def save_game(input)
		@game_over = true
		saved_info = save_player_info(input)
		saved_info_json = JSON.generate(saved_info)
		filename = get_filename
		Dir.mkdir("saved_games") unless Dir.exists?("saved_games")
		File.open("saved_games/#{filename}.txt", "w") { |file| file.puts(saved_info_json) }
		puts "Game Saved!"
	end

	def get_filename
		puts "\nPlease choose a name for your saved game:\n[1 to 10 alpha-numeric characters]"
		filename = ""
		until /\w{1,10}/.match?(filename)
			filename = gets.chomp
			puts "Invalid name. Try again:" unless /\w{1,10}/.match?(filename)
		end
		filename
	end

	def save_player_info(current_turn)
		case
		when current_turn.include?("1") then current_turn = 1
		when current_turn.include?("2") then current_turn = 2
		end
		p1_pieces = populate_piece_info(@player1.pieces)
		p2_pieces = populate_piece_info(@player2.pieces)
		p1_saved_info = {"turn" => @player1.turn, "points" => @player1.points, "captured pieces" => @player1.captured_pieces,
										"pieces" => p1_pieces}
		p2_saved_info = {"turn" => @player2.turn, "points" => @player2.points, "captured pieces" => @player2.captured_pieces,
										"pieces" => p2_pieces}
		saved_info = {"current turn" => current_turn, "p1" => p1_saved_info, "p2" => p2_saved_info}
		saved_info
	end

	def populate_piece_info(player_pieces)
		populated_pieces = []
		player_pieces.each do |piece|
			if ["king", "rook"].include?(piece.id)
				populated_pieces.push({"id" => piece.id, "location" => piece.location, "has moved" => piece.has_moved})
			elsif piece.id == "pawn"
				populated_pieces.push({"id" => piece.id, "location" => piece.location, "has moved" => piece.has_moved, "advanced on" => piece.double_advanced_on_turn})
			else
				populated_pieces.push({"id" => piece.id, "location" => piece.location})
			end
		end
		populated_pieces
	end
end

game = Chess.new
