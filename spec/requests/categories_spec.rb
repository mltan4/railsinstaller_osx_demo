require 'spec_helper'

describe "Categories" do
  describe "GET request" do
    it "should have an HTTP response status of 200" do
      get categories_path
      response.status.should be(200)
    end
  end
end
