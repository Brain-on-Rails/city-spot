require "rails_helper"

RSpec.describe "Uploads", type: :request do
  describe "POST /uploads" do
    let(:token) { PlaceUploadToken.create!(expires_at: 1.hour.from_now) }
    let(:file) { fixture_file_upload("spec/fixtures/images/test.png", "image/png") }

    it "requires a file" do
      post uploads_path(token: token.token)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    describe "token" do
      it "rejects upload without a token" do
        post uploads_path, params: { file: file }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("invalid token")
      end

      it "response has error message when expired token" do
        tkn = PlaceUploadToken.new(expires_at: 1.hour.ago)
        tkn.save(validate: false)
        post uploads_path, params: { file: file, token: tkn.token }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("token is expired")
      end
      it "response has error message when max uploads reached" do
        token.max_uploads.times { token.increase_uploads_counter }
        post uploads_path, params: { file: file, token: token.token }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("max uploads reached")
      end

    end

    describe "reject non-image files" do
      ["text/plain", "application/pdf", "application/zip"].each do |type|
        it "rejects #{type}" do
          post uploads_path, params: { file: fixture_file_upload("spec/fixtures/test.txt", type), token: token.token }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    it "allow uploads many files" do
      with_temp_images(count: 5, size_in_mb: 0.1) do |paths, _, content_type|
        paths.each do |path|
          post uploads_path, params: { file: fixture_file_upload(path, content_type), token: token.token }
          expect(response).to have_http_status(:created)
        end
      end
    end

    it "rejects files over 5MB" do
      with_temp_image(size_in_mb: 6) do |path, name, content_type|
        img = fixture_file_upload(path, content_type)
        post uploads_path, params: { file: img, token: token.token }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it "returns :created status for a valid file" do
      post uploads_path, params: { file: file, token: token.token }
      expect(response).to have_http_status(:created)
    end

    it "returns signed_id for a valid file" do
      post uploads_path, params: { file: file, token: token.token }
      json = JSON.parse(response.body)
      expect(json["signed_id"]).to be_present
    end

    it "returns file url for a valid file" do
      post uploads_path, params: { file: file, token: token.token }
      json = JSON.parse(response.body)
      expect(json["url"]).to be_present
    end

    it "returns filename for a valid file" do
      post uploads_path, params: { file: file, token: token.token }
      json = JSON.parse(response.body)
      expect(json["filename"]).to be_present
    end

    it "returns content_type for a valid file" do
      post uploads_path, params: { file: file, token: token.token }
      json = JSON.parse(response.body)
      expect(json["content_type"]).to be_present
    end

    it "returns byte_size for a valid file" do
      post uploads_path, params: { file: file, token: token.token }
      json = JSON.parse(response.body)
      expect(json["byte_size"]).to be_present
    end
  end
end
