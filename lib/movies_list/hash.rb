require_relative '../movies_list'

class Hash
  def symbolize_keys
    map{|k,v| [k.to_sym, v]}.to_h
  end
end