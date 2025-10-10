class RenameMaxUploadToMaxUploadsInPlaceUploadToken < ActiveRecord::Migration[8.0]
  def change
    rename_column :place_upload_tokens, :max_upload, :max_uploads
  end
end
