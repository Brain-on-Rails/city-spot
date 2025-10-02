class AddList < ActiveRecord::Migration[8.0]
  def change
    create_table :lists do |t|
      t.string :name, null: false
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
