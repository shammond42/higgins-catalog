class AddImageArtifactImages < ActiveRecord::Migration
  def change
    rename_column :artifact_images, :path, :image
  end
end
