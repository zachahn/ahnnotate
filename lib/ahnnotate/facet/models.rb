module Ahnnotate
  module Facet
    module Models
      def self.add(config, tables, vfs)
        runner = Main.new(config, tables, vfs)
        runner.call
      end
    end
  end
end
