module Ahnnotate
  module Function
    class Tabularize
      def initialize(cell_divider:, prefix:)
        @cell_divider = cell_divider
        @prefix = prefix
      end

      def call(data, column_names)
        output = StringIO.new
        minimum_column_lengths = Hash.new { 0 }

        rows = data.map do |row|
          row_hash = {}

          column_names.each do |c|
            value = row.public_send(c).to_s

            row_hash[c] = value

            if value.size > minimum_column_lengths[c]
              minimum_column_lengths[c] = value.size
            end
          end

          row_hash
        end

        rows.each do |row|
          # Note: minimum_column_lengths shouldn't include any of the columns
          # with a length of zero since they were never explicitly set (to 0)
          minimum_column_lengths.each.with_index do |(column_name, column_max_length), index|
            if index == 0
              output.print(@prefix)
            end

            if_rightmost_column = index + 1 == minimum_column_lengths.size

            if if_rightmost_column
              output.puts "#{row[column_name]}"
            else
              column_length = row[column_name].size
              spaces_length = column_max_length - column_length
              output.print "#{row[column_name]}#{" " * spaces_length}#{@cell_divider}"
            end
          end
        end

        output.string.gsub(/ +$/, "")
      end
    end
  end
end
