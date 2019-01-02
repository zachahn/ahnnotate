module Ahnnotate
  class Options
    def self.attribute_names
      @attribute_names ||= []
    end

    def self.attr_writer(*names)
      attribute_names.push(*names)
      super
    end

    def self.attr_question(*names)
      names.each do |name|
        attr_writer(name)

        define_method("#{name}?") do
          !!instance_variable_get("@#{name}")
        end
      end
    end

    attr_question :exit
    attr_question :fix

    def initialize(**args)
      args.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def to_s
      output = StringIO.new

      output.puts "🧐  options:"
      self.class.attribute_names.each do |attribute_name|
        output.print "🧐    #{attribute_name}: "

        if instance_variable_defined?("@#{attribute_name}")
          output.puts "undefined"
        else
          output.puts instance_variable_get("@#{attribute_name}").inspect
        end
      end

      output.string
    end
  end
end
