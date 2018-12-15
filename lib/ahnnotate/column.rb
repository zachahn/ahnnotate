module Ahnnotate
  class Column
    attr_reader :name
    attr_reader :type

    def initialize(name:, type:)
      @name = name
      @type = type
    end
  end
end
