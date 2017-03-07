class AddRapidfireAnswerIndex < ActiveRecord::Migration
  def change
    add_column :rapidfire_answers, :answer_index, :integer
  end
end
