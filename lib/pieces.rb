class King
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol

	def initialize(location)
		@b_symbol = "♔"
		@w_symbol = "♚"
		@location = location
	end

	def move
	end
end

class Queen
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol

	def initialize(location)
		@b_symbol = "♕"
		@w_symbol = "♛"
		@location = location
	end

	def move
	end
end

class Rook
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol

	def initialize(location)
		@b_symbol = "♖"
		@w_symbol = "♜"
		@location = location
	end

	def move
	end
end

class Knight
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol

	def initialize(location)
		@b_symbol = "♘"
		@w_symbol = "♞"
		@location = location
	end

	def move
	end
end

class Bishop
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol

	def initialize(location)
		@b_symbol = "♗"
		@w_symbol = "♝"
		@location = location
	end

	def move
	end
end

class Pawn
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol

	def initialize(location)
		@b_symbol = "♙"
		@w_symbol = "♟"
		@location = location
	end

	def move
	end
end
