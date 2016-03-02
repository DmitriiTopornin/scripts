require "parse"
require "webmock/rspec"

describe ImdbParser do

	imdb_top = File.readlines("spec/fixtures/IMDb Top 250 - IMDb.html").join
  imdb_movie = File.readlines("spec/fixtures/Побег из Шоушенка (1994) - IMDb.html").join

	before(:each) do
    stub_request(:get, "www.imdb.com/title/").
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: imdb_movie, headers: {})
    stub_request(:get, /www.imdb.com\/title/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: imdb_movie, headers: {})

    stub_request(:get, "www.imdb.com/chart/top").
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: imdb_top, headers: {})
  end

	context '#get_movie' do
		let(:url){'http://www.imdb.com/title/'}
		it 'should return movie' do
			expect(ImdbParser.get_movie(url)).to include(actors: "Tim Robbins, Morgan Freeman, Bob Gunton")
		end
	end

	context '#get_list' do
		it 'should return list movie' do
			expect(ImdbParser).to receive(:get_movie).exactly(250).times
			list = ImdbParser.get_list
		end
	end

	context '#create_json' do
    it 'should write json to file' do
    	ImdbParser.get_list
    	ImdbParser.create_json('test')
    	expect(File.open('test.json', "r").read).to include("Побег из Шоушенка (1994)")
    end
  end

end