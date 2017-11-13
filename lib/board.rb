class Board
	attr_accessor :squares

	def initialize(p1_pieces, p2_pieces)
		@squares = populate_squares
		@p1_pieces = p1_pieces
		@p2_pieces = p2_pieces
	end

	def print_board
		puts "p1_pieces: #{@p1_pieces}"
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
