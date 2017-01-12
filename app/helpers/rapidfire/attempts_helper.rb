module Rapidfire

  module AttemptsHelper
    def grid_class(question)
      question.grid_view? ? "grid" : ""
    end
  end

  class AttemptFormBuilder < ActionView::Helpers::FormBuilder
    def span(method, options={})
      val = @object.send(method)
      unless(val.blank?)
        @template.content_tag(:span, val, 
                              options.merge({id: (@object_name.gsub(/[\[\]]/, "_") << method.to_s),
                                             class: method.to_s}))
      end
    end
  end

end
