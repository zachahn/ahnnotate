module Ahnnotate
  module Facet
    module Models
      class Standin
        # Lol. It's a little easier in this case to deal with instances here.
        # I'll need to create many instances to recreate the class structure of
        # the models in order to most correctly compute the table name from the
        # model name 🥳
        include ActiveRecord::ModelSchema::ClassMethods

        # boolean, is this an abstract class
        attr_writer :abstract_class
        # the class that the current class inherits from
        attr_accessor :superclass
        attr_accessor :base_class
        # the outer class
        attr_accessor :parent

        def initialize(abstract_class:, superclass:, base_class:, parent:, is_active_record_base: false)
          @abstract_class = abstract_class
          @superclass = superclass
          @base_class = base_class
          @parent = parent
          @is_active_record_base = is_active_record_base
        end

        def abstract_class?
          !!@abstract_class
        end

        def ==(other)
          if @is_active_record_base && other == ActiveRecord::Base
            return true
          end

          super
        end
      end
    end
  end
end
