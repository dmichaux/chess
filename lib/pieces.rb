class King
	attr_accessor :location
	attr_reader :w_symbol, :b_symbol, :id

	def initialize(id, location)
		@b_symbol = "♔"
		@w_symbol = "♚"
		@id = id
		@location = location
	end

	def move
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

	def move
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

	def move
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

	def move
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

	def move
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

	def move
	end
end
