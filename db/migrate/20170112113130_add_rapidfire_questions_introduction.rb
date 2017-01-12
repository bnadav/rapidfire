class AddRapidfireQuestionsIntroduction < ActiveRecord::Migration
  def change
    add_column :rapidfire_questions, :introduction, :string
  end
end
