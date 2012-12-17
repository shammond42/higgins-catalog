class CreateSearchLogs < ActiveRecord::Migration
  def change
    create_table :search_logs do |t|
      t.string :terms
      t.string :search_type
      t.integer :linked_search

      t.timestamps
    end
  end
end
