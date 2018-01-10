class ShippingLabel
  def initialize(product:, address:)
    @product = product
    @address = address
  end

  def generate
    {
      address: @address
    }.merge(@product.shipping_warnings)
  end
end
