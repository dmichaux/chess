require 'game'

describe 'Chess' do

	before do
		@game = Chess.new
	end

	describe '.new' do
		it 'creates the chess game' do
			expect(@game).to be_an_instance_of(Chess) 
		end
	end
end