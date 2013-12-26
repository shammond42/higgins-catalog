include ActionDispatch::TestProcess

FactoryGirl.define do
  # User definitions
  factory :artifact do
    sequence(:accession_number) {|n| n.to_s }
    std_term  'sword'
    alt_name 'blade'

    factory :quality_artifact do
      description 'It is made of metal.'
      comments 'This is a great artifact.'

      after(:create) do |artifact|
        FactoryGirl.create_list(:artifact_image, 1, artifact: artifact)
      end
    end
  end
  
  factory :geoloc_synonym do
    geoloc 'Iberia'
    synonym 'Western Europe'
  end

  factory :category_synonym do
    category 'blade'
    synonym 'edged weapon'
  end

  factory :artifact_image do
    artifact
    image {fixture_file_upload( Rails.root + 'app/assets/images/avatar-body.png', 'image/png')}
  end

  factory :question do
    artifact
    nickname 'Old Tobey'
    email 'bbaggins@fellowship.org'
    question 'Is that made of metal?'

    factory :answered_question do
      answer 'Yes'
    end
  end

  factory :search_log do
    search_type 'keyword'
    terms 'sword'
  end

  factory :user do
    name 'Frodo Baggins'
    email 'fbaggins@bagend.com'
    title 'Ring Bearer'
    password 'letmein'
  end
end
