module Rating
	module List
	  def rate(title, my_rating)
      item = self.all.detect{|item| item.title == title}
      raise "movie not found" if item.nil?
      item.my_rating = my_rating
      item
    end
  end

  module Item
  	attr_accessor :my_rating
  	def watched?
  		!my_rating.nil?
  	end
  end
end