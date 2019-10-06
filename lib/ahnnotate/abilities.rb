module Ahnnotate
  class Abilities
    def initialize(connection)
      @connection = connection
      @adapter_name = connection.adapter_name.downcase
    end

    def foreign_key?
      @adapter_name != "sqlite"
    end
  end
end
