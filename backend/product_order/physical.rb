require_relative 'item'
require_relative '../shipping_label'

module ProductOrder
  class Physical < Item
    def deliver(order)
      ShippingLabel.new(product: self, address: order.address).generate
    end
  end
end
