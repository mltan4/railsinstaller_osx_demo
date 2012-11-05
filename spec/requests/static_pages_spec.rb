require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Welcome page" do
    before { visit welcome_index_path }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
  end

end
