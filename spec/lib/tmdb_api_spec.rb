require 'vcr'
require "webmock/rspec"
require 'rspec/its'
require 'tmdb_api.rb'

WebMock.allow_net_connect!

RSpec.describe 'tmdb api', vcr: true do
  let(:tmdb_api) {
    VCR.use_cassette('tmdb-fetch'){
      TmdbApi.new.fetcher
    }
  }

	describe 'TmdbApi all' do

    subject {tmdb_api}

    context 'should be an array' do
      it{should be_an Array}
    end

    context 'should contain 250 elements' do
      its(:count){should eq(250)}
    end

    context 'element-hash should has genres' do
      it{should all be_a Hash}
    end

    context 'one element' do
      subject {tmdb_api.first}
      it 'should contain certain keys' do
        expect(subject.keys).to contain_exactly(:url,:rating,:title,:year,:duration,:genre,:country,:date,:director,:actors)
      end
      it 'should have genres' do
        expect(subject[:genre]).to all be_a String
      end
    end
  end
end