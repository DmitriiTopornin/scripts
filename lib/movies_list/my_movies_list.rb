require_relative '../movies_list'

class MyMoviesList < MoviesList

  include Rating::List

  def random_not_watched
    @movies.reject(&:watched?)
      .sort_by {|movie| rand*movie.rating.to_f*movie.class.get_weight.to_f }.last(5)
  end

  def random_watched
    @movies.select(&:watched?)
      .sort_by {|movie| rand*movie.rating.to_f*movie.class.get_weight.to_f }.last(5)
  end

  def genre_list
    @genre ||= @movies.map {|movie| movie.genre }.flatten.uniq!
  end
end