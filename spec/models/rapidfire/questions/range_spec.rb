 require 'spec_helper'

 describe Rapidfire::Questions::Range do
  it_behaves_like "a select question", :q_range

  describe "range with suffixes" do
    context "when suffixes for range endpoints are given" do
      let(:question)  { FactoryGirl.create(:q_range_with_suffixes) }

      it "creates range and then add suffixes to first and last options" do
        expect(question.options).to match_array(["a suffix1", "b", "c suffix2"])
      end
    end
  end
 end
