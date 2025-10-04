require 'rails_helper'

RSpec.describe "Navbar", type: :system do
  before do
    driven_by(:selenium_chrome_mobile)
    visit root_path
  end

  it "shows the dock panel" do
      expect(page).to have_css(".dock")
  end
end
