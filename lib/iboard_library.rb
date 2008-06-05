module IboardLibrary
  def random_string(len)
     rand_max = RAND_CHARS.size
     ret = "" 
     len.times{ ret << RAND_CHARS[rand(rand_max)] }
     ret 
   end
end