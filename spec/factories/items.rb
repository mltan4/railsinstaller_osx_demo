# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    bid_duration 1
    buy_price 99.99
    category_id 1
    description "Really cool test item"
    display_title "Test Item"
    minimum_bid_price 9.99
    quantity 1
    status 1
    title "test item"
  end
end
