class CartItem < ApplicationRecord
  belongs_to :cart, touch: true
  belongs_to :product

  def on_index
    { id: product.id, name: product.name, quantity: quantity,
      unit_price: unit_price, total_price: total_price }
  end

  def total_price
    product.price * quantity
  end
end
