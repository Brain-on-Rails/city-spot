require 'rails_helper'

RSpec.describe "Navbar", type: :system, mobile: true do
  before do
  end

  it "shows the dock panel on root_path" do
      visit root_path
      expect(page).to have_css(".dock")
  end

  it "shows the dock panel on new_place_path" do
    visit new_place_path
    expect(page).to have_css(".dock")
  end

  it "has the add new place link" do
    visit root_path
    within ".dock" do
      expect(page).to have_link(href: new_place_path)
    end
  end

  it "has link to home page" do
    visit root_path
    within ".dock" do
      expect(page).to have_link(href: root_path)
      end
  end

  it "navigates to new place page when clicking the link" do
    visit root_path
    within ".dock" do
      find("a[href='#{new_place_path}'").click
    end

    expect(page).to have_current_path(new_place_path)
  end
end
