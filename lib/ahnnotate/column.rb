module Ahnnotate
  class Column
    attr_reader :name
    attr_reader :type

    def initialize(name:, type:, nullable:, primary_key:, default:)
      @name = name
      @type = type
      @nullable = nullable
      @primary_key = primary_key
      @default = default
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
