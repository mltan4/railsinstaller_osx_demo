require 'spec_helper'

describe "items/index" do
  before(:each) do
    assign(:items, [
      stub_model(Item,
        :title => "Title",
        :category_id => "",
        :quantity => 1,
        :description => "MyText",
        :buy_price => "9.99",
        :minimum_bid_price => "9.99",
        :bid_duration => 2
      ),
      stub_model(Item,
        :title => "Title",
        :category_id => "",
        :quantity => 1,
        :description => "MyText",
        :buy_price => "9.99",
        :minimum_bid_price => "9.99",
        :bid_duration => 2
      )
    ])
  end

  it "renders a list of items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
