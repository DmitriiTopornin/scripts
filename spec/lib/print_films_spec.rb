require "spec_helper"
require "print_films"
require "movies_list"
require 'json'


describe '#print_films' do
  context 'when array of MyMoviesList objects' do
    it 'return output' do
  	  expect{print_films(MyMoviesList.from_json.all)}.to output.to_stdout 
    end
  end
  
  context 'when not array of MyMoviesList objects' do
    it 'return error' do
  	  expect{print_films("asd")}.to raise_error(NoMethodError)
    end
  end
end

describe '#print_stats' do
  context 'when array of hash objects' do
    it 'return output' do
  	  expect{print_stats(MyMoviesList.from_json.directors_movies_count).to output.to_stdout}
    end
  end
  
  context 'when not array of hash objects' do
    it 'return error' do
  	  expect{print_stats("asd")}.to raise_error(NoMethodError)
    end
  end
end
