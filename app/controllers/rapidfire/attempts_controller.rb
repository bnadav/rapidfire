module Rapidfire
  class AttemptsController < Rapidfire::ApplicationController
    before_filter :find_survey!

    def new
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def create
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        redirect_to after_attempt_path
        #redirect_to surveys_path
      else
        render :new
      end
    end

    private
    def find_survey!
      @survey = Survey.find(params[:survey_id])
    end

    def after_attempt_path
      Rapidfire.after_attempt_path || surveys_path
    end

    def attempt_params
      answer_params = { params: (params[:attempt] || {}) }
      answer_params.merge(user: current_user, survey: @survey)
    end
  end
end
