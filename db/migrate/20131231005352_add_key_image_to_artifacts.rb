class AddKeyImageToArtifacts < ActiveRecord::Migration
  def change
    add_column :artifacts, :key_image_id, :integer
  end
end
