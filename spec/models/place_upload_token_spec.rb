RSpec.describe PlaceUploadToken, type: :model do

  subject(:tkn) { PlaceUploadToken.create!(expires_at: 1.hour.from_now) }

  describe "has_secure_token" do
    it "generates a value on create" do
      expect(tkn.token).to be_present
    end

    it "generates a unique value" do
      tkn2 = PlaceUploadToken.create!(expires_at: 11.hour.from_now)
      expect(tkn.token).to_not eq(tkn2.token)
    end

    it "generates a value of 32 characters" do
      expect(tkn.token.length).to eq(32)
    end

    it "uploads_count defaults to 0" do
      expect(tkn.uploads_count).to eq(0)
    end

    it "has a max_uploads set" do
      expect(tkn.max_uploads).to be_present
    end

    it "allows setting max_uploads on create" do
      tkn = PlaceUploadToken.create!(expires_at: 1.hour.from_now,max_uploads: 1040)
      expect(tkn.max_uploads).to eq(1040)
    end

    it "cannot modify max_uploads" do
      max = tkn.max_uploads
      expect{
        tkn.max_uploads = 100 + max
      }.to raise_error(ActiveRecord::ReadOnlyRecord)
      expect{
        tkn.update(max_uploads: 100 + max)
      }.to raise_error(ActiveRecord::ReadOnlyRecord)
      expect(tkn.max_uploads).to eq(max)

      tkn.reload
      expect(tkn.max_uploads).to eq(max)
    end
  end

  describe "#can_upload?" do
    it "returns true if uploads_count < max_uploads" do
      expect(tkn.uploads_count).to eq(0)
      expect(tkn.valid?).to be true
    end

    it "returns false if uploads_count >= MAX_UPLOADS" do
      tkn.max_uploads.times { tkn.increase_uploads_counter! }
      tkn.reload
      expect(tkn.valid?).to be false
    end

    it "increments uploads_count" do
      tkn.increase_uploads_counter!
      tkn.reload
      expect(tkn.uploads_count).to eq(1)
    end
    it "token expires after 1 hour" do
      tkn = PlaceUploadToken.create(expires_at: 1.hour.ago)
      expect(tkn).not_to be_valid
    end
  end

  describe "error messages" do
    it "returns error message when expired token" do
      tkn = PlaceUploadToken.create(expires_at: 1.hour.ago)
      expect(tkn.valid?).to be false
      expect(tkn.errors.full_messages).to include("token is expired")
    end

    it "returns error message when max uploads reached" do
      tkn.max_uploads.times { tkn.increase_uploads_counter! }
      tkn.reload
      expect(tkn.valid?).to be false
      expect(tkn.errors.full_messages).to include("max uploads reached")
      end
  end

end