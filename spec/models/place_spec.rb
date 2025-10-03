RSpec.describe Place, type: :model do
  it { should have_many(:list_places) }
  it { should have_many(:lists).through(:list_places) }
  it { should belong_to(:creator).class_name("User")}
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_presence_of(:geom) }

  let(:user) { User.create!(name: "user", email: "user@example.org")}
  let(:factory) { RGeo::Geographic.spherical_factory(srid: 4326) }

  subject { Place.new(name: "test place", creator: user, geom: FACTORY_GEOM.point(1.20, 39.23)) }

  it "allows setting a location point" do
    point = factory.point(1.20, 39.23)
    place = Place.create!(name: "place", creator: user, geom: point)

    expect(place.geom).to be_a(RGeo::Geographic::SphericalPointImpl)
    expect(place.geom.x).to eq(1.20)
    expect(place.geom.y).to eq(39.23)
  end
end