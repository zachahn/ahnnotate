module Ahnnotate
  module Function
    class Main
      include Command

      def call
        if @config["boot"]
          eval @config["boot"]
        end

        Facet::Models.add(@config, tables_hash, vfs)
      end

      private

      def tables_hash
        @tables_hash = tables.to_h
      end

      def tables
        @tables ||= Tables.new
      end
    end
  end
end
