FactoryGirl.define do
  # User definitions
  factory :artifact do
    sequence(:accession_number) {|n| n.to_s }
    std_term  'sword'
    alt_name 'blade'

    factory :quality_artifact do
      description 'It is made of metal.'
      comments 'This is a great artifact.'

      after_create do |artifact|
        FactoryGirl.create_list(:artifact_image, 1, artifact: artifact)
      end
    end
  end
  
  factory :category_synonym do
    category 'blade'
    synonym 'edged weapon'
  end

  factory :artifact_image do
    artifact
    path '/test/path/image.jpg'
  end
end
