class Code
  attr_reader :pegs

  PEGS = {
    "R" => "red",
    "G" => "green",
    "B" => "blue",
    "Y" => "yellow",
    "O" => "orange",
    "P" => "purple"
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
    @pegs[i]
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

  def initialize (code=Code.random)
    @secret_code = code
    @guesses = 10
  end

  def play
    matches = 0
    while matches < 4 && @guesses > 0
      code = get_guess
      display_matches(code)
      matches = @secret_code.exact_matches(code)
      @guesses -= 1
    end
    puts "You Lost!" if @guesses == 0
    puts "You Won!" if @guesses > 0
  end

  def get_guess
    puts "Guess 4 Colors (e.g. rygb)"
    puts "=========================="
    puts "r = red    //  o = orange"
    puts "g = green  //  y = yellow"
    puts "b = blue   //  p = purple"
    p @secret_code

    begin
      Code.parse(gets.chomp)
    rescue
      puts "Input Not Valid"
      get_guess
    end    
  end

  def display_matches(code)
    puts "You have #{@secret_code.exact_matches(code)} exact matches"
    puts "You have #{@secret_code.near_matches(code)} near matches"
    puts ">>>#{@guesses - 1} guesses left<<<"
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end