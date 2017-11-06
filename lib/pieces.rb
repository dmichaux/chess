class King
	attr_reader :w_symbol, :b_symbol

	def initialize
		@b_symbol = "♔"
		@w_symbol = "♚"
	end

	def move
	end
end

class Queen
	attr_reader :w_symbol, :b_symbol

	def initialize
		@b_symbol = "♕"
		@w_symbol = "♛"
	end

	def move
	end
end

class Rook
	attr_reader :w_symbol, :b_symbol

	def initialize
		@b_symbol = "♖"
		@w_symbol = "♜"
	end

	def move
	end
end

class Knight
	attr_reader :w_symbol, :b_symbol

	def initialize
		@b_symbol = "♘"
		@w_symbol = "♞"
	end

	def move
	end
end

class Bishop
	attr_reader :w_symbol, :b_symbol

	def initialize
		@b_symbol = "♗"
		@w_symbol = "♝"
	end

	def move
	end
end

class Pawn
	attr_reader :w_symbol, :b_symbol

	def initialize
		@b_symbol = "♙"
		@w_symbol = "♟"
	end

	def move
	end
end
