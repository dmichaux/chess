class Player
	require_relative 'pieces'

	attr_accessor :pieces, :turn, :points, :captured_pieces
	attr_reader :id

	def initialize(id, color)
		@id = id
		@pieces = populate_pieces(color)
		@turn = 1
		@points = 0
		@captured_pieces = ""
	end

	def take_turn(opponent)
		puts "#{@id}'s turn:\n[example format: b1 to c3]"
		king_in_check?(opponent)
		move = get_valid_move_coordinates(opponent)
		move_piece(move, opponent)
		@turn += 1
		move
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

	def king_in_check?(opponent)
		king = ""
		@pieces.each do |piece|
			king = piece if piece.id == "king"
		end
		king.check = false
		opponent.pieces.each do |piece|
			king.check = true if piece.location != [] && piece.can_move_there?(piece.location, king.location, opponent, self)
		end
		king.check
	end

	def get_valid_move_coordinates(opponent)
		move = ""
		until valid_move?(move, opponent)
			move = gets.chomp.downcase
			puts "Invalid selection - Try again with correct format:" unless /[a-h][1-8] to [a-h][1-8]/.match?(move)
			puts "Chess rules do not allow that move. Try again:" if (!valid_move?(move, opponent) && /[a-h][1-8] to [a-h][1-8]/.match?(move))
		end
		coordinates = parse_move(move)
		coordinates
	end

	def valid_move?(move, opponent)
		return false if move == ""
		valid = true
		valid = false unless /[a-h][1-8] to [a-h][1-8]/.match?(move)
		coordinates = parse_move(move)
		valid = false unless player_piece?(coordinates[0])
		valid = false if player_piece?(coordinates[1])
		selected_piece = coordinate_to_piece(coordinates[0]) if player_piece?(coordinates[0])
		valid = false unless (player_piece?(coordinates[0]) && selected_piece.can_move_there?(selected_piece.location, coordinates[1], self, opponent))
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

	def move_piece(move, opponent)
		moving_piece = coordinate_to_piece(move[0])
		start_location = moving_piece.location
		moving_piece.location = move[1]
		if king_in_check?(opponent)
			moving_piece.location = start_location
			puts "Invalid move - Your king would remain in check! Try again."
			take_turn(opponent)
		end
		if moving_piece.id == "king" && (move[1][0] - move[0][0]).abs == 2
			direction = (move[1][0] - move[0][0]) > 0 ? "right" : "left"
			rook = moving_piece.find_castling_rook(@pieces, direction)
			case 
			when direction == "right" then rook.location[0] = (moving_piece.location[0] - 1)
			when direction == "left" then rook.location[0] = (moving_piece.location[0] + 1)
			end
		end
		moving_piece.moves_made += 1 if moving_piece.id == "king"
		moving_piece.moves_made += 1 if moving_piece.id == "rook"
		if moving_piece.id == "pawn"
			moving_piece.moves_made += 1
			moving_piece.double_advanced_on_turn = @turn if (move[1][1] - move[0][1]).abs == 2
			if (moving_piece.location[1] == 1 || moving_piece.location[1] == 8)
				promote_pawn(moving_piece)
			end
		end
	end

	def promote_pawn(pawn)
		input = promote_to
		promotion(input, pawn.location)
		pawn.location = []
	end

	def promote_to
		puts "#{@id} may promote the pawn. What piece do you choose?\n[queen, rook, knight, or bishop]"
		choices = ["queen", "rook", "knight", "bishop"]
		input = ""
		until choices.include?(input)
			input = gets.chomp.downcase
			puts "Invalid selection. What piece do you choose?\n[queen, rook, knight, or bishop]" unless choices.include?(input)
		end
		input
	end

	def promotion(choice, location)
		case choice
		when "queen" then @pieces.push(Queen.new("queen", location))
		when "rook" then @pieces.push(Rook.new("rook", location))
		when "knight" then @pieces.push(Knight.new("knight", location))
		when "bishop" then @pieces.push(Bishop.new("bishop", location))
		end
	end
end
