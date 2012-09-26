# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    title "MyString"
    category_id ""
    quantity 1
    description "MyText"
    buy_price "9.99"
    minimum_bid_price "9.99"
    bid_duration 1
  end
end
