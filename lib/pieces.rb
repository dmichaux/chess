class King
	attr_accessor :check, :moves_made, :location
	attr_reader :w_symbol, :b_symbol, :id

	def initialize(id, location)
		@b_symbol = "♔"
		@w_symbol = "♚"
		@check = false
		@moves_made = 0
		@id = id
		@location = location
	end

	def can_move_there?(from, to, player, opponent)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		valid = false if delta == [0, 0]
		valid = false if ((delta[0] > 1) || (delta[1] > 1))
		valid = true if delta == [2, 0] && can_castle?(from, to, player, opponent)
		valid
	end

	def find_castling_rook(player_pieces, direction)
		rooks = player_pieces.select { |piece| piece.id == "rook" }
		rook = []
		case
		when direction == "right"
			rooks.each { |piece| rook = piece if piece.location[0] == 8 && piece.moves_made == 0 }
		when direction == "left"
			rooks.each { |piece| rook = piece if piece.location[0] == 1 && piece.moves_made == 0 }
		end
		rook
	end

	private

	def can_castle?(from, to, player, opponent)
		direction = (to[0] - from[0]) > 0 ? "right" : "left"
		rook = find_castling_rook(player.pieces, direction) 
		return false if rook.nil?
		valid = true
		valid = false if @check == true
		valid = false if @moves_made > 0
		valid = false unless valid_path?(from, rook.location, player, opponent,)
		valid
	end

	def valid_path?(from, to, player, opponent)
		valid = true
		path = calculate_path(from, to)
		obstacles = player.pieces + opponent.pieces
		obstacles.each do |piece|
			valid = false if path.include?(piece.location)
		end
		opponent.pieces.each do |piece|
			valid = false if piece.location != [] && piece.can_move_there?(piece.location, path[0], opponent, player)
		end
		valid
	end

	def calculate_path(from, to)
		path = []
		travel = [(to[0] - from[0]), (to[1] - from[1])]
		case
		when travel[0] > 0 # right
			(from[0] + 1).upto(to[0]) { |x| path.push([x, from[1]]) }
		when travel[0] < 0 # left
			(from[0] - 1).downto(to[0]) { |x| path.push([x, from[1]]) }
		end
		path.pop
		path
	end
end

class Queen
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol, :points, :id

	def initialize(id, location)
		@b_symbol = "♕"
		@w_symbol = "♛"
		@points = 9
		@id = id
		@location = location
	end

	def can_move_there?(from, to, player, opponent)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		valid = false if delta == [0, 0]
		if ((from[0] != to[0]) && (from[1] != to[1]))
			valid = false unless delta[0] == delta[1]
		end
		valid = false unless valid_path?(from, to, player.pieces, opponent.pieces)
		valid
	end

	def calculate_path(from, to)
		path = []
		travel = [(to[0] - from[0]), (to[1] - from[1])]
		case
		when travel[0] == 0 && travel[1] > 0 # up
			(from[1] + 1).upto(to[1]) { |y| path.push([from[0], y]) }
		when travel[0] > 0 && travel[1] > 0 # up/right
			1.upto(travel[0].abs) { |t| path.push([(from[0] + t), (from[1] + t)]) }
		when travel[0] > 0 && travel[1] == 0 # right
			(from[0] + 1).upto(to[0]) { |x| path.push([x, from[1]]) }
		when travel[0] > 0 && travel[1] < 0 # down/right
			1.upto(travel[0].abs) { |t| path.push([(from[0] + t), (from[1] - t)]) }
		when travel[0] == 0 && travel[1] < 0 # down
			(from[1] - 1).downto(to[1]) { |y| path.push([from[0], y]) }
		when travel[0] < 0 && travel[1] < 0 # down/left
			1.upto(travel[0].abs) { |t| path.push([(from[0] - t), (from[1] - t)]) }
		when travel[0] < 0 && travel[1] == 0 # left
			(from[0] - 1).downto(to[0]) { |x| path.push([x, from[1]]) }
		when travel[0] < 0 && travel[1] > 0 # up/left
			1.upto(travel[0].abs) { |t| path.push([(from[0] - t), (from[1] + t)]) }
		end
		path.pop
		path
	end

	private

	def valid_path?(from, to, player_pieces, opponent_pieces)
		valid = true
		path = calculate_path(from, to)
		obstacles = player_pieces + opponent_pieces
		obstacles.each do |piece|
			valid = false if path.include?(piece.location)
		end
		valid
	end
end

class Rook
	attr_accessor :moves_made, :location
	attr_reader :w_symbol, :b_symbol, :points, :id

	def initialize(id, location)
		@b_symbol = "♖"
		@w_symbol = "♜"
		@moves_made = 0
		@points = 5
		@id = id
		@location = location
	end

	def can_move_there?(from, to, player, opponent)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		valid = false if delta == [0, 0]
		valid = false unless ((from[0] == to[0]) || (from[1] == to[1]))
		valid = false unless valid_path?(from, to, player.pieces, opponent.pieces)
		valid
	end

	def calculate_path(from, to)
		path = []
		travel = [(to[0] - from[0]), (to[1] - from[1])]
		case
		when travel[0] == 0 && travel[1] > 0 # up
			(from[1] + 1).upto(to[1]) { |y| path.push([from[0], y]) }
		when travel[0] > 0 && travel[1] == 0 # right
			(from[0] + 1).upto(to[0]) { |x| path.push([x, from[1]]) }
		when travel[0] == 0 && travel[1] < 0 # down
			(from[1] - 1).downto(to[1]) { |y| path.push([from[0], y]) }
		when travel[0] < 0 && travel[1] == 0 # left
			(from[0] - 1).downto(to[0]) { |x| path.push([x, from[1]]) }
		end
		path.pop
		path
	end

	private

	def valid_path?(from, to, player_pieces, opponent_pieces)
		valid = true
		path = calculate_path(from, to)
		obstacles = player_pieces + opponent_pieces
		obstacles.each do |piece|
			valid = false if path.include?(piece.location)
		end
		valid
	end
