require 'spec_helper'

describe "Item Pages" do
  subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      visit welcome_index_path
    end

    it { should have_selector('title', text: full_title('')) }

    describe "should be able to sell an item" do
      before do
        sign_in user
        click_button "Sell item"
      end
      it { should have_selector('h1',    text: 'New item') }
    end

    describe "search with valid information" do
      let(:search_name)  { "capybara_test_item" }
      before do
        sign_in user
        #create_new_item          #TODO: When creating a new item, error is "Couldn't find Category without an ID"
        #visit welcome_index_path
        fill_in "item_title",    with: search_name
        click_button "search_btn"
      end
      it { should have_selector('h1', text: "Search Results") }
    end

    describe "signup" do

      before { visit new_user_registration_path }

      let(:submit) { "Sign up" }

      describe "with invalid information" do
        before { click_button submit}
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end
      end


      describe "with valid information" do
        before do
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Password confirmation", with: "foobar"
        end

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email('user@example.com') }

          it { should have_selector('div.alert.alert-success', text: 'Welcome! You have signed up successfully.') }
          it { should have_link('Sign Out') }
        end
      end
    end

  end
end