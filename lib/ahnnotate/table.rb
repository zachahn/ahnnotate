module Ahnnotate
  class Table
    attr_accessor :name
    attr_accessor :columns
    attr_accessor :indexes

    def initialize(**args)
      args.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def string(comment:)
      output = StringIO.new
      output.puts "#{comment} == Schema Info"
      output.puts comment
      output.puts "#{comment} Table name: #{@name}"
      output.puts comment

      @columns.each do |column|
        column_name_length = column.name.size
        spacing_length = longest_column_name_length - column_name_length + 2
        output.puts "#{comment} #{column.name}#{" " * spacing_length}#{column.type}"
      end

      if indexes.any?
        tabularizer =
          Function::Tabularize.new(
            cell_divider: "  ",
            prefix: "#{comment}   "
          )

        output.puts comment
        output.puts "#{comment} Indexes:"
        output.puts comment
        output.print tabularizer.call(indexes, [:name, :presentable_columns, :presentable_unique, :comment])
      end

      output.puts comment

      output.string
    end

    private

    def longest_column_name_length
      @longest_column_name_length ||= @columns.map(&:name).map(&:size).max
    end
  end
end
