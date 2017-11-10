require 'player'

describe 'Player' do
	
	before do
		@player = Player.new
	end

	it 'has game pieces' do
		expect(@player.pieces).not_to be_empty
	end

	describe '.take_turn' do
	end
end