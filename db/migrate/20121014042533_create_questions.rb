class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :email
      t.string :nickname
      t.text :question
      t.text :answer
      t.integer :artifact_id

      t.timestamps
    end

    add_index :questions, :artifact_id
  end
end
