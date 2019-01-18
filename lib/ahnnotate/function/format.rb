module Ahnnotate
  module Function
    class Format
      attr_reader :comment

      def initialize(comment:)
        @comment = comment
      end

      def call(table, content)
        table.string(comment: comment) + "\n" + strip_schema(content)
      end

      private

      def strip_schema(content)
        @schema_stripper ||= StripSchema.new(comment: comment)

        @schema_stripper.call(content)
      end
    end
  end
end
