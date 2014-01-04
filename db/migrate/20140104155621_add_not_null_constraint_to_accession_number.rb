class AddNotNullConstraintToAccessionNumber < ActiveRecord::Migration
  def up
    change_column :artifacts, :accession_number, :string, null: false
  end

  def down
    change_column :artifacts, :accession_number, :string, null: true
  end
end
