# Coins can hold any value, but work best with integers.
class Coin
  attr_reader :name, :plural_name, :value
  attr_accessor :count

  def initialize(name, value, plural_name = "#{name}s")
    @count       = 0
    @name        = name
    @plural_name = plural_name
    @value       = value
  end

  def acceptable_change?(change_owed, ncoins = 1)
    change_owed >= (@value * ncoins)
  end

  def amount_covered(change_owed)
    @count = change_owed / @value

    @count * @value
  end

  def to_s
    if @count > 1
      "#{@count} #{@plural_name}"
    elsif @count.eql?(1)
      "#{@count} #{@name}"
    end
  end
end
