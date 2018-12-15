module Ahnnotate
  class Tables
    include Enumerable

    def initialize(connection = ActiveRecord::Base.connection)
      @connection = connection
    end

    def to_h
      map { |table| [table.name, table] }.to_h
    end

    def each
      if !block_given?
        enum_for(:each)
      end

      @connection.tables.each do |table_name|
        columns = @connection.columns(table_name).map do |c|
          Column.new(
            name: c.name,
            type: c.type.to_s
          )
        end

        yield Table.new(name: table_name, columns: columns)
      end
    end
  end
end
