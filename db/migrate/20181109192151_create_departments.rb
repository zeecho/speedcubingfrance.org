class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments do |t|
      t.string :code
      t.string :name
      t.references :region, null: false

      t.timestamps
    end
  end
end
