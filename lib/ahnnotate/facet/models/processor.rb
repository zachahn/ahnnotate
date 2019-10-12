module Ahnnotate
  module Facet
    module Models
      class Processor < Parser::AST::Processor
        def call(content)
          sexp = Parser::CurrentRuby.parse(content)

          @current_class = ModuleNode.new(nil)
          @classes = [@current_class]

          process(sexp)

          @classes.reject { |klass| klass.class_name == "" }
        end

        def on_class(node)
          @current_class = module_node_create(node, parent: @current_class)
          @classes.push(@current_class)

          super

          @current_class = @current_class.parent
        end

        alias on_module on_class

        def on_send(node)
          receiver, method_name, assigned_node = *node

          if receiver == s(:self) && method_name == :table_name=
            table_name = assigned_node.children.last
            @current_class.table_name = table_name
          end

          if receiver == s(:self) && method_name == :abstract_class=
            abstract_class =
              if assigned_node.type == :true
                true
              else
                false
              end
            @current_class.abstract_class = abstract_class
          end
        end

        # ignore instance method definitions since method definition bodies
        # can't contain class declarations
        def on_def(_)
        end

        # ignore class method definitions since method definition bodies can't
        # contain class declarations
        def on_defs(_)
        end

        private

        def module_node_create(node, parent:)
          class_node, superclass_node, _body_node = *node

          if node.type == :module
            superclass_node = nil
          end

          class_name = resolve_class_name(class_node)
          superclass_name = resolve_class_name(superclass_node)

          classlike = ModuleNode.new(class_name.to_s)
          classlike.claimed_superclass = superclass_name.to_s
          classlike.module_parent = parent

          classlike
        end

        def resolve_class_name(node)
          outer, name = *node

          if outer.nil?
            name
          else
            "#{resolve_class_name(outer)}::#{name}"
          end
        end

        def s(type, *children)
          AST::Node.new(type, children)
        end
      end
    end
  end
end
