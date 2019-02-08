require "bigdecimal"

module Perpetuity
  class Postgres
    class Table
      class Attribute
        attr_reader :name, :type, :max_length

        NoDefaultValue = Module.new
        UUID = Module.new

        SQL_TYPE_MAP = {
          String => 'TEXT',
          Integer => 'BIGINT',
          BigDecimal => 'NUMERIC',
          Float => 'FLOAT',
          UUID => 'UUID',
          Time => 'TIMESTAMPTZ',
          Date => 'DATE',
          TrueClass => 'BOOLEAN',
          FalseClass => 'BOOLEAN'
        }.tap{|m| m.default = 'JSON' }

        def initialize name, type, options={}
          @name = name
          @type = type
          @max_length = options[:max_length]
          @primary_key = if @name.to_s == 'id'
                           true
                         else
                           options.fetch(:primary_key) { false }
                         end
          @default = options.fetch(:default) { NoDefaultValue }
        end

        def sql_type
          SQL_TYPE_MAP[type]
        end

        def sql_declaration
          if self.default.is_a? String
            default = "'#{self.default}'"
          else
            default = self.default
          end

          sql = "#{name} #{sql_type}"
          sql << ' PRIMARY KEY' if primary_key?
          sql << " DEFAULT #{default}" unless self.default == NoDefaultValue

          sql
        end

        def primary_key?
          !!@primary_key
        end

        def default
          @default
        end
      end
    end
  end
end
