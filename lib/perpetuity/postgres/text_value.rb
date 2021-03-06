module Perpetuity
  class Postgres
    class TextValue
      def initialize value
        @value = Connection.sanitize_string(value.to_s)
      end

      def to_s
        "'#{@value}'"
      end
    end
  end
end

