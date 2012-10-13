class CreateCategoryXrefs < ActiveRecord::Migration
  def change
    create_table :category_xrefs do |t|
      t.string :category, null: false
      t.string :xref, null: false
      t.text :note
    end

    add_index :category_xrefs, :category
    add_index :category_xrefs, :xref
  end
end
