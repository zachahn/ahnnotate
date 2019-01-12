module Ahnnotate
  module Refinement
    module Dig
      if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.3.0")
        refine Hash do
          def dig(head, *tail)
            value = self[head]

            if tail.empty? || value.nil?
              return value
            end

            if value.respond_to?(:dig) || value.is_a?(Hash) || value.is_a?(Array)
              value.dig(*tail)
            else
              raise TypeError, "#{value.class} does not have #dig method"
            end
          end
        end

        refine Array do
          def dig(head, *tail)
            value = self.at(head)

            if tail.empty? || value.nil?
              return value
            end

            if value.respond_to?(:dig) || value.is_a?(Hash) || value.is_a?(Array)
              value.dig(*tail)
            else
              raise TypeError, "#{value.class} does not have #dig method"
            end
          end
        end
      end
    end
  end
end
