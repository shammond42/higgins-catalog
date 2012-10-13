class AddCatalogIndexes < ActiveRecord::Migration
  def up
    add_index :artifacts, :accession_number
    add_index :artifacts, :min_date
    add_index :artifacts, :max_date
  end

  def down
    remove_index :artifacts, :accession_number, :unique => true
    remove_index :artifacts, :min_date
    remove_index :artifacts, :max_date
  end
end
