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
		move_piece(move, opponent)
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
		@pieces.each do |piece|
			potential_coordinates = piece.get_potential_coordinates(self, opponent)
			potential_coordinates.each do |coordinate_pair|
				if valid_move?(coordinate_pair, opponent)
					start_location = piece.location
					piece.location = coordinate_pair[1]
					stalemate = false if !king_in_check?(opponent)
					piece.location = start_location
					return false if stalemate == false
				end
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
				pawn1 = Pawn.new([1, 2])
				pawn2 = Pawn.new([2, 2])
				pawn3 = Pawn.new([3, 2])
				pawn4 = Pawn.new([4, 2])
				pawn5 = Pawn.new([5, 2])
				pawn6 = Pawn.new([6, 2])
				pawn7 = Pawn.new([7, 2])
				pawn8 = Pawn.new([8, 2])
				pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2,
					pawn1, pawn2, pawn3, pawn4, pawn5, pawn6, pawn7, pawn8]
			when "black"
				king = King.new([5, 8])
				queen = Queen.new([4, 8])
				bishop1 = Bishop.new([3, 8])
				bishop2 = Bishop.new([6, 8])
				knight1 = Knight.new([2, 8])
				knight2 = Knight.new([7, 8])
				rook1 = Rook.new([1, 8])
				rook2 = Rook.new([8, 8])
				pawn1 = Pawn.new([1, 7])
				pawn2 = Pawn.new([2, 7])
				pawn3 = Pawn.new([3, 7])
				pawn4 = Pawn.new([4, 7])
				pawn5 = Pawn.new([5, 7])
				pawn6 = Pawn.new([6, 7])
				pawn7 = Pawn.new([7, 7])
				pawn8 = Pawn.new([8, 7])
				pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2,
					pawn1, pawn2, pawn3, pawn4, pawn5, pawn6, pawn7, pawn8]
			end
		else # saved != nil
			promoted = saved[16..-1]
			king = King.new(saved[0]["location"], saved[0]["moves made"])
			queen = Queen.new(saved[1]["location"])
			bishop1 = Bishop.new(saved[2]["location"])
			bishop2 = Bishop.new(saved[3]["location"])
			knight1 = Knight.new(saved[4]["location"])
			knight2 = Knight.new(saved[5]["location"])
			rook1 = Rook.new(saved[6]["location"], saved[6]["moves made"])
			rook2 = Rook.new(saved[7]["location"], saved[7]["moves made"])
			pawn1 = Pawn.new(saved[8]["location"], saved[8]["moves made"], saved[8]["advanced on"])
			pawn2 = Pawn.new(saved[9]["location"], saved[9]["moves made"], saved[9]["advanced on"])
			pawn3 = Pawn.new(saved[10]["location"], saved[10]["moves made"], saved[10]["advanced on"])
			pawn4 = Pawn.new(saved[11]["location"], saved[11]["moves made"], saved[11]["advanced on"])
			pawn5 = Pawn.new(saved[12]["location"], saved[12]["moves made"], saved[12]["advanced on"])
			pawn6 = Pawn.new(saved[13]["location"], saved[13]["moves made"], saved[13]["advanced on"])
			pawn7 = Pawn.new(saved[14]["location"], saved[14]["moves made"], saved[14]["advanced on"])
			pawn8 = Pawn.new(saved[15]["location"], saved[15]["moves made"], saved[15]["advanced on"])
			pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2,
				pawn1, pawn2, pawn3, pawn4, pawn5, pawn6, pawn7, pawn8]
			unless promoted.empty?
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
		coordinates = []
		until valid_move?(coordinates, opponent) && !leaves_king_vulnerable?(coordinates, opponent)
			move = ""
			until (/[a-h][1-8] to [a-h][1-8]/.match?(move)) || ["resign", "save"].include?(move)
				move = gets.chomp.downcase
				puts "Invalid selection - Try again with correct format:" unless /[a-h][1-8] to [a-h][1-8]/.match?(move) || ["resign", "save"].include?(move)
			end
			return "#{@id} resigns." if move.include?("resign")
			return "#{@id} saves" if move.include?("save")
			coordinates = parse_move(move)
			unless valid_move?(coordinates, opponent) && !leaves_king_vulnerable?(coordinates, opponent)
				puts "Chess rules do not allow that move. Try again:"
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
		start_location = moving_piece.location
		moving_piece.location = coordinates[1]
		if king_in_check?(opponent)
			vulnerable = true
		end
		moving_piece.location = start_location
		vulnerable
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

		# zero_moves = false if
		# 1. The king can move out of check
		# 2. Any piece can capture the threat (except the king if threat is protected - check for check after move)
		# 3. Any piece can block the threat (note: knight cannot be blocked)
