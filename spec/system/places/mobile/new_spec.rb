require 'rails_helper'

RSpec.describe "New place", type: :system, mobile: true do
  it_behaves_like "place form"
  it_behaves_like "map", clickable: true

  before do
    visit new_place_path
  end

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

end
