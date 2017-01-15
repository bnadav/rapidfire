module Rapidfire

  module AttemptsHelper
    def grid_classes(question)
      classes = ""
      classes << "grid " if question.grid_view?
      classes << "kernel " if question.grid_kernel?
      classes
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
