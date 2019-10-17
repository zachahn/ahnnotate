module Ahnnotate
  class Column
    attr_reader :name

    def self.sql_type_map
      @sql_type_map ||=
        begin
          map = Hash.new { |_self, k| k }
          map["character varying"] = "varchar"
          map["character"] = "char"
          map["datetime"] = "timestamp"
          map["double precision"] = "double"
          map["time with time zone"] = "timetz"
          map["time without time zone"] = "time"
          map["timestamp with time zone"] = "timestamptz"
          map["timestamp without time zone"] = "timestamp"
          map
        end
    end

    def initialize(name:, sql_type:, nullable:, primary_key:, default:)
      @name = name
      @sql_type = sql_type.to_s.downcase.gsub(/\(.*?\)/, "")
      @nullable = nullable
      @primary_key = primary_key
      @default = default
    end

    def type
      self.class.sql_type_map[@sql_type]
    end

    def details
      if @details
        return @details
      end

      details = []

      if !nullable?
        details.push("not null")
      end

      if has_default?
        details.push("default (#{default.inspect})")
      end

      if primary_key?
        details.push("primary key")
      end

      @details = details.join(", ")
    end

    def default
      if @default.nil?
        return nil
      end

      if type == "boolean"
        default_is_false =
          if ActiveRecordVersion.five_and_up?
            ActiveModel::Type::Boolean::FALSE_VALUES.include?(@default)
          else
            ActiveRecord::ConnectionAdapters::Column::FALSE_VALUES.include?(@default)
          end

        return !default_is_false
      end

      @default
    end

    def has_default?
      !default.nil?
    end

    def nullable?
      !!@nullable
    end

    def primary_key?
      !!@primary_key
    end
  end
end
