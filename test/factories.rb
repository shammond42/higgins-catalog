FactoryGirl.define do
  # User definitions
  factory :artifact do
    sequence(:accession_number) {|n| n.to_s }
    std_term  'sword'
    alt_name 'blade'
  end
  
  factory :category_synonym do
    category 'blade'
    synonym 'edged weapon'
  end
end
