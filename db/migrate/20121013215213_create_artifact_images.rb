class CreateArtifactImages < ActiveRecord::Migration
  def change
    create_table :artifact_images do |t|
      t.integer :artifact_id, null: false
      t.string :path, null: false
      t.integer :sort_order

      t.timestamps
    end

    add_index :artifact_images, :artifact_id
  end
end
