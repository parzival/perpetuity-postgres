require 'perpetuity/postgres/json_string_value'
require 'perpetuity/postgres/sql_value'

module Perpetuity
  class Postgres
    class JSONArray
      def initialize value, position=:outer
        @value = value
        @position = position
      end

      def to_s
        if @position == :outer
          "'#{to_inner_array}'"
        else
          to_inner_array
        end
      end

      def to_inner_array
        "[#{serialize_elements}]"
      end

      def serialize_elements
        @value.map do |element|
          case element
          when String
            JSONStringValue.new(element)
          when Array
            JSONArray.new(element, :inner)
          else
            SQLValue.new(element)
          end  
        end.join(',')
      end

      def to_a
        @value
      end
    end
  end
end
