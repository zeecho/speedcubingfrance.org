class AddDiscussionSubscriptionToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discussion_subscription, :boolean
  end
end
