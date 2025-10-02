class AddPlace < ActiveRecord::Migration[8.0]
  def change
    create_table :places do |t|
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.st_point :geom, geographic: true, srid: 4326, null: false
      t.string :name, null: false
      t.string :description
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone
      t.string :website

      t.timestamps
    end

    add_index :places, :name, unique: true
  end
end
