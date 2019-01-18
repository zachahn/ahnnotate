module Ahnnotate
  module Function
    class StripSchema
      attr_reader :comment

      def initialize(comment:)
        @comment = comment
      end

      def call(content)
        matches = pattern.match(content)

        if matches
          matches["post"]
        else
          content
        end
      end

      private

      def pattern
        @pattern ||=
          begin
            newline = /\r?\n\r?/

            /\A#{comment}\s==\sSchema\sInfo(?:rmation)?#{newline}?(?:^#{comment}[^\n]*$#{newline})*#{newline}(?<post>.*)/m
          end
      end
    end
  end
end
