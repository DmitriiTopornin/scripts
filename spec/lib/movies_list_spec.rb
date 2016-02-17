require "spec_helper"
require "movies_list"

describe 'movies_list' do

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

  describe MoviesList do 

    subject{MyMoviesList.new(movies_array)}

    context '#all' do
      it 'should return array with 3 elements' do
        expect(subject.all.count).to eq(3)
      end
    end

    context '#by_genre' do
      let(:test_genre){'Comedy'}
      it 'should return array with 2 elements' do
        expect(subject.by_genre(test_genre).map(&:genre)).to all include(test_genre)
      end
    end

    context '#exclude_genre' do
      let(:test_genre){'Romance'}
      subject{MyMoviesList.new(movies_array).by_genre(test_genre).map(&:genre)}
      it {should_not include(test_genre)}
    end

    context '#sort_by' do
      let(:sort_field){'duration'}
      subject{MyMoviesList.new(movies_array).sort_by(sort_field).map(&:duration)}
      it {should eq([106,130,174])}
    end

    context '#longest' do
      subject{MyMoviesList.new(movies_array).longest(1).first.duration}
      it {should eq(174)}
    end

    context '#genre_date' do
      let(:test_genre){'Comedy'}
      subject{MyMoviesList.new(movies_array).genre_date(test_genre).map(&:year)}
      it {should eq(["1960","1967"])}
    end

    context '#directors' do
      subject{MyMoviesList.new(movies_array).directors}
      it {should eq(["Federico Fellini","Mike Nichols"])}
    end

    context '#not_from' do
      subject{MyMoviesList.new(movies_array).not_from.map(&:country)}
      it {should_not include('USA')}
    end

    context '#directors_movies_count' do
      subject{MyMoviesList.new(movies_array).directors_movies_count.values}
      it {should eq([1,2])}
    end

    context '#actors_movies_count' do
      subject{MyMoviesList.new(movies_array).actors_movies_count.values.sort}
      it {should eq([1,1,1,1,1,1,1,2])}
    end

    context '#count_by_month' do
      subject{MyMoviesList.new(movies_array).count_by_month.values.sort}
      it {should eq([1,2])}
    end

    context '#director_movies' do
      let(:director_test){'Federico Fellini'}
      subject{MyMoviesList.new(movies_array).director_movies(director_test).map(&:director)}
      it {should include(director_test)}
    end
  end
end