module Ahnnotate
  class Column
    attr_reader :name
    attr_reader :type

    def initialize(name:, type:, nullable:, primary_key:)
      @name = name
      @type = type
      @nullable = nullable
      @primary_key = primary_key
    end

    def details
      if @details
        return @details
      end

      details = []

      if !nullable?
        details.push("not null")
      end

      if primary_key?
        details.push("primary key")
      end

      @details = details.join(", ")
    end

    def nullable?
      !!@nullable
    end

    def primary_key?
      !!@primary_key
    end
  end
end
