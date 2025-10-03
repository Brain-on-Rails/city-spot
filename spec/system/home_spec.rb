require 'rails_helper'

RSpec.describe "Home page", type: :system do
  before do
    driven_by(:selenium_chrome)
  end

  let!(:place1) { FactoryBot.create(:place) }
  let!(:place2) { FactoryBot.create(:place) }


  it "shows the map with all places" do

    visit root_path

    expect(page).to have_css("#map")
    expect(page).to have_css(".leaflet-marker-icon")
    expect(page).to have_current_path("/places")
  end
end
