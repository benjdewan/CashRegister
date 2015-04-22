require 'coin'

# For managing arrays of coins
class CoinArray
  include Enumerable

  attr_accessor :coins

  def initialize
    @coins = [Coin.new('dollar', 100),
              Coin.new('quarter', 25),
              Coin.new('dime', 10),
              Coin.new('nickel', 5),
              Coin.new('penny', 1, 'pennies')]
  end

  def [](index = nil)
    return @coins[index] if index

    @coins
  end

  def length
    @coins.length
  end

  def map(&block)
    @coins.map do |coin|
      block.call(coin)
    end
  end

  def each(&block)
    @coins.each do |coin|
      if block_given?
        block.call(coin)
      else
        yield coin
      end
    end
  end

  def calculate_change_randomly(amount_owed)
    while amount_owed > 0
      coin = @coins[rand(@coins.length)]
      ncoins = rand(10)
      if coin.acceptable_change?(amount_owed, ncoins)
        amount_owed -= (coin.value * ncoins)
        coin.count += ncoins
      end
    end
    self
  end

  def calculate_change(amount_owed)
    @coins.each do |coin|
      amount_owed -= coin.amount_covered(amount_owed)
    end
    self
  end

  def to_s
    @coins.map(&:to_s).compact.join(',')
  end
end
