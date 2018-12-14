module Ahnnotate
  module Facet
    module Models
      class ResolveClassRelationships
        include ProcParty

        def call(extracted_classes)
          object_space =
            extracted_classes
              .map(&method(:self_and_outer_class))
              .flatten
              .compact
              .uniq
              .map { |x| [x.class_name, x] }
              .to_h

          object_space[""] ||= ModuleNode.new(nil)

          object_space["::ActiveRecord::Base"] =
            ModuleNode.new(
              "ActiveRecord::Base",
              parent: object_space[""],
              abstract_class: nil
            )
          object_space["::ActiveRecord::Base"].is_active_record_base = true

          object_space.each do |class_name, extracted_class|
            possible_namespace_levels = class_name.split("::")[1..-2] || []

            if extracted_class.claimed_superclass == "" || extracted_class.claimed_superclass == nil
              next
            end

            (possible_namespace_levels.size + 1).times do
              class_uri_parts =
                possible_namespace_levels + [extracted_class.claimed_superclass]

              class_uri = "::#{class_uri_parts.join("::")}"

              if object_space[class_uri]
                extracted_class.superclass = object_space[class_uri]
                break
              end

              possible_namespace_levels.pop
            end
          end

          object_space
        end

        private

        def self_and_outer_class(extracted_class)
          if extracted_class.nil?
            return nil
          end

          [
            extracted_class,
            self_and_outer_class(extracted_class.parent)
          ]
        end
      end
    end
  end
end
