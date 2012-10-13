class CreateArtifacts < ActiveRecord::Migration
  def change
    create_table :artifacts do |t|
      t.string :accession_number
      t.string :std_term
      t.string :alt_name
      t.date :prob_date
      t.date :min_date
      t.date :max_date
      t.string :artist
      t.string :school_period
      t.string :geoloc
      t.string :origin
      t.string :materials
      t.string :measure
      t.string :weight
      t.text :comments
      t.text :bibliography
      t.text :published_refs
      t.text :label_text
      t.text :old_labels
      t.text :exhibit_history
      t.text :desctiption
      t.text :marks
      t.text :public_loc
      t.text :status
      
      t.timestamps
    end
  end
end
