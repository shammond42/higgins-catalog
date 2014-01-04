class AddWidthHeightToArtifactImages < ActiveRecord::Migration
  def change
    add_column :artifact_images, :width, :integer
    add_column :artifact_images, :height, :integer
  end
end
