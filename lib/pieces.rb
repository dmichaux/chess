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
	attr_reader :w_symbol, :b_symbol, :id

	def initialize(id, location)
		@b_symbol = "♕"
		@w_symbol = "♛"
		@id = id
		@location = location
	end

	def can_move_there?(from, to)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		if ((from[0] != to[0]) && (from[1] != to[1]))
			valid = false unless delta[0] == delta[1]
		end
		valid
	end
end

class Rook
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol, :id

	def initialize(id, location)
		@b_symbol = "♖"
		@w_symbol = "♜"
		@id = id
		@location = location
	end

	def can_move_there?(from, to)
		valid = true
		valid = false unless ((from[0] == to[0]) || (from[1] == to[1]))
		valid
	end
end

class Knight
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol, :id

	def initialize(id, location)
		@b_symbol = "♘"
		@w_symbol = "♞"
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
	attr_reader :w_symbol, :b_symbol, :id

	def initialize(id, location)
		@b_symbol = "♗"
		@w_symbol = "♝"
		@id = id
		@location = location
	end

	def can_move_there?(from, to)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = true
		valid = false unless delta[0] == delta[1]
		valid
	end
end

class Pawn
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol, :id

	def initialize(id, location)
		@b_symbol = "♙"
		@w_symbol = "♟"
		@id = id
		@location = location
	end

	def can_move_there?(from, to)
		delta = [(to[0] - from[0]).abs, (to[1] - from[1]).abs]
		valid = false
		valid = true if delta == [0, 1]
		valid
	end
end
