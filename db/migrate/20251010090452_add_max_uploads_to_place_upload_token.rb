class AddMaxUploadsToPlaceUploadToken < ActiveRecord::Migration[8.0]
  def change
    add_column :place_upload_tokens, :max_upload, :integer, null: false, default: 10
  end
end
