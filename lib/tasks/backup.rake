require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :backup do
  desc "Tasks to execute after the backup has been done (such as sending the db dump file by email to the admins)"
  task :send_backup_to_admins => :environment do
    puts "Sending email"
    NotificationMailer.with(task_name: "send_backup_to_team", message: "Base de données sauvegardée").send_backup_to_team.deliver_now
  end
end
