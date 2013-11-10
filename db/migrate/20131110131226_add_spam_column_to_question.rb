class AddSpamColumnToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :is_spam, :boolean, default: false

    execute 'update questions set is_spam = false where is_spam is null'
  end
end
