class Code
  attr_reader :pegs

  PEGS = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow,
    "O" => :orange,
    "P" => :purple
  }
  
  def initialize (pegs)
    @pegs = pegs
  end
  

  def self.parse (str)
    pegs = str.split("").map do |ltr|
      raise "Invalid Input" if !PEGS.has_key?(ltr.upcase)
      PEGS[ltr.upcase]
    end

    Code.new(pegs)
  end
  
  def self.random
    pegs = []
    4.times { pegs << PEGS.values.sample }
    Code.new(pegs)
  end
  
#############

  def [] (i)
    pegs[i]
  end

  def exact_matches(code)
    matches = @pegs.map.with_index{|el,idx| el if el == code[idx]}.compact
    matches.count
  end

  def near_matches(code)
    colors = (@pegs + code.pegs).uniq
    num = colors.reduce(0) {|a,c| a + [code.pegs.count(c), @pegs.count(c)].min}
    num - exact_matches(code)
  end

  def ==(code)
    return true if exact_matches(code) == 4
    false
  end
  
end

class Game
  attr_reader :secret_code

  def initialize
    
  end

  def random
  end
end
