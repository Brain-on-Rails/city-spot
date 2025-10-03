require 'rails_helper'

RSpec.describe "Home page", type: :system do
  before do
    driven_by(:selenium_chrome_mobile)
  end

  let!(:place1) { FactoryBot.create(:place) }
  let!(:place2) { FactoryBot.create(:place) }


  it "shows the map" do

    visit root_path

    expect(page).to have_css("#svelte-map")
    expect(page).to have_css(".leaflet-pane")
    expect(page).to have_current_path("/")
  end
end
