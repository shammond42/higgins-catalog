class RenameCategorySrefs < ActiveRecord::Migration
  def up
    rename_table :category_xrefs, :category_synonyms
    rename_column :category_synonyms, :xref, :synonym
  end

  def down
    rename_column :category_synonyms, :synonym, :xref
    rename_table :category_synonyms, :category_xrefs
  end
end
