class MakeSureAllArtifactsHaveName < ActiveRecord::Migration
  def up
    execute("update artifacts set std_term='Untitled' where std_term is null;")
    Artifact.find_by_std_term('Untitled').save!
  end

  def down
  end
end
