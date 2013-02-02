namespace :higgins do
  namespace :test_data do
    desc 'Create 10 test questions about the artifact of the day'
    task :test_questions => :environment do
      artifact = Artifact.of_the_day

      10.times do |i|
        artifact.questions.create(
          nickname: 'bbaggins',
          email: 'bilbo@baggins.net',
          question: "Test question #{i}"
        )
      end
    end
  end
end