# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    total_price { 0 }
    status { :active }
  end
end
