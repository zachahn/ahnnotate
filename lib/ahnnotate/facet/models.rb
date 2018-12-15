module Ahnnotate
  module Facet
    module Models
      def self.add(config, tables, infiles, outfiles)
        runner = Main.new(config, tables, infiles, outfiles)
        runner.call
      end
    end
  end
end
