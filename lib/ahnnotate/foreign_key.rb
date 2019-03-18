module Ahnnotate
  class ForeignKey
    attr_accessor :name
    attr_accessor :from_column
    attr_accessor :to_table
    attr_accessor :to_column

    def initialize(**args)
      args.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def from
      from_column
    end

    def to
      "#{to_table}##{to_column}"
    end
  end
end
