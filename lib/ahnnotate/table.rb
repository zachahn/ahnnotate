module Ahnnotate
  class Table
    attr_accessor :name
    attr_accessor :columns
    attr_accessor :indexes
    attr_accessor :foreign_keys

    def initialize(**args)
      args.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def string(comment:)
      tabularizer =
        Function::Tabularize.new(
          prefix: "#{comment}   ",
          cell_divider: "    "
        )

      output = StringIO.new
      output.puts "#{comment} == Schema Information"
      output.puts comment
      output.puts "#{comment} Table name: #{@name}"
      output.puts comment
      output.print tabularizer.call(columns, [:name, :type, :details])
      output.puts comment

      if indexes.any?
        output.puts "#{comment} Indexes:"
        output.puts comment
        output.print tabularizer.call(indexes, [:name, :presentable_columns, :presentable_unique, :comment])
        output.puts comment
      end

      if foreign_keys.any?
        output.puts "#{comment} Foreign keys:"
        output.puts comment
        output.puts tabularizer.call(foreign_keys, [:from, :to, :name])
        output.puts comment
      end

      output.string
    end

    private

    def longest_column_name_length
      @longest_column_name_length ||= @columns.map(&:name).map(&:size).max
    end
  end
end
