# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :validate_body_presence, only: %i[create update]
  before_action :current_cart

  def render_not_found
    render(json: { error: 'Produto não encontrado' }, status: :not_found)
  end

  def render_bad_request
    render(json: { error: 'Quantidade inválida' }, status: :bad_request)
  end

  private

  def validate_body_presence
    render(json: { error: 'Body da requisição está vazio' }, status: :bad_request) if request.body.read.empty?
  end

  def current_cart
    Rails.logger.debug("session[:cart_id]: #{session[:cart_id]}") if Rails.env.development?
    @current_cart ||= Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end
end
