class King
	attr_accessor :check, :location
	attr_reader :w_symbol, :b_symbol, :id

	def initialize(id, location)
		@b_symbol = "♔"
		@w_symbol = "♚"
		@check = false
		@id = id
		@location = location
	end

	def can_move_there?(from, to)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		valid = false if ((delta[0] > 1) || (delta[1] > 1))
		valid
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

	def can_move_there?(from, to, player_pieces, opponent_pieces)
		valid = true
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		if ((from[0] != to[0]) && (from[1] != to[1]))
			valid = false unless delta[0] == delta[1]
		end
		valid = false unless valid_path?(from, to, player_pieces, opponent_pieces)
		valid
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
		path
	end
end

class Rook
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol, :points, :id

	def initialize(id, location)
		@b_symbol = "♖"
		@w_symbol = "♜"
		@points = 5
		@id = id
		@location = location
	end

	def can_move_there?(from, to, player_pieces, opponent_pieces)
		valid = true
		valid = false unless ((from[0] == to[0]) || (from[1] == to[1]))
		valid = false unless valid_path?(from, to, player_pieces, opponent_pieces)
		valid
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
		path
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

	def can_move_there?(from, to)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = false
		valid = true if (delta == [1, 2] || delta == [2, 1])
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

	def can_move_there?(from, to, player_pieces, opponent_pieces)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		valid = false unless delta[0] == delta[1]
		valid = false unless valid_path?(from, to, player_pieces, opponent_pieces)
		valid
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
		path
	end
end

class Pawn
	attr_accessor :first_move, :location
	attr_reader :w_symbol, :b_symbol, :points, :id

	def initialize(id, location)
		@b_symbol = "♙"
		@w_symbol = "♟"
		@first_move = true
		@points = 1
		@id = id
		@location = location
	end

	def can_move_there?(from, to, player_pieces, opponent_pieces)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		valid = false unless delta == [0, 1]
		valid = true if delta == [0, 2] && @first_move == true
		valid = false unless valid_path?(from, to, player_pieces, opponent_pieces)
		valid
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

	def calculate_path(from, to)
		path = []
		travel = [(to[0] - from[0]), (to[1] - from[1])]
		if travel[0] == 0 && travel[1] > 0 # up
			(from[1] + 1).upto(to[1]) { |y| path.push([from[0], y]) }
		end	
		path
	end
end
