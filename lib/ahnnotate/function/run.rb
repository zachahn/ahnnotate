module Ahnnotate
  module Function
    class Run
      def initialize(config, infiles, outfiles)
        @config = config
        @infiles = infiles
        @outfiles = outfiles
      end

      def call
        Facet::Models.add(@config, tables_hash, @infiles, @outfiles)
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
