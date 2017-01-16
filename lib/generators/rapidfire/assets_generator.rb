# inspired by devise and forem
require 'rails/generators'

module Rapidfire
  module Generators
    class AssetsGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/assets/', __FILE__)
      desc "This generator creates the default scss and js assets files"

      def copy_scss_file
        copy_file "stylesheets/rapidfire.scss", "app/assets/stylesheets/rapidfire.scss"
      end

      def copy_js_file
        copy_file "javascripts/rapidfire.js", "app/assets/javascripts/rapidfire.js"
      end

    end
  end
end
