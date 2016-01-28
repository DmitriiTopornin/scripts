module Rating
	module List
	  def rate(title, my_rating)
      item = self.all.detect{|item| item.title == title}
      item.watch = true
      item.my_rating = my_rating
      item
    end
  end

  module Item
  	attr_accessor :my_rating, :watch
  	def watched?
  		watch
  	end
  end
end