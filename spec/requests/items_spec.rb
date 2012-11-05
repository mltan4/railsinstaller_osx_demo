require 'spec_helper'

describe "Item Pages" do
  subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit welcome_index_path
    end

    it { should have_selector('title', text: full_title('')) }

    describe "should be able to sell an item" do
      before { click_button "Sell item" }
      it { should have_selector('h1',    text: 'New item') }
    end

    #describe "search for item" do
    #  visit items_path
    #  it { should have_selector('title', text: full_title('')) }
    #end

  end
end