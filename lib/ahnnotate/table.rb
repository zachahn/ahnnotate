module Ahnnotate
  class Table
    attr_accessor :name
    attr_accessor :columns

    def initialize(name:, columns:)
      @name = name
      @columns = columns
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

      output.puts comment

      output.string
    end

    private

    def longest_column_name_length
      @longest_column_name_length ||= @columns.map(&:name).map(&:size).max
    end
  end
end
