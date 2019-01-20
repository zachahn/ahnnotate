module Ahnnotate
  module Function
    class Niam
      include Command

      def call
        @config["annotate"].each do |facet_name, config|
          if !config["enabled"]
            next
          end

          schema_stripper = StripSchema.new(comment: "#")

          vfs.each_in(config["path"], config["extension"]) do |path, content|
            content_with_stripped_schema = schema_stripper.call(content)

            if content_with_stripped_schema.size < content.size
              vfs[path] = content_with_stripped_schema
            end
          end
        end
      end
    end
  end
end
