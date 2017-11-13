require 'pieces'

describe 'King' do

	before do
		@king = King.new([5, 1])
	end

	it 'has a location' do
		expect(@king.location).to eql([5, 1])
	end

	describe '.move' do
	end
end

describe 'Queen' do

	before do
		@queen = Queen.new([4, 1])
	end

	it 'has a location' do
		expect(@queen.location).to eql([4, 1])
	end

	describe '.move' do
	end
end

describe 'Rook' do

	before do
		@rook = Rook.new([1, 1])
	end

	it 'has a location' do
		expect(@rook.location).to eql([1, 1])
	end

	describe '.move' do
	end
end

describe 'Knight' do

	before do
		@knight = Knight.new([2, 1])
	end

	it 'has a location' do
		expect(@knight.location).to eql([2, 1])
	end

	describe '.move' do
	end
end

describe 'Bishop' do

	before do
		@bishop = Bishop.new([3, 1])
	end

	it 'has a location' do
		expect(@bishop.location).to eql([3, 1])
	end

	describe '.move' do
	end
end

describe 'Pawn' do

	before do
		@pawn = Pawn.new([1, 2])
	end

	it 'has a location' do
		expect(@pawn.location).to eql([1, 2])
	end

	describe '.move' do
	end
end