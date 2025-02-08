# frozen_string_literal: true

require 'rails_helper'

# rspec spec/models/cart_item_spec.rb

RSpec.describe CartItem, type: :model do
  context 'Validations and associations' do
    it { is_expected.to belong_to(:cart).touch(true) }
    it { is_expected.to belong_to(:product) }
  end
end
