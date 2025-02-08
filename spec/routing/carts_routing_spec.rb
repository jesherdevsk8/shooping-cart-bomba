# frozen_string_literal: true

require 'rails_helper'

# rspec spec/routing/carts_routing_spec.rb

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #index' do
      expect(get: carts_path).to route_to('carts#index')
    end

    it 'routes to #create' do
      expect(post: carts_path).to route_to('carts#create')
    end

    it 'routes to #add_item via PATCH' do
      expect(patch: add_item_carts_path).to route_to('carts#update')
    end

    it 'routes to #destroy via DELETE' do
      expect(delete: remove_items_carts_path(1)).to route_to('carts#destroy', product_id: '1')
    end
  end
end
