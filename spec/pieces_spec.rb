require 'pieces'

describe 'King' do

	before do
		@king = King.new("king", [5, 1])
	end

	it 'has an ID' do
		expect(@king.id).to eql("king")
	end

	it 'has a location' do
		expect(@king.location).to eql([5, 1])
	end

	describe '.move' do
	end
end

describe 'Queen' do

	before do
		@queen = Queen.new("queen", [4, 1])
	end

	it 'has an ID' do
		expect(@queen.id).to eql("queen")
	end

	it 'has a location' do
		expect(@queen.location).to eql([4, 1])
	end

	describe '.move' do
	end
end

describe 'Rook' do

	before do
		@rook = Rook.new("rook1", [1, 1])
	end

	it 'has an ID' do
		expect(@rook.id).to eql("rook1")
	end

	it 'has a location' do
		expect(@rook.location).to eql([1, 1])
	end

	describe '.move' do
	end
end

describe 'Knight' do

	before do
		@knight = Knight.new("knight1", [2, 1])
	end

	it 'has an ID' do
		expect(@knight.id).to eql("knight1")
	end

	it 'has a location' do
		expect(@knight.location).to eql([2, 1])
	end

	describe '.move' do
	end
end

describe 'Bishop' do

	before do
		@bishop = Bishop.new("bishop1", [3, 1])
	end

	it 'has an ID' do
		expect(@bishop.id).to eql("bishop1")
	end

	it 'has a location' do
		expect(@bishop.location).to eql([3, 1])
	end

	describe '.move' do
	end
end

describe 'Pawn' do

	before do
		@pawn = Pawn.new("pawn1", [1, 2])
	end

	it 'has an ID' do
		expect(@pawn.id).to eql("pawn1")
	end

	it 'has a location' do
		expect(@pawn.location).to eql([1, 2])
	end

	describe '.move' do
	end
end
