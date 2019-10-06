module Ahnnotate
  class Tables
    include Enumerable

    def initialize(connection = ActiveRecord::Base.connection)
      @connection = connection
      @abilities = Abilities.new(connection)
    end

    def to_h
      map { |table| [table.name, table] }.to_h
    end

    def each
      if !block_given?
        enum_for(:each)
      end

      @connection.public_send(data_sources_method_name).each do |table_name|
        primary_key = ActiveRecord::Base.get_primary_key(table_name)

        columns = @connection.columns(table_name).map do |c|
          is_primary_key =
            if primary_key.is_a?(Array)
              primary_key.include?(c.name)
            else
              primary_key == c.name
            end

          Column.new(
            name: c.name,
            sql_type: c.sql_type,
            nullable: c.null,
            primary_key: is_primary_key,
            default: c.default
          )
        end

        indexes = @connection.indexes(table_name).map do |i|
          comment =
            if i.respond_to?(:comment)
              i.comment
            end

          Index.new(
            name: i.name,
            columns: i.columns,
            unique: i.unique,
            comment: comment
          )
        end

        foreign_keys =
          if @abilities.foreign_key?
            @connection.foreign_keys(table_name).map do |fk|
              ForeignKey.new(
                name: fk.name,
                from_column: fk.column,
                to_table: fk.to_table,
                to_column: fk.primary_key
              )
            end
          else
            []
          end

        yield Table.new(
          name: table_name,
          columns: columns,
          indexes: indexes,
          foreign_keys: foreign_keys,
        )
      end
    end

    def data_sources_method_name
      @data_sources_method_name ||=
        if ActiveRecordVersion.five_and_up?
          :data_sources
        else
          :tables
        end
    end
  end
end
