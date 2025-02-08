# frozen_string_literal: true

require 'rails_helper'

# rspec spec/requests/carts_spec.rb

RSpec.describe CartsController, type: :request do
  let(:cart) { create(:cart) }
  let(:products) { create_list(:product, 5) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: products.first, quantity: 1) }

  context 'GET /index' do
    let!(:cart_items) do
      products.sample(3).each do |product|
        create(:cart_item, cart: cart, product: product)
      end
    end

    it 'retrieves the cart items' do
      get carts_url, as: :json

      expect(response).to be_successful
      # TODO
      # expect(JSON.parse(response.body)).to eq(1)
    end
  end

  context 'POST /cart' do
    describe 'when the parameters are valid and invalid' do
      let(:product) { create(:product) }

      it 'returns bad request when body is not passed' do
        post carts_url, as: :json

        expect(response).to be_a_bad_request
      end

      it 'adds a product to the cart' do
        quantity = 2
        post carts_url, as: :json, params: { product_id: product.id, quantity: quantity }

        expect(response).to be_successful
        ## rever aqui
        expect(
          JSON.parse(response.body, symbolize_names: true)[:products]
        ).to eq([{ id: product.id, name: product.name, quantity: quantity, unit_price: product.price.to_s,
                   total_price: (product.price * quantity).to_s }])
      end

      it 'returns not found when product is not found' do
        post carts_url, as: :json, params: {}

        expect(response).to be_a_not_found

        post carts_url, as: :json, params: { quantity: 2 }

        expect(response).to be_a_not_found

        post carts_url, as: :json, params: { product_id: Product.last.id + 1, quantity: 2 }

        expect(response).to be_a_not_found
      end

      it 'returns bad request when quantity is not passed' do
        post carts_url, as: :json, params: { product_id: product.id }

        expect(response).to be_a_bad_request
      end
    end

    describe 'when the product already is in the cart' do
      let(:product) { products.second }

      it 'updates the quantity of the existing item in the cart' do
        post carts_url, params: { product_id: product.id, quantity: 1 }, as: :json

        current_cart = Cart.find(JSON.parse(response.body)['id'])

        expect(response).to be_successful
        expect(current_cart.items.find_by(product_id: product.id).quantity).to eq(1)

        post carts_url, params: { product_id: product.id, quantity: 1 }, as: :json
        expect(current_cart.items.find_by(product_id: product.id).quantity).to eq(2)

        new_product = create(:product)
        post carts_url, params: { product_id: new_product.id, quantity: 1 }, as: :json
        expect(current_cart.items.find_by(product_id: new_product.id).quantity).to eq(1)
      end

      it 'creates a new item in the cart if the product is not already in the cart' do
        new_product = create(:product)
        post carts_url, params: { product_id: new_product.id, quantity: 1 }, as: :json

        current_cart = Cart.find(JSON.parse(response.body)['id'])
        expect(current_cart.items.find_by(product_id: new_product.id).quantity).to eq(1)
      end
    end
  end

  context 'PATCH /add_item' do
    describe 'whenre updating the quantity' do
      let(:product) { products.first }

      it 'returns not found when product is not found on cart' do
        post add_item_carts_url, params: { product_id: product.id, quantity: 1 }, as: :json

        expect(response).to be_a_not_found
      end

      it 'updates the quantity of the existing item in the cart' do
        post carts_url, params: { product_id: product.id, quantity: 1 }, as: :json

        current_cart = Cart.find(JSON.parse(response.body)['id'])
        expect(current_cart.items.find_by(product_id: product.id).quantity).to eq(1)

        patch add_item_carts_url, params: { product_id: product.id, quantity: 5 }, as: :json

        expect(response).to be_successful
        expect(current_cart.items.find_by(product_id: product.id).quantity).to eq(5)
      end

      it 'returns bad request when quantity is not passed' do
        post carts_url, params: { product_id: product.id, quantity: 1 }, as: :json

        current_cart = Cart.find(JSON.parse(response.body)['id'])

        patch add_item_carts_url, params: { product_id: product.id, quantity: ['', nil, 0].sample }, as: :json

        expect(current_cart.items.find_by(product_id: product.id)&.product_id).to eq(product.id)
        expect(response).to be_a_bad_request
      end
    end
  end

  context 'DELETE /cart/:product_id' do
    describe 'When deleting an product on the cart' do
      let(:product) { products.third }

      before(:example) do
        post carts_url, params: { product_id: product.id, quantity: 2 }, as: :json
      end

      it 'destroys the item in the cart' do
        current_cart = Cart.find(JSON.parse(response.body)['id'])
        expect(current_cart.items.find_by(product_id: product.id)&.product_id).to eq(product.id)

        delete remove_items_carts_url(product.id)

        expect(response).to be_successful
        expect(current_cart.items).to be_empty
      end

      it 'returns bad request when product is not passed' do
        delete remove_items_carts_url(Product.last.id + 1)

        expect(response).to be_a_not_found
      end
    end
  end
end
