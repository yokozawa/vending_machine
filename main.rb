require 'pry'

class Drink
  attr_reader :name, :price

  def self.cola
    self.new :cola, 120
  end

  def self.sprite
    self.new :sprite, 120
  end

  def self.redbull
    self.new :redbull, 200
  end

  def initialize(name, price)
    @name = name
    @price = price
  end

  def to_s
    "<Drink: name=#{name}, price=#{price}>"
  end
end

class VendingMachine
  AVAILABLE_MONEY = [10, 50, 100, 500, 1000].freeze

  attr_reader :total, :sale_amount

  def initialize
    @total = 0
    @sale_amount = 0
    @drink_table = {}
    5.times { store Drink.cola }
  end

  def insert(money)
    if AVAILABLE_MONEY.include?(money)
      nil.tap { @total += money }
    else
      money
    end
  end

  def refund
    total.tap { @total = 0 }
  end

  def store(drink)
    nil.tap do
      @drink_table[drink.name] = {
          price: drink.price,
          drinks: [] } unless @drink_table.has_key? drink.name
      @drink_table[drink.name][:drinks] << drink
    end
  end

  def purchase(drink_name)
    if purchasable? drink_name
      drink = @drink_table[drink_name][:drinks].pop
      @sale_amount += drink.price
      @total -= drink.price
      [drink, refund]
    end
  end

  def purchasable?(drink_name)
    purchasable_drink_names.include? drink_name
  end

  def purchasable_drink_names
    @drink_table.select{|_, info|
      info[:price] <= total && info[:drinks].any? }.keys
  end

  def stock_info
    Hash[@drink_table.map {|name, info|
      [name, { price: info[:price], stock: info[:drinks].size }]
    }]
  end
end

machine = VendingMachine.new

p machine.insert 10
p machine.insert 50

p machine.total

p machine.insert 5

p machine.refund

p machine.store Drink.redbull
p machine.store Drink.cola

p machine.stock_info

p machine.insert 100
p machine.insert 50
p machine.purchasable_drink_names

p machine.purchasable? :cola
p machine.purchasable? :redbull

p machine.purchase :cola

p machine.sale_amount
