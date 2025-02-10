# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :validate_product_presence, only: %i[create update destroy]

  def index
    render(json: cart_response, status: :ok)
  end

  def create
    return render_bad_request if (quantity = cart_params[:quantity].to_i) <= 0

    cart_item = current_cart.items.find_or_initialize_by(product: @product)
    cart_item.quantity += quantity
    cart_item.unit_price = @product.price
    cart_item.total_price = cart_item.quantity * cart_item.unit_price

    if cart_item.save
      render(json: cart_response, status: :created)
    else
      render(json: item.errors, status: :unprocessable_entity)
    end
  end

  def update
    return render_not_found unless (cart_item = current_cart&.items&.find_by_product_id(@product.id))
    return render_bad_request if (quantity = cart_params[:quantity].to_i) <= 0

    cart_item.quantity = quantity
    cart_item.unit_price = @product.price
    cart_item.total_price = cart_item.quantity * cart_item.unit_price

    if cart_item.save
      render(json: cart_response, status: :ok)
    else
      render(json: cart_item.errors, status: :unprocessable_entity)
    end
  end

  def destroy
    return render_not_found unless (cart_item = current_cart&.items&.find_by_product_id(@product.id))

    cart_item.destroy
    current_cart.destroy if current_cart.items.empty?

    render json: { message: 'Item removido do carrinho' }, status: :ok
  end

  private

  def validate_product_presence
    @product ||= Product.find_by_id(cart_params[:product_id])

    render_not_found unless @product
  end

  def cart_response
    { id: current_cart.id, products: current_cart.items.map(&:on_index),
      total_price: current_cart.total_price }
  end

  def cart_params
    params.permit(:product_id, :quantity)
  end
end
