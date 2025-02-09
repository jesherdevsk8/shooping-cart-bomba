# frozen_string_literal: true

require 'rails_helper'

# rspec spec/models/cart_item_spec.rb

RSpec.describe CartItem, type: :model do
  context 'Validations and associations' do
    it { is_expected.to belong_to(:cart).touch(true) }
    it { is_expected.to belong_to(:product) }
  end

  context 'Callbacks' do
    let(:cart) { create(:cart, status: :abandoned, updated_at: 4.hours.ago) }
    let(:product) { create(:product, price: 10.0) }
    let(:item) { build(:cart_item, cart: cart, product: product, quantity: 2) }

    it 'reactivates the cart when a cart item is saved' do
      expect(Cart.abandoned.exists?(cart.id)).to be_truthy
      expect { item.save! }.to change { cart.reload.status }.from('abandoned').to('active')
    end
  end
end
