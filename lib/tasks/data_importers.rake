require 'csv'

namespace :higgins do
  namespace :data do
    CSV_FILE_PATH = 'db/higgins_data'
    IMAGE_PATH = 'public/object_photos'

    desc 'Import all higgins data.'
    task :import_all_data => :environment do
      puts 'Import category synonyms'
      Rake::Task['higgins:data:import_category_xrefs'].execute

      puts 'Import geo location data'
      Rake::Task['higgins:data:import_geoloc_synonyms'].execute

      puts 'Import catalog data'
      Rake::Task['higgins:data:import_artifacts'].execute

      puts 'Process Images'
      Rake::Task['higgins:data:process_images'].execute
    end

    desc 'Delete all processes photos'
    task :delete_processed_images  => :environment do
      ArtifactImage.delete_all
    end

    desc 'Process Higgins Provided Pictures'
    task :process_images => :environment do
      STDOUT.sync = true
      found = 0
      unfound = []

      Dir.entries(IMAGE_PATH).each do |filename|
        next unless filename =~ /[jJ][pP][gG]$/

        # clean up messy names
        accession_number = Artifact.process_accession_number(filename[0...-4])
        new_filename = Artifact.process_accession_number(filename).downcase

        # rename file
        File.rename("#{IMAGE_PATH}/#{filename}", "#{IMAGE_PATH}/#{new_filename}")

        # associate new file with database
        artifact = Artifact.find_by_accession_number(Artifact.process_accession_number(filename[0...-4]))
        if artifact.present?
          artifact.artifact_images.create(path: "/object_photos/#{new_filename}")
          print '.'
          found += 1
        else # no record for this image
          print 'F'
          unfound << new_filename
        end
      end
      puts ''
      puts "Found: #{found}"
      puts "Unfound: #{unfound.size}"
      unfound.each {|u| puts u}
    end

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
          accession_number: Artifact.process_accession_number(line[:accessionnumber]),
          std_term: line[:stdterm] || 'Untitled',
          alt_name: line[:altname],
          prob_date: line[:probdate],
          min_date: line[:mindate].present? ? line[:mindate].to_i : nil,
          max_date: line[:maxdate].present? ? line[:maxdate].to_i : nil,
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
        })
        if artifact.valid?
          artifact.save!
        else
          puts line[:accessionnumber]
        end
        print '.'
      end
      puts 'done'
    end

    desc 'Delete all category synonyms'
    task :delete_category_synonyms => :environment do
      CategorySynonym.delete_all
    end

    desc 'Import category cross references (synonmyms)'
    task :import_category_xrefs => :environment do
      STDOUT.sync = true
      CSV.foreach( "#{CSV_FILE_PATH}/category_xrefs.csv", :headers           => true,
                                        :header_converters => :symbol) do |line|
        artifact = CategorySynonym.new({
          category: line[:category],
          synonym: line[:category_xref],
          note: line[:note]
          }).save!
        print '.'
      end
      puts 'done'
    end

    desc 'Delete all geoloc synonyms'
    task :delete_geoloc_synonyms => :environment do
      GeolocSynonym.delete_all
    end

    desc 'Import geoloc synonyms'
    task :import_geoloc_synonyms => :environment do
      STDOUT.sync = true
      CSV.foreach( "#{CSV_FILE_PATH}/geoloc_xrefs.csv") do |line|
        loc_syn = GeolocSynonym.new({
          geoloc: line[1],
          synonym: line[2]
          }).save!
        print '.'
      end
      puts 'done'
    end
  end
end