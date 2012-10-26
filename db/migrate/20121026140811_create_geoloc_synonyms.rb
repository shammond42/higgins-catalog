class CreateGeolocSynonyms < ActiveRecord::Migration
  def change
    create_table :geoloc_synonyms do |t|
      t.string :location, null: false
      t.string :synonym, null: false
    end
  end
end
