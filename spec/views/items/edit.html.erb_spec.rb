require 'spec_helper'

describe "items/edit" do
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :title => "MyString",
      :category_id => "",
      :quantity => 1,
      :description => "MyText",
      :buy_price => "9.99",
      :minimum_bid_price => "9.99",
      :bid_duration => 1
    ))
  end

  it "renders the edit item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path(@item), :method => "post" do
      assert_select "input#item_title", :name => "item[title]"
      assert_select "input#item_category_id", :name => "item[category_id]"
      assert_select "input#item_quantity", :name => "item[quantity]"
      assert_select "textarea#item_description", :name => "item[description]"
      assert_select "input#item_buy_price", :name => "item[buy_price]"
      assert_select "input#item_minimum_bid_price", :name => "item[minimum_bid_price]"
      assert_select "input#item_bid_duration", :name => "item[bid_duration]"
    end
  end
end
