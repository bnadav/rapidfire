module Rapidfire
  class AttemptsController < Rapidfire::ApplicationController
    before_filter :find_survey!, :can_take_survey?

    def new
      @attempt_builder = AttemptBuilder.new(attempt_params)
    end

    def create
      @attempt_builder = AttemptBuilder.new(attempt_params)

      if @attempt_builder.save
        Rapidfire.after_attempt.call(current_user)
        redirect_to after_attempt_path
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

    def can_take_survey?
      head 403 unless Rapidfire.before_attempt.call(current_user) 
    end

    def attempt_params
      answer_params = { params: (params[:attempt] || {}) }
      answer_params.merge(user: current_user, survey: @survey)
    end

  end
end
