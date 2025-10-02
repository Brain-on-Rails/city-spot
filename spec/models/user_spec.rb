
RSpec.describe User, type: :model do
  it { should have_many(:lists) }
  it { should have_many(:created_places).class_name("Place").with_foreign_key("creator_id")}
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  before(:each) do
    @user = User.create!(name: "user", email: "user@example.org")
  end

  it "can have many lists" do
    list1 = @user.lists.create!(name: "list1")
    list2 = @user.lists.create!(name: "list2")

    expect(@user.lists).to match_array([list1, list2])
  end

  it "is invalid without an email" do
    user = User.new(name: "User")
    expect(user).to_not be_valid
    expect(user.errors[:email]).to_not be_empty
  end

  it "is invalid with an empty email" do
    user = User.new(name: "User", email: "")
    expect(user).to_not be_valid
    expect(user.errors[:email]).to_not be_empty
  end

  it "is invalid with an incorrectly formatted email" do
    user = User.new(name: "User", email: "user@domain")
    expect(user).to_not be_valid
    expect(user.errors[:email]).to_not be_empty
  end
end