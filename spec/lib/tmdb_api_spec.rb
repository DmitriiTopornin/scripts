describe 'tmdb api' do
	describe 'Tmdb_api#all' do
	  context 'should be an array' do
		  it(Tmdb_api.all).to be_an(Array)
	  end

	  context 'should contain 250 elements' do
		  it(Tmdb_api.all.count).to eq(250)
	  end

	  context 'element-hash should has genres key' do
		  it(Tmdb_api.all[0][:genres]).to include("Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "Foreign", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western")
	  end
	end
end