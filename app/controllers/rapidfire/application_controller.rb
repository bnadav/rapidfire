module Rapidfire
  class ApplicationController < ::ApplicationController
    helper_method :can_administer?

    alias_method :app_current_user, Rapidfire.current_user_getter

    def current_user
      app_current_user
    end

    def can_administer?
      Rapidfire.can_administer.call(current_user)
    end

    def authenticate_administrator!
      unless can_administer?
        raise Rapidfire::AccessDenied.new("cannot administer questions")
      end
    end
  end
end
