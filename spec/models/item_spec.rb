require 'spec_helper'

describe Item do
  before :each do
    @item = Item.new
    @item.bid_duration = 5
    @item.buy_price = 10
    @item.category_id= 2
    @item.display_title= "Test"
    @item.title= "test"
    @item.minimum_bid_price= 15
    @item.quantity= 1
    @item.current_bid = 100
  end

  it { should be_valid }

  describe "relationships" do
    it "should belong to a category" do
      @item.is_a?(Category)
    end

    it "should belong to a user" do
      @item.is_a?(User)
    end
  end

  describe "when category_id is not present" do
    before { @item.category_id = nil }
    #xit { should_not be_valid }
  end

  describe "item methods" do
    it { should respond_to(:bid_duration) }
    it { should respond_to(:buy_price) }
    it { should respond_to(:category_id) }
    it { should respond_to(:description) }
    it { should respond_to(:minimum_bid_price) }
    it { should respond_to(:quantity) }
    it { should respond_to(:title) }
    it { should respond_to(:display_title) }
    it { should respond_to (:current_bidder_id) } #id of the current bidder
    it { should respond_to (:current_bid)} #current bidder
    it { should respond_to (:seller_id)} #current bidder
  end
end
