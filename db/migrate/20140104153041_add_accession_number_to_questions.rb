class AddAccessionNumberToQuestions < ActiveRecord::Migration
  def up
    add_column :questions, :accession_number, :string

    execute("
      update questions
      set accession_number = artifacts.accession_number
      from artifacts
      where artifacts.id = questions.artifact_id;
    ")
  end

  def down
    remove_column :questions, :accession_number
  end
end
