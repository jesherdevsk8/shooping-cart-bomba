class CartItem < ApplicationRecord
  belongs_to :cart, touch: true
  belongs_to :product

  after_save :reactivate_cart
  after_destroy :reactivate_cart

  def on_index
    { id: product.id, name: product.name, quantity: quantity,
      unit_price: unit_price, total_price: total_price }
  end

  def total_price
    product.price * quantity
  end

  private

  def reactivate_cart
    cart.update!(status: :active) if cart.abandoned?
  end
end
