require 'json-schema'
require "parse"
require "webmock/rspec"

describe ImdbParser do

  schema = {"url":"http://www.imdb.com/title/tt0111161/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=01DQ6WJG448ZF5EFRPAB&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_1","rating":"9,3","title":"Побег из Шоушенка (1994)","year":"1994","duration":"142","genre":["Crime","Drama"],"country":"USA","date":"1994-10-14","director":"Frank Darabont","actors":"Tim Robbins, Morgan Freeman, Bob Gunton"}

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
    subject{ImdbParser.new}
		let(:url){'http://www.imdb.com/title/'}
		it 'should return movie' do
			expect(subject.send(:get_movie, url)).to include(actors: "Tim Robbins, Morgan Freeman, Bob Gunton")
		end
	end

	context '#get_list' do
    subject{ImdbParser.new}
		it 'should return list movie' do
			expect(subject).to receive(:get_movie).exactly(250).times
			list = subject.send(:get_list)
		end
	end

	context '#create_json' do
    subject{ImdbParser.new}
    it 'should write json to file' do
    	subject.send(:get_list)
    	subject.send(:create_json, 'test')
      expect(JSON::Validator.validate(schema, File.read('test.json'))).to eq(true)
    end
  end

end