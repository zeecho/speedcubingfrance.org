class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.string :name
      t.boolean :visible
      t.boolean :over
      t.boolean :multiple_choices

      t.timestamps
    end

    create_table :vote_options do |t|
      t.string :name
      t.belongs_to :vote
    end

    create_table :vote_answers do |t|
      t.belongs_to :user
      t.belongs_to :vote_option
    end
  end
end
