module Ahnnotate
  module Facet
    module Models
      def self.add(config, infiles, outfiles)
        runner = Run.new(config, infiles, outfiles)
        runner.call
      end
    end
  end
end
