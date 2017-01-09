require 'spec_helper'

describe "Surveys" do
  let(:survey)  { FactoryGirl.create(:survey, name: "Question Set", introduction: "Some introduction") }
  let(:question1)  { FactoryGirl.create(:q_long,  survey: survey, question_text: "Long Question", validation_rules: { presence: "1" })  }
  let(:question2)  { FactoryGirl.create(:q_short, survey: survey, question_text: "Short Question") }

  describe "Blocked by main app" do
    let(:block_survey) { Rapidfire.before_attempt = lambda{ |current_user| false }}
    before { block_survey }

    it "shows empty page with unathorized status code" do
      visit rapidfire.new_survey_attempt_path(survey)
      expect(page.status_code).to eq(403)
    end

  end

  context "Authorized by main app" do
    let(:custom_after_path)  { Rapidfire.after_attempt_path = "/rapidfire" }
    let(:default_after_path) { Rapidfire.after_attempt_path = nil }

    before do |example|
      [question1, question2]

      if example.metadata[:custom_path]
        custom_after_path
      else
        default_after_path
      end
      visit rapidfire.new_survey_attempt_path(survey)
    end

    it "displays survey introduction" do
      expect(page).to have_content "Some introduction"
    end

    describe "Answering Questions" do
      context "when all questions are answered" do
        before do
          fill_in "attempt_#{question1.id}_answer_text", with: "Long Answer"
          fill_in "attempt_#{question2.id}_answer_text", with: "Short Answer"
          click_button "Save"
        end

        it "persists 2 answers" do
          expect(Rapidfire::Answer.count).to eq(2)
        end

        it "persists 2 answers with answer values" do
          expected_answers = ["Long Answer", "Short Answer"]
          expect(Rapidfire::Answer.all.map(&:answer_text)).to match(expected_answers)
        end

        it "redirects to question groups path", custom_path: false do
          expect(current_path).to eq(rapidfire.surveys_path)
        end

        it "redirects to custom path when configured", custom_path: true  do
          #expect(current_path).to eq("/rapidfire")
          expect(current_path).to eq(custom_after_path)
        end
      end

      context "when all questions are not answered" do
        before do
          fill_in "attempt_#{question1.id}_answer_text", with: ""
          fill_in "attempt_#{question2.id}_answer_text", with: "Short Answer"
          click_button "Save"
        end

        it "fails to persits answers" do
          expect(Rapidfire::Answer.count).to eq(0)
        end

        it "shows error for missing answers" do
          expect(page).to have_content "can't be blank"
        end

        it "shows already populated answers" do
          short_answer = page.find("#attempt_#{question2.id}_answer_text").value
          expect(short_answer).to have_content "Short Answer"
        end
      end
    end
  end
end
