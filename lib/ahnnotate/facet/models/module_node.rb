module Ahnnotate
  module Facet
    module Models
      # ModuleNode is named as such since `Class.is_a?(Module) == true`.
      class ModuleNode
        # By including ClassMethods this way, I'm including the methods as
        # instance methods. I'm doing this so that I can compute the table name
        # on per-class basis.
        #
        # It's a bit unfortunate that this class will be used to both (1) keep
        # track of how classes/modules relate to each other and (2) compute the
        # table name.
        include ActiveRecord::ModelSchema::ClassMethods

        # Named to fit the ModelSchema interface. This is basically `Class#name`
        attr_accessor :name
        # Named to fit the ModelSchema interface. This is the "outer class"
        attr_accessor :module_parent
        # Named to fit the ModelSchema interface. This is the class that the
        # current class inherits from. This is computed, whereas
        # `claimed_superclass` is what is parsed from the source
        attr_accessor :superclass
        # Named to fit the ModelSchema interface. This is currently unsupported
        attr_accessor :table_name_prefix

        attr_writer :claimed_superclass
        attr_writer :abstract_class
        attr_writer :is_a_kind_of_activerecord_base
        attr_accessor :explicit_table_name
        attr_accessor :is_active_record_base
        attr_accessor :path

        def initialize(name,
          module_parent: nil,
          is_a_kind_of_activerecord_base: false,
          claimed_superclass: nil,
          explicit_table_name: nil,
          abstract_class: nil)
          self.name = name
          self.module_parent = parent
          self.is_a_kind_of_activerecord_base = is_a_kind_of_activerecord_base
          self.claimed_superclass = claimed_superclass
          self.explicit_table_name = explicit_table_name
          self.abstract_class = abstract_class
        end

        # Named to fit the ModelSchema interface
        def pluralize_table_names
          true
        end

        def table_name_suffix
        end

        def is_a_kind_of_activerecord_base?
          !!@is_a_kind_of_activerecord_base
        end

        # Named to fit the ModelSchema interface
        def abstract_class?
          !!@abstract_class
        end

        def claimed_superclass
          @claimed_superclass.to_s
        end

        # Named to fit the ModelSchema interface. It was originally implemented
        # in ActiveRecord::Inheritance. I've re-implemented it here via the
        # documentation.
        def base_class
          if superclass.is_active_record_base
            return self
          end

          if superclass.abstract_class?
            return self
          end

          superclass.base_class
        end

        # Named to fit the ModelSchema interface. It was originally implemented
        # in ActiveRecord::Inheritance in Rails 6.0.
        def base_class?
          base_class == self
        end

        # Named to fit the ModelSchema interface. It was originally implemented
        # in ActiveSupport::Introspection
        def module_parents
          if module_parent
            [module_parent, *module_parent.module_parent]
          else
            []
          end
        end

        def class_name
          if @name
            "#{parent.class_name}::#{@name}"
          else
            ""
          end
        end

        def table_name
          if explicit_table_name
            return @explicit_table_name
          end

          super
        end

        def <(other)
          other == ActiveRecord::Base && is_a_kind_of_activerecord_base?
        end

        def ==(other)
          if is_active_record_base && other == ActiveRecord::Base
            return true
          end

          super
        end

        module ActiveRecord4Compatibility
          class RelationDelegateClass
            def initialize(*)
            end
          end

          def relation_delegate_class(*)
            RelationDelegateClass
          end

          def arel_table
          end
        end

        module ActiveRecord4And5Compatibility
          # Named to fit the ModelSchema interface. It was originally implemented
          # in ActiveSupport::CoreExt::Module::Introspection in Rails 6.0.
          def parent
            module_parent
          end

          # def parent=(parent_)
          #   self.module_parent = parent_
          # end

          # Named to fit the ModelSchema interface. It was originally implemented
          # in ActiveSupport::CoreExt::Module::Introspection in Rails 6.0.
          def parents
            module_parents
          end
        end

        include ActiveRecord4Compatibility
        include ActiveRecord4And5Compatibility
      end
    end
  end
end
