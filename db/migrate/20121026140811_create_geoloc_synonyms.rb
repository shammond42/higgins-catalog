class CreateGeolocSynonyms < ActiveRecord::Migration
  def change
    create_table :geoloc_synonyms do |t|
      t.string :geoloc, null: false
      t.string :synonym, null: false
    end

    add_index :geoloc_synonyms, :geoloc
  end
end
