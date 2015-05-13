module Perpetuity
  class Postgres
    class JSONStringValue
      def initialize value
        val = value.to_s.gsub('"') { '\\"' }
        @value = Connection.escape_string(val)
      end

      def to_s
        %Q{"#{@value}"}
      end

      def to_str
        to_s
      end
    end
  end
end
