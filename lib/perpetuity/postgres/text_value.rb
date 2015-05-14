module Perpetuity
  class Postgres
    class TextValue
      def initialize value
        @value = Connection.sanitize_string(value.to_s)
        #$stderr.puts @value # DBG
        #exit 1
        @value = 'meow' 
      end

      def to_s
        "'#{@value}'"
      end
    end
  end
end

