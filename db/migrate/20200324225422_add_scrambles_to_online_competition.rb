class AddScramblesToOnlineCompetition < ActiveRecord::Migration[5.2]
  def change
    add_column :online_competitions, :scrambles, :text
  end
end
