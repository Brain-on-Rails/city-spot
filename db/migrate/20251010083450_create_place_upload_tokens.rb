class CreatePlaceUploadTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :place_upload_tokens do |t|
      t.string :token, null: false
      t.integer :uploads_count, null: false, default: 0
      t.datetime :expires_at, null: false

      t.timestamps
    end
    add_index :place_upload_tokens, :token, unique: true
  end
end
