# frozen_string_literal: true

require 'rails_helper'

# rspec spec/models/cart_spec.rb

RSpec.describe Cart, type: :model do
  context 'Validations and associations' do
    describe 'Associations' do
      it { is_expected.to have_many(:items).class_name('CartItem').dependent(:destroy) }
      it { is_expected.to have_many(:products).through(:items) }
    end

    describe 'when validating' do
      it 'validates numericality of total_price' do
        cart = described_class.new(total_price: -1)
        expect(cart.valid?).to be_falsey
        expect(cart.errors[:total_price]).to include('must be greater than or equal to 0')
      end
    end
  end

  describe 'mark_as_abandoned' do
    let(:shopping_cart) { create(:cart) }

    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      shopping_cart.update_column(:updated_at, 3.hours.ago)

      expect(described_class.mark_as_abandoned).to eq(1)
      expect(described_class.abandoned.exists?(shopping_cart.id)).to be_truthy
    end
  end

  describe 'cleanup_abandoned' do
    let(:shopping_cart) { create(:cart, status: :abandoned, updated_at: 7.days.ago) }

    it 'removes the shopping cart if abandoned for a certain time' do
      expect(described_class.abandoned.exists?(shopping_cart.id)).to be_truthy

      described_class.cleanup_abandoned
      expect(described_class.any?).to be_falsey
      expect(described_class.active.exists?(shopping_cart.id)).to be_falsey
    end
  end
end
