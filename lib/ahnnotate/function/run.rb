module Ahnnotate
  module Function
    class Run
      def initialize(config, infiles, outfiles)
        @config = config
        @infiles = infiles
        @outfiles = outfiles
      end

      def call
        Facet::Models.add(@config, @infiles, @outfiles)
      end
    end
  end
end
