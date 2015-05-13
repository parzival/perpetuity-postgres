module Perpetuity
  class Postgres
    class TextValue
      def initialize value
        #val = value.to_s.gsub("'") { "''" }
        @value = Connection.escape_string(value.to_s)
      end

      def to_s
        "'#{@value}'"
      end
    end
  end
end

