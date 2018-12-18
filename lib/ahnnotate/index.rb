module Ahnnotate
  class Index
    attr_accessor :name
    attr_accessor :columns
    attr_accessor :comment
    attr_accessor :unique

    def initialize(**args)
      args.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def presentable_columns
      "(#{columns.join(", ")})"
    end

    def presentable_unique
      if unique
        "UNIQUE"
      else
        ""
      end
    end
  end
end
