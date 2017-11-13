class Board
	attr_accessor :squares

	def initialize(p1_pieces, p2_pieces)
		@squares = populate_squares
		@p1_pieces = p1_pieces
		@p2_pieces = p2_pieces
	end

	def print_board
		squares = place_pieces_on_squares
		puts " -------------------------------"
		puts "| #{squares[[1, 8]]} | #{squares[[2, 8]]} | #{squares[[3, 8]]} | #{squares[[4, 8]]} | #{squares[[5, 8]]} | #{squares[[6, 8]]} | #{squares[[7, 8]]} | #{squares[[8, 8]]} |"
		puts "|---|---|---|---|---|---|---|---|"
		puts "| #{squares[[1, 7]]} | #{squares[[2, 7]]} | #{squares[[3, 7]]} | #{squares[[4, 7]]} | #{squares[[5, 7]]} | #{squares[[6, 7]]} | #{squares[[7, 7]]} | #{squares[[8, 7]]} |"
		puts "|---|---|---|---|---|---|---|---|"
		puts "| #{squares[[1, 6]]} | #{squares[[2, 6]]} | #{squares[[3, 6]]} | #{squares[[4, 6]]} | #{squares[[5, 6]]} | #{squares[[6, 6]]} | #{squares[[7, 6]]} | #{squares[[8, 6]]} |"
		puts "|---|---|---|---|---|---|---|---|"
		puts "| #{squares[[1, 5]]} | #{squares[[2, 5]]} | #{squares[[3, 5]]} | #{squares[[4, 5]]} | #{squares[[5, 5]]} | #{squares[[6, 5]]} | #{squares[[7, 5]]} | #{squares[[8, 5]]} |"
		puts "|---|---|---|---|---|---|---|---|"
		puts "| #{squares[[1, 4]]} | #{squares[[2, 4]]} | #{squares[[3, 4]]} | #{squares[[4, 4]]} | #{squares[[5, 4]]} | #{squares[[6, 4]]} | #{squares[[7, 4]]} | #{squares[[8, 4]]} |"
		puts "|---|---|---|---|---|---|---|---|"
		puts "| #{squares[[1, 3]]} | #{squares[[2, 3]]} | #{squares[[3, 3]]} | #{squares[[4, 3]]} | #{squares[[5, 3]]} | #{squares[[6, 3]]} | #{squares[[7, 3]]} | #{squares[[8, 3]]} |"
		puts "|---|---|---|---|---|---|---|---|"
		puts "| #{squares[[1, 2]]} | #{squares[[2, 2]]} | #{squares[[3, 2]]} | #{squares[[4, 2]]} | #{squares[[5, 2]]} | #{squares[[6, 2]]} | #{squares[[7, 2]]} | #{squares[[8, 2]]} |"
		puts "|---|---|---|---|---|---|---|---|"
		puts "| #{squares[[1, 1]]} | #{squares[[2, 1]]} | #{squares[[3, 1]]} | #{squares[[4, 1]]} | #{squares[[5, 1]]} | #{squares[[6, 1]]} | #{squares[[7, 1]]} | #{squares[[8, 1]]} |"
		puts " -------------------------------"
	end

	private

	def place_pieces_on_squares
		squares = @squares
		squares.each_key do |key|
			@p1_pieces.each do |piece|
				squares[key] = piece.w_symbol if key == piece.location
			end
			@p2_pieces.each do |piece|
				squares[key] = piece.b_symbol if key == piece.location
			end
		end
		squares
	end

	def populate_squares
		squares = {}
		(1..8).each do |col|
			(1..8).each do |row|
				squares[[col, row]] = " "
			end
		end
		squares
	end
end
