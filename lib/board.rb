class Board
	attr_accessor :squares

	def initialize
		@squares = populate_squares
	end

	def print_board
	end

	private

	def populate_squares
		squares = {}
		(1..8).each do |col|
			(1..8).each do |row|
				squares[[col, row]] = ""
			end
		end
		squares
	end
end
