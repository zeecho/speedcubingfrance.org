class CreateRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :regions do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
