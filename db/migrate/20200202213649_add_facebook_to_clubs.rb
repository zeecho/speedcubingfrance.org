class AddFacebookToClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :clubs, :facebook, :string
  end
end
