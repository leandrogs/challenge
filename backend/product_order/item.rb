module ProductOrder
  class Item
    attr_reader :product

    def initialize(product:)
      @product = product
      post_initialize
    end

    def shipping_warnings
      {}
    end

    def deliver(order)
      raise NotImplementedError
    end

    def post_initialize
      nil
    end

    def total
      10
    end
  end
end
