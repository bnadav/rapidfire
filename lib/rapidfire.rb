require "rapidfire/engine"

module Rapidfire
  class AccessDenied < StandardError
  end

  # configuration which will be used as delimiter in case answers are bunch
  # of collection values. This is the default delimiter which is used by
  # all the browsers.
  mattr_accessor :answers_delimiter
  self.answers_delimiter = "\r\n"

  # Path to redirect to after succesful attempt creation
  mattr_accessor :after_attempt_path

  mattr_accessor :current_user_getter, 
    :can_administer, 
    :before_attempt,
    :after_attempt

  self.current_user_getter = :current_user
  self.can_administer = lambda { |current_user| true }
  self.before_attempt = lambda { |current_user| true }
  self.after_attempt = lambda { |current_user| }

  def self.config
    yield(self)
  end
end
