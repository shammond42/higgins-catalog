class RenameCategorySrefs < ActiveRecord::Migration
  def up
    rename_table :category_xrefs, :category_synonyms
  end

  def down
    rename_table :category_synonyms, :category_xrefs
  end
end
