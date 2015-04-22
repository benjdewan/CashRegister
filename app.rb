#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__) + '/lib'

require 'coin'
require 'coin_array'
require 'csv'

# Extension method on String
class String
  def money_to_i
    (to_f * 100.0).to_i
  end
end

# The IO layer of the application
class App
  Remainder = Struct.new(:value, :randomize)

  def float?(string)
    return false unless string

    # This regex is from the Float() method of Rubinius
    string =~ /^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/
  end

  def well_formed?(row)
    return true if float?(row[0]) && float?(row[1])
    $stderr.puts "#{row} is not well-formatted and will be ignored"
    false
  end

  def read_file(filename) #rubocop Disable:MethodLength
    change_array = []
    CSV.foreach(filename) do |row|
      next unless well_formed?(row)
      cost = row[0].money_to_i
      payment = row[1].money_to_i

      next unless payment > cost

      if (cost % 3) == 0
        change_array << Remainder.new(payment - cost, true)
      else
        change_array << Remainder.new(payment - cost, false)
      end
    end
    change_array
  end

  def process_input(filename)
    begin
      change_array = read_file(filename)
    rescue Errno::ENOENT
      $stderr.puts "'#{filename}' does not exist"
      usage
      exit 1
    end
  end

  def change
    @change ||= process_input(ARGV[0])
  end

  # This unindent function is from:
  # https://docwhat.org/unindenting-heredocs-ruby/
  def unindent(string)
    first = string[/\A\s*/]
    string.gsub(/^#{Regexp.quote first}/, '')
  end

  def usage
    $stderr.puts unindent <<-EOF
      Usage: /path/to/change/app.rb <input_csv>
      Given a file with a list of cost and payment pairs provide
      the correct amount of change (in dollars, quarters, dimes, nickels and
      pennies) to give to a customer.

      If the cost is divisible by three the change produced will be randomly
      distributed (but still exact change) otherwise the change will be given
      in the fewest coins possible.
    EOF
  end

  def process(change_array)
    change_array.map do |remainder|
      change_owed = CoinArray.new
      if remainder.randomize
        change_owed = change_owed.calculate_change_randomly(remainder.value)
      else
        change_owed = change_owed.calculate_change(remainder.value)
      end
      puts change_owed
    end
  end

  def run
    process(change)
  end
end

App.new.run
