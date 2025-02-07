# frozen_string_literal: true

## create products
5.times do
  Product.create(
    name: Faker::Commerce.product_name,
    price: Faker::Commerce.price
  )
end
