require 'rails_helper'

RSpec.describe "Home page", type: :system do
  before do
    driven_by(:selenium_chrome_mobile)

    visit root_path
  end

  let!(:place1) { FactoryBot.create(:place) }
  let!(:place2) { FactoryBot.create(:place) }

  it "shows the map" do
    expect(page).to have_css("#svelte-map")
    expect(page).to have_css(".leaflet-pane")
    expect(page).to have_current_path("/")
  end

end
