require 'rails_helper'

RSpec.describe "New place", type: :system, mobile: true do
  it_behaves_like "place form"

  before do
    visit new_place_path
  end


  it "show the map" do
    expect(page).to have_css(".leaflet-pane")
  end

end
