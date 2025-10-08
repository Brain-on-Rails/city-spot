
RSpec.describe "Uploads", type: :request do
  describe "POST /uploads" do
    let(:file) { fixture_file_upload("spec/fixtures/images/test.png", "image/png") }

    it "requires a file" do
      post uploads_path
      expect(response).to have_http_status(:unprocessable_entity)
    end

    describe "reject non-image files" do
      ["text/plain", "application/pdf", "application/zip"].each do |type|
        it "rejects #{type}" do
          post uploads_path, params: { file: fixture_file_upload("spec/fixtures/test.txt", type) }
          expect(response).to have_http_status(:unprocessable_entity)
          end
      end
    end

    it "rejects files over 5MB" do
      with_temp_image(size_in_mb: 6) do |path, name, content_type|
        img = fixture_file_upload(path, content_type)
        post uploads_path, params: { file: img }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it "returns :created status for a valid file" do
      post uploads_path, params: { file: file }
      expect(response).to have_http_status(:created)
    end

    it "returns signed_id for a valid file" do
      post uploads_path, params: { file: file }
      json = JSON.parse(response.body)
      expect(json["signed_id"]).to be_present
    end

    it "returns file url for a valid file" do
      post uploads_path, params: { file: file }
      json = JSON.parse(response.body)
      expect(json["url"]).to be_present
    end

    it "returns filename for a valid file" do
      post uploads_path, params: { file: file }
      json = JSON.parse(response.body)
      expect(json["filename"]).to be_present
    end

    it "returns content_type for a valid file" do
      post uploads_path, params: { file: file }
      json = JSON.parse(response.body)
      expect(json["content_type"]).to be_present
    end

    it "returns byte_size for a valid file" do
      post uploads_path, params: { file: file }
      json = JSON.parse(response.body)
      expect(json["byte_size"]).to be_present
      end
  end
end
