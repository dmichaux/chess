class Board

	def initialize(player1, player2)
		@squares = populate_squares
		@p1 = player1
		@p2 = player2
	end

	def print_board
		squares = place_pieces_on_squares
		x_axis = "  -a---b---c---d---e---f---g---h-"
		puts "\n#{x_axis}"
		8.downto(1) do |y|
			print "#{y}|"
			1.upto(8)  { |x| print " #{squares[[x, y]]} |" }
			print "#{y}"
			print " P2 points: #{@p2.points}" if y == 8
			print " P1 points: #{@p1.points}" if y == 1
			print "\n"
			print " |---|---|---|---|---|---|---|---|" unless y == 1
			print "  #{@p2.captured_pieces}" if y == 8
			print "  #{@p1.captured_pieces}" if y == 2
			print "\n" unless y == 1
		end
		puts "#{x_axis}\n\n"
	end

	def update_board(player1, player2)
		@squares.each_key { |k| @squares[k] = " "}
		@p1 = player1
		@p2 = player2
	end

	private

	def place_pieces_on_squares
		squares = @squares
		squares.each_key do |key|
			@p1.pieces.each do |piece|
				squares[key] = piece.w_symbol if key == piece.location
			end
			@p2.pieces.each do |piece|
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
