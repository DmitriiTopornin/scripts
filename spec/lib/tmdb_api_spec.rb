describe 'tmdb api' do
  let(:tmdb_api) {TmdbApi.new}

	describe 'TmdbApi all' do

		subject {tmdb_api.fetch}

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
	  	subject {tmdb_api.fetch.first}
      it{should have_key([:url,:rating,:title,:year,:duration,:genre,:country,:date,:director,:actors])}
      it 'should have genres' do
      	expect(subject[:genre]).to all be_a String
      end
    end
	end
end