module Ahnnotate
  class Abilities
    def initialize(connection)
      @connection = connection
      @adapter_name = connection.adapter_name.downcase
    end

    def foreign_key?
      if @adapter_name == "sqlite"
        return false
      end

      if !@connection.respond_to?(:foreign_keys)
        return false
      end

      true
    end
  end
end
