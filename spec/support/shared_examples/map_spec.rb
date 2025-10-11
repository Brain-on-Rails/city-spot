RSpec.shared_examples 'map' do |options|
  clickable = options.fetch(:clickable, true)

  it "shows the map" do
    expect(page).to have_css(".leaflet-pane")
  end

  if clickable
    it "shows marker on click" do
      expect(page).not_to have_css(".leaflet-marker-icon")
      find('.map').click
      expect(page).to have_css(".leaflet-marker-icon")
    end
  end
end