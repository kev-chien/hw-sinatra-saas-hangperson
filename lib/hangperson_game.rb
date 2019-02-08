class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    # argument validation
    if letter.nil?
      raise ArgumentError
    end

    unless (letter.is_a? String)
      raise ArgumentError
    end

    if letter.size != 1
      raise ArgumentError
    end

    unless /[A-Za-z]/ =~ letter
      raise ArgumentError
    end

    letter.downcase! # case insensitive

    # valid guess
    if @guesses.include? letter or @wrong_guesses.include? letter
      return false
    end

    # check guess
    correct = @word.include? letter
    if correct
      @guesses += letter
    else
      @wrong_guesses += letter
    end
  end

  def word_with_guesses
    @word.split('').map{|letter| @guesses.include?(letter) ? letter : '-'}.join ''
  end

  def check_win_or_lose
    if @word.split('').all?{|letter| @guesses.include?(letter)}
      :win
    elsif wrong_guesses.size >= 7
      :lose
    else
      :play
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
