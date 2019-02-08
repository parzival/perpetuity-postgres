require 'perpetuity/postgres/text_value'
require 'perpetuity/postgres/timestamp_value'
require 'perpetuity/postgres/date_value'
require 'perpetuity/postgres/numeric_value'
require 'perpetuity/postgres/null_value'
require 'perpetuity/postgres/boolean_value'
require 'perpetuity/postgres/json_hash'
require 'perpetuity/postgres/json_array'

module Perpetuity
  class Postgres
    class SQLValue
      attr_reader :value

      def initialize value
        @value = case value
                 when String, Symbol
                   TextValue.new(value)
                 when Time
                   TimestampValue.new(value)
                 when Date
                   DateValue.new(value)
                 when Integer, Float
                   NumericValue.new(value)
                 when Hash, JSONHash
                   JSONHash.new(value.to_hash, :inner)
                 when Array, JSONArray
                   JSONArray.new(value.to_a)
                 when nil
                   NullValue.new
                 when true, false
                   BooleanValue.new(value)
                 end.to_s
      end

      def to_s
        value
      end

      def == other
        if other.is_a? String
          value == other
        else
          value == other.value
        end
      end
    end
  end
end
