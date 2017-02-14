module Rapidfire
  module Questions
    class Range < Select

      def options
        if option_array.empty?
          []
        else
          option_array_from_range
        end
      end

      private

      def option_array_from_range
        endpoints = [RangeEndPoint.new(option_array.first),
                     RangeEndPoint.new(option_array.last) ]
        array = ::Range.new(endpoints.first.value, endpoints.last.value).to_a
        array_with_suffixes(array, endpoints)
      end

      def option_array
        @arr ||= answer_options.split(Rapidfire.answers_delimiter)
      end

      # insert suffix to first and last elements of the array,
      # if such suffixes exist in the endpoints elements
      def array_with_suffixes(array, endpoints)
        if s = endpoints.first.suffix
          array[0] = "#{array.first} #{s}"
        end
        if s = endpoints.last.suffix
          array[-1] = "#{array.last} #{s}"
        end
        array
      end

      class RangeEndPoint

        attr_reader :suffix, :value

        def initialize(str)
            @raw = str
            @suffix= @raw[/.*<([^>]*)/,1]
            @value = @raw.gsub("<#{@suffix}>", "")
        end

      end

    end
  end
end
