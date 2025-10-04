require 'rails_helper'

RSpec.describe "Navbar", type: :system do
  before do
    driven_by(:selenium_chrome_mobile)
    visit root_path
  end

  it "shows the dock panel" do
      expect(page).to have_css(".dock")
  end

  it "has the add new place link" do
    within ".dock" do
      expect(page).to have_link(href: new_place_path)
    end
  end

  it "navigates to new place page when clicking the link" do
    within ".dock" do
      find("a[href='#{new_place_path}'").click
    end

    expect(page).to have_current_path(new_place_path)
  end
end
