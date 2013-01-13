class AddReceivesQuestionNotificationsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :receives_question_notifications, :boolean

    execute "update users set receives_question_notifications = true;"
  end

  def down
    remove_column :users, :receives_question_notifications
  end
end
