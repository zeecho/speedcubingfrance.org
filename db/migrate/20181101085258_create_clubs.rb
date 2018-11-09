class CreateClubs < ActiveRecord::Migration[5.1]
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :website
      t.string :email
      t.text :description
      t.string :logo
      t.references :department, null: false
      t.string :city

      t.timestamps
    end
  end
end
