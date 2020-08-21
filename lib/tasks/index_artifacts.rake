namespace :higgins do
  namespace :data do
    desc 'Index all artifacts in elastic search'
    task index_artifacts: :environment do
      count = 0
      Artifact.__elasticsearch__.delete_index!
      Artifact.find_in_batches(batch_size: 100) do |batch|
        batch.each do |artifact|
          artifact.index_document
          count += 1
          print '.'; STDOUT.flush
        end
        puts " #{count}"
      end
    end
  end
end