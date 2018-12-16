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
        matches = pattern.match(content)

        if matches
          matches["post"]
        else
          content
        end
      end

      def pattern
        @pattern ||=
          begin
            newline = /\r?\n\r?/

            /\A#{comment}\s==\sSchema\sInfo#{newline}?(?:^#{comment}[^\n]*$#{newline})*#{newline}(?<post>.*)/m
          end
      end
    end
  end
end
