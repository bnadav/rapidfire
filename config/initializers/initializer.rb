Rapidfire.config do |config|
  # Url to redirect to after answering a survey.
  # Default: surveys_path (if left nil)
  #
  #config.after_attempt_path = nil
  #
  # Lambda hook that runs before survey attempt. If returns false survey won't be presented.
  # Parameter: current_user
  # Default: true
  #
  #config.before_attempt = lambda{ |current_user| true }
  #
  # Lambda hook that runs after each survey attempt.
  # Parameter: current_user
  #
  #config.after_attempt = lambda{ |current_user| }
  #
  # Labmda hook that determines if user can administer surveys
  # Paramter: current_user
  # Defalut: true
  #
  #config.can_administer = lambda{ |current_user| true }
  #
  # Name of method name that returns the current user or equivalent entity in the main app.
  # The method must be present in the main app's ApplicationController
  # Default: :current_user
  #
  #config.current_user_getter = :current_user
end
