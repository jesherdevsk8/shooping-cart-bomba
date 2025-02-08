require 'rails_helper'

# rspec spec/models/product_spec.rb

RSpec.describe Product, type: :model do
  context 'Associations' do
    it { is_expected.to have_many(:items).class_name('CartItem').dependent(:destroy) }
    it { is_expected.to have_many(:carts).through(:items) }
  end

  context 'when validating' do
    it 'validates presence of name' do
      product = described_class.new(price: 100)
      expect(product.valid?).to be_falsey
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of price' do
      product = described_class.new(name: 'name')
      expect(product.valid?).to be_falsey
      expect(product.errors[:price]).to include("can't be blank")
    end

    it 'validates numericality of price' do
      product = described_class.new(price: -1)
      expect(product.valid?).to be_falsey
      expect(product.errors[:price]).to include('must be greater than or equal to 0')
    end
  end
end
