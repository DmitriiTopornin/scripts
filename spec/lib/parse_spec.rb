require "parse"
require "webmock/rspec"

describe ImdbParser do

	context '#get_movie' do
		let(:url){'http://www.imdb.com/title/'}
		it 'should return movie' do
			expect(ImdbParser.get_movie(url)).to include(actors: "Tim Robbins, Morgan Freeman, Bob Gunton")
		end
	end

	context '#get_list' do
		# before(:each) {ImdbParser.get_list}
		it 'should return list movie' do
			expect(ImdbParser.get_list).to have_been_made.times(1)
		end
	end
end