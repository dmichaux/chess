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
		king = King.new([5, 1])
		queen = Queen.new([4, 1])
		bishop1 = Bishop.new([3, 1])
		bishop2 = Bishop.new([6, 1])
		knight1 = Knight.new([2, 1])
		knight2 = Knight.new([7, 1])
		rook1 = Rook.new([1, 1])
		rook2 = Rook.new([8, 1])
		pawn1 = Pawn.new([1, 2])
		pawn2 = Pawn.new([2, 2])
		pawn3 = Pawn.new([3, 2])
		pawn4 = Pawn.new([4, 2])
		pawn5 = Pawn.new([5, 2])
		pawn6 = Pawn.new([6, 2])
		pawn7 = Pawn.new([7, 2])
		pawn8 = Pawn.new([8, 2])
		pieces = [king, queen, bishop1, bishop2, knight1, knight2, rook1, rook2,
			pawn1, pawn2, pawn3, pawn4, pawn5, pawn6, pawn7, pawn8]
	end
end
