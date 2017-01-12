class AddRapidfireQuestionsGrid < ActiveRecord::Migration[5.0]
  def change
    add_column :rapidfire_questions, :grid_view, :boolean, default: false
  end
end
