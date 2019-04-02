class AddNewsletterSubscriptionToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :newsletter_subscription, :boolean
  end
end
