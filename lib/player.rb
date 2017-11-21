class Player
	require_relative 'pieces'

	attr_accessor :pieces, :points, :captured_pieces
	attr_reader :id

	def initialize(id, color)
		@id = id
		@pieces = populate_pieces(color)
		@points = 0
		@captured_pieces = ""
	end

	def take_turn(opponent_pieces)
		puts "#{@id}'s turn:\n[example format: b1 to c3]"
		move = get_valid_move_coordinates(opponent_pieces)
		move_piece(move)
	end

	private

	def populate_pieces(color)
		case color
		when "white"
			king = King.new("king", [5, 1])
			queen = Queen.new("queen", [4, 1])
			bishop1 = Bishop.new("bishop", [3, 1])
			bishop2 = Bishop.new("bishop", [6, 1])
			knight1 = Knight.new("knight", [2, 1])
			knight2 = Knight.new("knight", [7, 1])
			rook1 = Rook.new("rook", [1, 1])
			rook2 = Rook.new("rook", [8, 1])
			pawn1 = Pawn.new("pawn", [1, 2])
			pawn2 = Pawn.new("pawn", [2, 2])
			pawn3 = Pawn.new("pawn", [3, 2])
			pawn4 = Pawn.new("pawn", [4, 2])
			pawn5 = Pawn.new("pawn", [5, 2])
			pawn6 = Pawn.new("pawn", [6, 2])
			pawn7 = Pawn.new("pawn", [7, 2])
			pawn8 = Pawn.new("pawn", [8, 2])
			pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2,
				pawn1, pawn2, pawn3, pawn4, pawn5, pawn6, pawn7, pawn8]
		when "black"
			king = King.new("king", [4, 8])
			queen = Queen.new("queen", [5, 8])
			bishop1 = Bishop.new("bishop", [3, 8])
			bishop2 = Bishop.new("bishop", [6, 8])
			knight1 = Knight.new("knight", [2, 8])
			knight2 = Knight.new("knight", [7, 8])
			rook1 = Rook.new("rook", [1, 8])
			rook2 = Rook.new("rook", [8, 8])
			pawn1 = Pawn.new("pawn", [1, 7])
			pawn2 = Pawn.new("pawn", [2, 7])
			pawn3 = Pawn.new("pawn", [3, 7])
			pawn4 = Pawn.new("pawn", [4, 7])
			pawn5 = Pawn.new("pawn", [5, 7])
			pawn6 = Pawn.new("pawn", [6, 7])
			pawn7 = Pawn.new("pawn", [7, 7])
			pawn8 = Pawn.new("pawn", [8, 7])
			pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2,
				pawn1, pawn2, pawn3, pawn4, pawn5, pawn6, pawn7, pawn8]
		end
	end

	def get_valid_move_coordinates(opponent_pieces)
		move = ""
		until valid_move?(move, opponent_pieces)
			move = gets.chomp.downcase
			puts "Invalid selection - Try again with correct format:" unless /[a-h][1-8] to [a-h][1-8]/.match?(move)
			puts "Chess rules do not allow that move. Try again:" if (!valid_move?(move, opponent_pieces) && /[a-h][1-8] to [a-h][1-8]/.match?(move))
		end
		coordinates = parse_move(move)
		coordinates
	end

	def valid_move?(move, opponent_pieces)
		return false if move == ""
		valid = true
		valid = false unless /[a-h][1-8] to [a-h][1-8]/.match?(move)
		coordinates = parse_move(move)
		valid = false unless player_piece?(coordinates[0])
		valid = false if player_piece?(coordinates[1])
		selected_piece = coordinate_to_piece(coordinates[0]) if player_piece?(coordinates[0])
		valid = false unless (player_piece?(coordinates[0]) && selected_piece.can_move_there?(selected_piece.location, coordinates[1], @pieces, opponent_pieces))
		valid
	end

	def parse_move(move)
		switch = {"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8}
		coordinates = move.gsub(/[a-h]/, switch).split(" to ")
		coordinates.collect do |c|
			c.split("").collect do |n|
				n.to_i
			end
		end
	end

	def player_piece?(coordinate)
		player_piece = false
		@pieces.each do |piece|
			player_piece = true if coordinate == piece.location
		end
		player_piece
	end

	def coordinate_to_piece(coordinate)
		@pieces.each do |piece|
			return piece if coordinate == piece.location
		end
	end

	def move_piece(move)
		moving_piece = coordinate_to_piece(move[0])
		start_location = moving_piece.location
		moving_piece.location = move[1]
		if king_in_check?
			moving_piece.location = start_location
			puts "Invalid move - Your king is in check! Try again."
			take_turn
		end
		moving_piece.first_move = false if moving_piece.id == "pawn"
	end

	def king_in_check?
		king = ""
		@pieces.each do |piece|
			king = piece if piece.id == "king"
		end
		king.check == true ? true : false
	end
end
