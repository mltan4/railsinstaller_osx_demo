require 'spec_helper'

describe "items/show" do
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :title => "Title",
      :category_id => "",
      :quantity => 1,
      :description => "MyText",
      :buy_price => "9.99",
      :minimum_bid_price => "9.99",
      :bid_duration => 2
    ))
  end

  #it "renders attributes in <p>" do
  #  render
  #  # Run the generator again with the --webrat flag if you want to use webrat matchers
  #  rendered.should match(/Title/)
  #  rendered.should match(//)
  #  rendered.should match(/1/)
  #  rendered.should match(/MyText/)
  #  rendered.should match(/9.99/)
  #  rendered.should match(/9.99/)
  #  rendered.should match(/2/)
  #end
end
