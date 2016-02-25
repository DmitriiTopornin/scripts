describe Rating do 

	let(:movies_array){
    [
        {
          "url":"http://www.imdb.com/title/tt0061722/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=01JPHZE595567D9ZVSJ1&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_250",
          "rating":"8.0","title":"The Graduate (1967)","year":"1967",
          "duration":"106","genre":["Comedy","Drama","Romance"],
          "country":"USA","date":"1967-02-22","director":"Mike Nichols",
          "actors":"Dustin Hoffman, Anouk Aimée, Katharine Ross"
        },
        {
          "url":"http://www.imdb.com/title/tt0053779/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=01JPHZE595567D9ZVSJ1&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_249",
          "rating":"8.1","title":"Сладкая жизнь (1960)","year":
          "1960","duration":"174","genre":["Comedy","Drama"],
          "country":"Italy","date":"1960-02-05","director":"Federico Fellini",
          "actors":"Marcello Mastroianni, Anita Ekberg, Anouk Aimée"
        },
        {
          "url":"http://www.imdb.com/title/tt0317248/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=2398042102&pf_rd_r=01JPHZE595567D9ZVSJ1&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=top&ref_=chttp_tt_21",
          "rating":"8.7","title":"Город Бога (2002)","year":"2002",
          "duration":"130","genre":["Crime","Drama"],
          "country":"Russia","date":"2002","director":"Federico Fellini",
          "actors":"Alexandre Rodrigues, Matheus Nachtergaele, Leandro Firmino"
        }
      ]
  }

	context '#rate' do
		subject{MyMoviesList.new(movies_array)}
		before(:each) do
			subject.rate("The Graduate (1967)",3)
			subject.rate("Сладкая жизнь (1960)",4)
			subject.rate("Город Бога (2002)",5)
		end
		it 'should return rating' do
			expect(subject.all.map(&:my_rating)).to eq([3,4,5])
		end
	end

	context '#watched?' do
		subject{MyMoviesList.new(movies_array)}
		before(:each) {subject.rate("The Graduate (1967)",3)}
		it 'should return true, false, false' do
			expect(subject.all.map(&:watched?)).to eq([true,false,false])
		end
	end
end