module Ahnnotate
  module Function
    class Run
      def initialize(config, vfs)
        @config = config
        @vfs = vfs
      end

      def call
        Facet::Models.add(@config, tables_hash, @vfs)
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
