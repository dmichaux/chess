require 'board'

describe 'Board' do

	before do
		@board = Board.new("x", "y")
	end

	it 'has 64 squares' do
		expect(@board.squares.size).to eql(64)
	end

	describe '.print_board' do
	end

	describe '.populate_squares' do
	end
end