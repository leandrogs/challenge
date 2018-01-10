require_relative 'address'

class Order
  attr_reader :customer, :items, :payment, :address, :closed_at

  def initialize(customer, overrides = {})
    @customer = customer
    @items = []
    @address = overrides.fetch(:address) { Address.new(zipcode: '45678-979') }
  end

  def add_item(item)
    @items << item
  end

  def total_amount
    @items.map(&:total).inject(:+)
  end

  def close(closed_at = Time.now)
    @closed_at = closed_at
  end

  def deliver
    @items.each do |item|
      item.deliver(self)
    end
  end
end
