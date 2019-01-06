module Ahnnotate
  module Facet
    module Models
      class Main
        def initialize(config, tables, vfs)
          @config = config
          @tables = tables
          @vfs = vfs
        end

        def call
          formatter = Function::Format.new(comment: "#")

          model_nodes.each do |model_node|
            table = @tables[model_node.table_name]

            if table.nil?
              next
            end

            @vfs[model_node.path] =
              formatter.call(table, @vfs[model_node.path])
          end
        end

        def model_nodes
          @model_nodes ||=
            begin
              model_path = @config["annotate", "models", "path"]
              model_files = @vfs.each_in(model_path)
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
                .select(&:is_a_kind_of_activerecord_base?)
                .reject(&:abstract_class?)
            end
        end
      end
    end
  end
end
