module Rapidfire
  module Questions
    class Range < Select

      def options
        if option_array.empty?
          []
        else
          option_range.to_a
        end
      end

      def option_array
        answer_options.split(Rapidfire.answers_delimiter)
      end

      def option_range
        ::Range.new(self.option_array.first, self.option_array.last)
      end

    end
  end
end
