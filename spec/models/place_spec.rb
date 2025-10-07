RSpec.describe Place, type: :model do
  it { should have_many(:list_places) }
  it { should have_many(:lists).through(:list_places) }
  it { should belong_to(:creator).class_name("User") }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_length_of(:name).is_at_most(255) }
  it { should validate_length_of(:name).is_at_least(3) }
  it { should validate_length_of(:description).is_at_most(1000) }

  let(:user) { User.create!(name: "user", email: "user@example.org") }
  # let(:factory) { RGeo::Geographic.spherical_factory(srid: 4326) }

  subject(:place_new) { Place.new(name: "test place", creator: user, geom: FACTORY_GEOM.point(1.20, 39.23)) }
  subject(:place_created) { Place.create!(name: "test place", creator: user, latitude: 1.20, longitude: 39.23) }

  describe "images" do
    it { should have_many_attached(:images) }

    it "purges attached photos on destroy" do
      place_created.images.attach(io: File.open("spec/fixtures/images/test.png"), filename: "test.png")

      expect(place_created.images.attached?).to be_truthy
      expect { place_created.destroy }.to change { ActiveStorage::Attachment.count }.by(-1)
    end

    it "is valid with images under 5MB" do
      file = fixture_file_upload("spec/fixtures/images/test.png", "image/png")
      place_created.images.attach(file)
      expect(place_created).to be_valid
    end

    it "accepts only images with extensions: .png, .jpg, .jpeg" do
      file = fixture_file_upload("spec/fixtures/test.txt", "text/plain")
      place_created.images.attach(file)
      expect(place_created).to_not be_valid
      expect(place_created.errors[:images]).to_not be_empty
    end

    it "is invalid with images over 5MB" do
      large_file = Tempfile.new(["large_file", ".jpg"])
      large_file.write("a" * 6.megabytes)
      large_file.rewind
      file = fixture_file_upload(large_file, "image/jpg")
      place_created.images.attach(file)
      expect(place_created).to_not be_valid
      expect(place_created.errors[:images]).to_not be_empty
    end

    it "is invalid if more than 8 images are attached" do
      9.times do |i|
        file = fixture_file_upload("spec/fixtures/images/test.png", "image/png")
        place_created.images.attach(file)
      end

      expect(place_created).to_not be_valid
      expect(place_created.errors[:images]).to_not be_empty
    end
  end

  it "not set geom if lat or lng are nil" do
    place = Place.new(name: "place", creator: user, geom: nil)
    place.latitude = nil
    place.longitude = 23.32
    place.validate
    expect(place.geom).to be_nil

    place.latitude = 1.20
    place.longitude = nil
    place.validate
    expect(place.geom).to be_nil
  end

  it "updates the geom if lat an lng are set" do
    place = Place.new(name: "place", creator: user, geom: nil)
    place.latitude = 1.20
    place.longitude = 39.23
    place.validate

    expect(place.geom).to be_a(RGeo::Geographic::SphericalPointImpl)
    expect(place.geom.x).to eq(1.20)
    expect(place.geom.y).to eq(39.23)
  end

  describe "virtual attributes latitude/longitude" do
    it "sets and gets latitude" do
      place = Place.new
      place.latitude = 1.20
      expect(place.latitude).to eq(1.20)
    end
    it "sets and gets longitude" do
      place = Place.new
      place.longitude = 39.23
      expect(place.longitude).to eq(39.23)
    end

    it "is is invalid if latitude/longitude are not set" do
      place = Place.new
      place.latitude = nil
      place.longitude = nil
      expect(place).to_not be_valid
      expect(place.errors[:latitude]).to_not be_empty
      expect(place.errors[:longitude]).to_not be_empty
    end

    describe "latitude" do
      it "is invalid if not a number" do
        place = Place.new
        place.latitude = "not a number"
        expect(place).to_not be_valid
      end

      it "is invalid if not between -90 and 90" do
        place = Place.new
        place.latitude = 91
        expect(place).to_not be_valid
        place.latitude = -91
        expect(place).to_not be_valid
      end
    end

    describe "longitude" do
      it "is invalid if not a number" do
        place = Place.new
        place.longitude = "not a number"
        expect(place).to_not be_valid
      end
      it "is invalid if not between -180 and 180" do
        place = Place.new
        place.longitude = 181
        expect(place).to_not be_valid
        place.longitude = -181
        expect(place).to_not be_valid
      end
    end

  end
end
