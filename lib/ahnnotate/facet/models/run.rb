module Ahnnotate
  module Facet
    module Models
      class Run
        def initialize(config, infiles, outfiles)
          @config = config
          @infiles = infiles
          @outfiles = outfiles
        end

        def call
          model_nodes.each do |model_node|
            puts model_node.table_name
          end
        end

        def model_nodes
          @model_nodes ||=
            begin
              model_path = @config.dig("annotate", "models", "path") || "app/models"
              model_files = @infiles.select { |file| file.starts_with?(model_path) }
              processor = Processor.new
              models = model_files.map do |path, contents|
                module_nodes = processor.call(contents)
                module_nodes.each { |node| node.path = path }
                module_nodes
              end

              models
                .flatten
                .yield_self(&ResolveClassRelationships.new)
                .yield_self(&ResolveActiveRecordModels.new)
            end
        end
      end
    end
  end
end
