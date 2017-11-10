class Player
	require_relative 'pieces'

	attr_accessor :pieces

	def initialize
		@pieces = populate_pieces
	end

	def take_turn
	end

	private

	def populate_pieces
		king = King.new
		queen = Queen.new
		bishop1 = Bishop.new
		bishop2 = Bishop.new
		knight1 = Knight.new
		knight2 = Knight.new
		rook1 = Rook.new
		rook2 = Rook.new
		pawn1 = Pawn.new
		pawn2 = Pawn.new
		pawn3 = Pawn.new
		pawn4 = Pawn.new
		pawn5 = Pawn.new
		pawn6 = Pawn.new
		pawn7 = Pawn.new
		pawn8 = Pawn.new
		pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2,
			pawn1, pawn2, pawn3, pawn4, pawn5, pawn6, pawn7, pawn8]
	end
end
