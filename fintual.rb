# Construct a simple Portfolio class that has:
# - A collection of Stocks
# - "Profit" method that receives 2 dates and returns the profit of the Portfolio between those dates.
# * Assume each Stock has a "Price" method that receives a date and returns its price.
# * Bonus Track: Make the Profit method return the "annualized return" of the portfolio between the given dates.

require 'date'

MIN_DATE = Date.new(2010)
MAX_DATE = Date.today



#######################
####    Classes    ####
#######################

class Stock

  # Based on the assumption of the task:
  # - Prices will be a hash of dates and prices between 0.0 and 1.0
  attr_accessor :prices

  def initialize(prices_and_dates)
    @prices = prices_and_dates
  end

  def price(date)
    prices[date.to_s]
  rescue
    nil
  end

  def profit(init_date, end_date)
    price(end_date) - price(init_date)
  end
end

class Portafolio
  attr_accessor :stocks

  def initialize(stocks)
    @stocks = stocks
  end

  def profit(init_date, end_date, annualized = true)
    profit = stocks.map{ |s| s.profit(init_date, end_date) }.sum 
    return profit unless annualized
    cost = stocks.map{ |s| s.price(init_date) }.sum
    (1.0 + profit/cost)**(1.0/years(init_date, end_date)) - 1.0
  end

  def profit_percentage(init_date, end_date)
    cost = stocks.map{ |s| s.price(init_date) }.sum
    profit(init_date, end_date, false) / cost * 100
  end

end



#######################
####    Methods    ####
#######################

# Just for the sake of the exercise, here's a method that would work as big initializer to test the code
def setup
  n_stocks = rand(3..50)
  p "Creating Portafolio with #{n_stocks} stocks. Each with prices ranging from 0.0 to 1.0, from 2010 until today."
  stocks = n_stocks.times.map do
    hash = Hash.new { |h, k| h[k.to_s] = rand }.tap do |h|
      h.values_at(*(MIN_DATE..MAX_DATE))
    end
    Stock.new(hash)
  end

  @portfolio = Portafolio.new(stocks)
end

def get_date
  Date.strptime(gets.chomp, '%m-%d-%Y')
end

def years(init_date, end_date)
  end_date.year - init_date.year
end

def linebreak
  p "----------------------------"
end

########################
####   IO Section   ####
########################

p "Welcome to Benjamin's task for Fintual's application!"
linebreak
init_date, end_date = nil
setup

linebreak

while !init_date
  begin
    p "Please give us an initial date to calculate the profit of our newly made portafolio with the following format [MM-DD-YYYY]: "
    init_date = get_date
    raise "Whoops! That date is either out of boundaries" unless init_date.between?(MIN_DATE, MAX_DATE)
  rescue Date::Error => e
    init_date = nil
    p "Whoops! That's not the correct format.\n\n"
  rescue StandardError => e
    p e
    init_date = nil
  end
end

linebreak

while !end_date
  begin
    p "Now, please input an end date to calculate the profit of our newly made portafolio [MM-DD-YYYY]: "
    end_date = get_date
    raise "Whoops! That date is either out of boundaries or older than the first date given" unless end_date.between?(init_date, MAX_DATE) || end_date > init_date
  rescue Date::Error => e
    init_date = nil
    p "Whoops! That's not the correct format.\n\n"
  rescue StandardError => e
    p e
    init_date = nil
  end
end

linebreak
p "Calculating!\n\n*drum rolls*\n*drum rolls*\n*drum rolls*\n\n"

profit     = @portfolio.profit(init_date, end_date, false).round(5)
percentage = @portfolio.profit_percentage(init_date, end_date).round(2)
years      = years(init_date, end_date)

p "- Your total portafolio profit is: #{profit} (#{percentage}%)"

if years > 1
  annualized = @portfolio.profit(init_date, end_date)
  p "- Your annualized profit for #{years} years is: #{annualized}"
end