end

class Knight
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol, :points, :id

	def initialize(id, location)
		@b_symbol = "♘"
		@w_symbol = "♞"
		@points = 3
		@id = id
		@location = location
	end

	def can_move_there?(from, to, player, opponent)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		valid = false unless (delta == [1, 2] || delta == [2, 1])
		valid
	end
end

class Bishop
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol, :points, :id

	def initialize(id, location)
		@b_symbol = "♗"
		@w_symbol = "♝"
		@points = 3
		@id = id
		@location = location
	end

	def can_move_there?(from, to, player, opponent)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		valid = false if delta == [0, 0]
		valid = false unless delta[0] == delta[1]
		valid = false unless valid_path?(from, to, player.pieces, opponent.pieces)
		valid
	end

	def calculate_path(from, to)
		path = []
		travel = [(to[0] - from[0]), (to[1] - from[1])]
		case
		when travel[0] > 0 && travel[1] > 0 # up/right
			1.upto(travel[0].abs) { |t| path.push([(from[0] + t), (from[1] + t)]) }
		when travel[0] > 0 && travel[1] < 0 # down/right
			1.upto(travel[0].abs) { |t| path.push([(from[0] + t), (from[1] - t)]) }
		when travel[0] < 0 && travel[1] < 0 # down/left
			1.upto(travel[0].abs) { |t| path.push([(from[0] - t), (from[1] - t)]) }
		when travel[0] < 0 && travel[1] > 0 # up/left
			1.upto(travel[0].abs) { |t| path.push([(from[0] - t), (from[1] + t)]) }
		end
		path.pop
		path
	end

	private

	def valid_path?(from, to, player_pieces, opponent_pieces)
		valid = true
		path = calculate_path(from, to)
		obstacles = player_pieces + opponent_pieces
		obstacles.each do |piece|
			valid = false if path.include?(piece.location)
		end
		valid
	end
end

class Pawn
	attr_accessor :moves_made, :double_advanced_on_turn, :location
	attr_reader :w_symbol, :b_symbol, :points, :id

	def initialize(id, location)
		@b_symbol = "♙"
		@w_symbol = "♟"
		@moves_made = 0
		@double_advanced_on_turn = 0
		@points = 1
		@id = id
		@location = location
	end

	def can_move_there?(from, to, player, opponent)
		travel = [(to[0] - from[0]), (to[1] - from[1])]
		valid = true
		case
		when player.id == "Player 1"
			valid = false unless travel == [0, 1]
			valid = true if travel == [0, 2] && @moves_made == 0
			valid = true if (travel == [-1, 1] && opponent_present?(to, opponent.pieces)) || (travel == [1, 1] && opponent_present?(to, opponent.pieces))
			valid = true if (travel == [-1, 1] && can_en_passant?(from, player, opponent.pieces)) || (travel == [1, 1] && can_en_passant?(from, player, opponent.pieces))
		when player.id == "Player 2"
			valid = false unless travel == [0, -1]
			valid = true if travel == [0, -2] && @moves_made == 0
			valid = true if (travel == [-1, -1] && opponent_present?(to, opponent.pieces)) || (travel == [1, -1] && opponent_present?(to, opponent.pieces))
			valid = true if (travel == [-1, -1] && can_en_passant?(from, player, opponent.pieces)) || (travel == [1, -1] && can_en_passant?(from, player, opponent.pieces))
		end
		valid = false unless valid_path?(from, to, player.pieces, opponent.pieces)
		valid
	end

	private

	def can_en_passant?(from, player, opponent_pieces)
		valid = true
		opponent_pawns = opponent_pieces.select { |piece| piece.id == "pawn" } # && piece.location == [x, y] && piece.moves_made == 1
		case
		when player.id == "Player 1"
			valid = false unless from[1] == 5
			victim_pawn = opponent_pawns.find { |pawn| pawn.double_advanced_on_turn == (player.turn - 1) && (pawn.location == [(from[0] + 1), 5] || pawn.location == [(from[0] - 1), 5]) }
			valid = false if victim_pawn.nil?
		when player.id == "Player 2"
			valid = false unless from[1] == 4
			victim_pawn = opponent_pawns.find { |pawn| pawn.double_advanced_on_turn == player.turn && (pawn.location == [(from[0] + 1), 5] || pawn.location == [(from[0] - 1), 4]) }
			valid = false if victim_pawn.nil?
		end
		valid
	end

	def valid_path?(from, to, player_pieces, opponent_pieces)
		valid = true
		path = calculate_path(from, to)
		obstacles = player_pieces + opponent_pieces
		obstacles.each do |piece|
			valid = false if piece.location != [] && path.include?(piece.location)
		end
		valid
	end

	def calculate_path(from, to)
		path = []
		travel = [(to[0] - from[0]), (to[1] - from[1])]
		if travel[0] == 0 && travel[1] > 0 # up
			(from[1] + 1).upto(to[1]) { |y| path.push([from[0], y]) }
		elsif travel[0] == 0 && travel[1] < 0 # down
			(from[1] - 1).downto(to[1]) { |y| path.push([from[0], y]) }
		end	
		path
	end

	def opponent_present?(destination, opponent_pieces)
		valid = false
		opponent_pieces.each do |piece|
			valid = true if piece.location == destination
		end
		valid
	end
end
