RSpec.describe List, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:list_places) }
  it { should have_many(:places).through(:list_places) }
  it { should validate_presence_of(:name) }

  before(:each) do
    @user = User.create!(email: "user@example.org", name: "User")
  end

  it "belongs to a user" do
    list = @user.lists.create!(name: "list1")
    expect(list.user).to eq(@user)
  end

  it "can have many places" do
    list = @user.lists.create!(name: "list1")
    place1 = list.places.create!(name: "place1", creator: @user, geom: FACTORY_GEOM.point(1.20, 55.23))
    place2 = list.places.create!(name: "place2", creator: @user, geom: FACTORY_GEOM.point(1.21, -80.24))

    expect(list.places).to match_array([place1, place2])
  end

  it "without a name is invalid" do
    list = @user.lists.new(name: "")
    expect(list).to_not be_valid
    expect(list.errors[:name]).to_not be_empty
  end

end