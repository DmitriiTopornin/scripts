describe 'tmdb api' do
	describe 'Tmdb_api#all' do
	  context 'should be an array' do
	  	subject {Tmdb_api.new}
		  it(subject.fetch).to be_an(Array)
	  end

	  context 'should contain 250 elements' do
	  	subject {Tmdb_api.new}
		  it(subject.fetch.count).to eq(250)
	  end

	  context 'element-hash should has genres key' do
	  	subject {Tmdb_api.new}
		  it(subject.fetch[0][:genres]).to include("Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "Foreign", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western")
	  end

	  context 'should return hash' do
	  	subject {Tmdb_api.new}
	  	it(subject.fetch).to include({
          "url":"http://www.imdb.com/title/tt0061722/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=01JPHZE595567D9ZVSJ1&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_250",
          "rating":"8.4","title":"Whiplash","year":"2014",
          "duration":"105","genre":["Drama","Music"],
          "country":"US","date":"2014-10-10","director":"Damien Chazelle",
          "actors":["Miles Teller", "J.K. Simmons", "Melissa Benoist", "Austin Stowell", "Jayson Blair", "Kavita Patil", "Paul Reiser", "Nate Lang", "Chris Mulkey", "Damon Gupton", "Suanne Spoke", "Max Kasch", "Charlie Ian", "Kofi Siriboe", "C.J. Vana", "Tarik Lowe", "Tyler Kimball", "Rogelio Douglas Jr.", "Adrian Burks", "Joseph Bruno", "Michael D. Cohen", "Jocelyn Ayanna", "Keenan Henson", "Janet Hoskins", "April Grace", "Clifton 'Fou Fou' Eddie", "Calvin C. Winbush", "Marcus Henderson", "Tony Baker", "Henry G. Sanders", "Sam Campisi", "Jimmie Kirkpatrick", "Keenan Allen", "Ayinde Vaughan", "Shai Golan", "Yancey Wells", "Candace Roberge", "Krista Kilber", "Cici Leah Campbell", "Damien Coates", "Kyle Julian Graham", "Ellee Jane Hounsell", "Stephen Hsu", "Herman Johansen", "Wendee Lee", "Dakota Lupo", "Jesse Mitchell", "Amanda Newman", "Joseph Oliveira", "Michelle Ruff", "Daniel Weidlein"].join(', ')
        })
    end
	end
end