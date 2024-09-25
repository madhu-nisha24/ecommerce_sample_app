FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    quantity { 10 }
    association :category  # If you have a Category model, ensure this association exists.
  end
end# frozen_string_literal: true

