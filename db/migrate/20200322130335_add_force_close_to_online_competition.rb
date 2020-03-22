class AddForceCloseToOnlineCompetition < ActiveRecord::Migration[5.1]
  def change
    add_column :online_competitions, :force_close, :boolean, default: false
  end
end
