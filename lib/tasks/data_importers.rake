require 'csv'

namespace :higgins do
  namespace :data do
    CSV_FILE_PATH = 'db/higgins_data'

    desc 'Delete all artifacts from the database'
    task :delete_artifacts => :environment do
      Artifact.delete_all
    end

    desc 'Import catalogue csv file into artifacts table'
    task :import_artifacts => :environment do
      STDOUT.sync = true
      CSV.foreach( "#{CSV_FILE_PATH}/catalogue.csv", :headers           => true,
                                        :header_converters => :symbol) do |line|
        artifact = Artifact.new({
          accession_number: line[:accessionnumber],
          std_term: line[:stdterm],
          alt_name: line[:altname],
          prob_date: line[:probdate],
          min_date: line[:mindate].to_i,
          max_date: line[:maxdate].to_i,
          artist: line[:artist],
          school_period: line[:schooper],
          geoloc: line[:geoloc],
          origin: line[:origin],
          materials: line[:materials],
          measure: line[:measure],
          weight: line[:weight],
          comments: line[:comments],
          bibliography: line[:bibliography],
          published_refs: line[:publishedrefs],
          label_text: line[:labeltext],
          old_labels: line[:oldlabels],
          exhibit_history: line[:exhibhist],
          description: line[:descript],
          marks: line[:marks],
          public_loc: line[:publicloc],
          status: line[:status]
        }).save!
        print '.'
      end
      puts 'done'
    end

    desc 'Delete all category synonyms'
    task :delete_category_synonyms => :environment do
      CategoryXref.delete_all
    end

    desc 'Import category cross references (synonmyms)'
    task :import_category_xrefs => :environment do
      STDOUT.sync = true
      CSV.foreach( "#{CSV_FILE_PATH}/category_xrefs.csv", :headers           => true,
                                        :header_converters => :symbol) do |line|
        artifact = CategoryXref.new({
          category: line[:category],
          xref: line[:category_xref],
          note: line[:note]
          }).save!
        print '.'
      end
      puts 'done'
    end
  end
end