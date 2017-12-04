class Player
	require_relative 'pieces'

	attr_accessor :pieces, :turn, :points, :captured_pieces
	attr_reader :id

	def initialize(id, color, saved = nil)
		@id = id
		if saved.nil?
			@pieces = populate_pieces(color)
			@turn = 1
			@points = 0
			@captured_pieces = ""
		else
			@pieces = populate_pieces(color, saved["pieces"])
			@turn = saved["turn"]
			@points = saved["points"]
			@captured_pieces = saved["captured pieces"]
		end
	end

	def take_turn(opponent)
		puts "#{@id}'s turn:\n[example format: b1 to c3]\n['resign' to resign game. 'save' to save game]"
		king_in_check?(opponent)
		move = get_valid_move_coordinates(opponent)
		return move if move.include?("resign") || move.include?("save")
		move_piece(move)
		@turn += 1
		move
	end

	def in_checkmate?(opponent)
		checkmate = false
		checkmate = true if king_in_check?(opponent) && zero_valid_moves?(opponent)
		checkmate
	end

	def in_stalemate?(opponent)
		return false if king_in_check?(opponent)
		stalemate = true
		viable_pieces = @pieces.select { |piece| piece.location != [] }
		viable_pieces.each do |piece|
			potential_coordinates = piece.get_potential_coordinates(self, opponent)
			potential_coordinates.each do |coordinate_pair|
				return false if valid_move?(coordinate_pair, opponent) && !leaves_king_vulnerable?(coordinate_pair, opponent)
			end
		end
		stalemate
	end

	private

	def populate_pieces(color, saved = nil)
		pieces = []
		if saved.nil?
			case color
			when "white"
				king = King.new([5, 1])
				queen = Queen.new([4, 1])
				bishop1 = Bishop.new([3, 1])
				bishop2 = Bishop.new([6, 1])
				knight1 = Knight.new([2, 1])
				knight2 = Knight.new([7, 1])
				rook1 = Rook.new([1, 1])
				rook2 = Rook.new([8, 1])
				pawns = populate_pawns(2)
				pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2] + pawns
			when "black"
				king = King.new([5, 8])
				queen = Queen.new([4, 8])
				bishop1 = Bishop.new([3, 8])
				bishop2 = Bishop.new([6, 8])
				knight1 = Knight.new([2, 8])
				knight2 = Knight.new([7, 8])
				rook1 = Rook.new([1, 8])
				rook2 = Rook.new([8, 8])
				pawns = populate_pawns(7)
				pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2] + pawns
			end
		else # saved != nil
			promoted = saved[16..-1]
			king = King.new(saved[0]["location"], saved[0]["has moved"])
			queen = Queen.new(saved[1]["location"])
			bishop1 = Bishop.new(saved[2]["location"])
			bishop2 = Bishop.new(saved[3]["location"])
			knight1 = Knight.new(saved[4]["location"])
			knight2 = Knight.new(saved[5]["location"])
			rook1 = Rook.new(saved[6]["location"], saved[6]["has moved"])
			rook2 = Rook.new(saved[7]["location"], saved[7]["has moved"])
			pawns = populate_pawns(nil, saved)
			pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2] + pawns
			unless promoted == []
				promoted.each do |piece|
					case piece["id"]
					when "queen" then pieces.push(Queen.new(piece["location"]))
					when "bishop" then pieces.push(Bishop.new(piece["location"]))
					when "knight" then pieces.push(Knight.new(piece["location"]))
					when "rook" then pieces.push(Rook.new(piece["location"]))
					end
				end
			end
		end
		pieces
	end

	def populate_pawns(rank, saved = nil)
		pawns = []
		if saved.nil?
			1.upto(8) { |file| pawns.push(Pawn.new([file, rank])) }
		else
			1.upto(8) { |n| pawns.push(Pawn.new(saved[7 + n]["location"], saved[7 + n]["has moved"], saved[7 + n]["advanced on"])) }
		end
		pawns
	end

	def king_in_check?(opponent)
		king = @pieces.find { |piece| piece.id == "king" }
		king.check = false
		opponent.pieces.each do |piece|
			king.check = true if piece.location != [] && piece.can_move_there?(piece.location, king.location, opponent, self)
		end
		king.check
	end

	def get_valid_move_coordinates(opponent)
		coordinates = []
		until valid_move?(coordinates, opponent) && !leaves_king_vulnerable?(coordinates, opponent)
			move = get_move_input
			return "#{@id} resigns." if move.include?("resign")
			return "#{@id} saves" if move.include?("save")
			coordinates = parse_move(move)
			unless valid_move?(coordinates, opponent) && !leaves_king_vulnerable?(coordinates, opponent)
				puts "\nChess rules do not allow that move. Try again:"
			end
		end
		coordinates
	end

	def valid_move?(coordinates, opponent)
		valid = true
		valid = false unless player_piece?(coordinates[0])
		valid = false if player_piece?(coordinates[1])
		selected_piece = coordinate_to_piece(coordinates[0]) if player_piece?(coordinates[0])
		valid = false unless (player_piece?(coordinates[0]) && selected_piece.can_move_there?(selected_piece.location, coordinates[1], self, opponent))
		valid
	end

	def leaves_king_vulnerable?(coordinates, opponent)
		vulnerable = false
		moving_piece = coordinate_to_piece(coordinates[0])
		captured_piece = coordinate_to_piece(coordinates[1], opponent.pieces)
		player_start_location = moving_piece.location
		captured_start_location = captured_piece.location if captured_piece != nil
		pretend_move_happens(moving_piece, captured_piece, coordinates[1])
		vulnerable = true if king_in_check?(opponent)
		reset_move(moving_piece, captured_piece, player_start_location, captured_start_location)
		vulnerable
	end

	def pretend_move_happens(player_piece, opponent_piece, destination)
		player_piece.location = destination
		opponent_piece.location = [] if opponent_piece != nil
	end

	def reset_move(player_piece, opponent_piece, pl_start, op_start)
		player_piece.location = pl_start
		opponent_piece.location = op_start if opponent_piece != nil
	end

	def get_move_input
		move = ""
		until (/[a-h][1-8] to [a-h][1-8]/.match?(move)) || ["resign", "save"].include?(move)
			move = gets.chomp.downcase
			puts "\nInvalid selection - Try again with correct format:" unless /[a-h][1-8] to [a-h][1-8]/.match?(move) || ["resign", "save"].include?(move)
		end
		move
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

	def coordinate_to_piece(coordinate, opponent_pieces = nil)
		selected = []
		if opponent_pieces.nil?
			selected = @pieces.find { |piece| piece.location == coordinate }
		else
			selected = opponent_pieces.find { |piece| piece.location == coordinate }
		end
		selected
	end

	def move_piece(move)
		moving_piece = coordinate_to_piece(move[0])
		moving_piece.location = move[1]
		update_piece(moving_piece, move) if ["king", "rook", "pawn"].include?(moving_piece.id)
	end

	def update_piece(piece, move)
		piece.has_moved = true
		case 
		when piece.id == "pawn"
			piece.double_advanced_on_turn = @turn if (move[1][1] - move[0][1]).abs == 2
			promote_pawn(piece) if piece.location[1] == 1 || piece.location[1] == 8
		when piece.id == "king" && (move[1][0] - move[0][0]).abs == 2
			direction = (move[1][0] - move[0][0]) > 0 ? "right" : "left"
			rook = piece.find_castling_rook(@pieces, direction)
			case 
			when direction == "right" then rook.location[0] = (piece.location[0] - 1)
			when direction == "left" then rook.location[0] = (piece.location[0] + 1)
			end
		end
	end

	def promote_pawn(pawn)
		input = promote_to
		promotion(input, pawn.location)
		pawn.location = []
	end

	def promote_to
		puts "\n#{@id} may promote the pawn. What piece do you choose?\n[queen, rook, knight, or bishop]"
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
		when "queen" then @pieces.push(Queen.new(location))
		when "rook" then @pieces.push(Rook.new(location))
		when "knight" then @pieces.push(Knight.new(location))
		when "bishop" then @pieces.push(Bishop.new(location))
		end
	end

	def zero_valid_moves?(opponent)
		king = @pieces.find { |piece| piece.id == "king" }
		threat = opponent.pieces.find { |piece| piece.location != [] && piece.can_move_there?(piece.location, king.location, opponent, self) }
		zero_moves = true
		zero_moves = false if can_king_escape?(king, opponent)
		zero_moves = false if can_capture_threat?(threat, opponent)
		zero_moves = false if can_block_threat?(king, threat, opponent)
		zero_moves
	end

	def can_king_escape?(king, opponent)
		potential_coordinates = king.get_potential_coordinates(self, opponent)
		can_escape = false
		potential_coordinates.each do |coordinate_pair|
			if valid_move?(coordinate_pair, opponent)
				can_escape = true
				opponent.pieces.each do |piece|
					can_escape = false if piece.location != [] && piece.can_move_there?(piece.location, coordinate_pair[1], opponent, self)
				end
				return true if can_escape == true
			end
		end
		can_escape
	end

	def can_capture_threat?(threat, opponent)
		can_capture = false
		@pieces.each do |piece|
			can_capture = true if piece.location != [] && piece.can_move_there?(piece.location, threat.location, self, opponent)
			if piece.id == "king"
				opponent.pieces.each do |opp_piece|
					can_capture = false if opp_piece.location != [] && opp_piece.can_move_there?(opp_piece.location, threat.location, opponent, self)
				end
			end
		end
		can_capture
	end

	def can_block_threat?(king, threat, opponent)
		can_block = false
		if ["queen", "rook", "bishop"].include?(threat.id)
			threat_path = threat.calculate_path(threat.location, king.location)
			threat_path.each do |square|
				@pieces.each do |piece|
					can_block = true if piece.location != [] && piece.can_move_there?(piece.location, square, self, opponent)
					can_block = false if piece.id == "king"
				end
			end
		end
		can_block
	end
end
