require 'rails_helper'

RSpec.describe "New place", type: :system, mobile: true do
  before do
    visit new_place_path
  end

  it_behaves_like "place form"
  it_behaves_like "map", clickable: true


  it "updates lat and lng when clicking on the map" do
    lat_before = find_field("place[latitude]").value
    lng_before = find_field("place[longitude]").value
    expect(lat_before).to eq("")
    expect(lng_before).to eq("")
    find('.leaflet-container').click(x: 50, y: 50)
    lat_after = find_field("place[latitude]").value
    lng_after = find_field("place[longitude]").value
    expect(lat_after).not_to eq("")
    expect(lng_after).not_to eq("")
  end

  it "shows no marker on the map if no coordinates are set" do
    expect(page).not_to have_css(".leaflet-marker-icon")
  end

  it "shows marker on the map if coordinates are set" do
    fill_in "place[latitude]", with: "-11.22"
    fill_in "place[longitude]", with: "33.33"
    expect(page).to have_css(".leaflet-marker-icon")
  end

  it "updates map when changing the coordinates" do

    find('.leaflet-container').click(x: 50, y: 50)

    marker = find(".leaflet-pane.leaflet-map-pane")

    before = marker[:style]

    fill_in "place[latitude]", with: "-11.22"
    fill_in "place[longitude]", with: "33.33"

    sleep 1.2

    marker = find(".leaflet-pane.leaflet-map-pane")

    after = marker[:style]

    expect(before).not_to eq(after)
  end

end
