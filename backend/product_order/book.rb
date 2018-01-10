require_relative 'item'
require_relative '../shipping_label'

module ProductOrder
  class Book < Item
    def shipping_warnings
      { warning: "Books are free of federal taxes. Constitution Art. 150, VI, d." }
    end

    def deliver(order)
      ShippingLabel.new(product: self, address: order.address).generate
    end
  end
end
