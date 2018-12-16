module Ahnnotate
  module Facet
    module Models
      class Main
        def initialize(config, tables, infiles, outfiles)
          @config = config
          @tables = tables
          @infiles = infiles
          @outfiles = outfiles
        end

        def call
          formatter = Function::Format.new(comment: "#")

          model_nodes.each do |model_node|
            table = @tables[model_node.table_name]
            @outfiles[model_node.path] =
              formatter.call(table, @infiles[model_node.path])
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
