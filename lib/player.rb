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
		king = King.new("king", [5, 1])
		queen = Queen.new("queen", [4, 1])
		bishop1 = Bishop.new("bishop1", [3, 1])
		bishop2 = Bishop.new("bishop2", [6, 1])
		knight1 = Knight.new("knight1", [2, 1])
		knight2 = Knight.new("knight2", [7, 1])
		rook1 = Rook.new("rook1", [1, 1])
		rook2 = Rook.new("rook2", [8, 1])
		pawn1 = Pawn.new("pawn1", [1, 2])
		pawn2 = Pawn.new("pawn2", [2, 2])
		pawn3 = Pawn.new("pawn3", [3, 2])
		pawn4 = Pawn.new("pawn4", [4, 2])
		pawn5 = Pawn.new("pawn5", [5, 2])
		pawn6 = Pawn.new("pawn6", [6, 2])
		pawn7 = Pawn.new("pawn7", [7, 2])
		pawn8 = Pawn.new("pawn8", [8, 2])
		pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2,
			pawn1, pawn2, pawn3, pawn4, pawn5, pawn6, pawn7, pawn8]
	end
end
