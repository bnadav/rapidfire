# inspired by devise and forem
require 'rails/generators'

module Rapidfire
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../config/initializers/', __FILE__)
      desc "This generator creates an initializer file at config/initializers/rapidfire_init.rb"

      def copy_initializer_file
        copy_file "initializer.rb", "config/initializers/rapidfire_init.rb"
      end

    end
  end
end
