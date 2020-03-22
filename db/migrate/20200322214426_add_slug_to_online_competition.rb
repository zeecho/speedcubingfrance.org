class AddSlugToOnlineCompetition < ActiveRecord::Migration[5.1]
  def change
    add_column :online_competitions, :slug, :string
  end
end
