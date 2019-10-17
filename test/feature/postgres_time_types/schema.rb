create_table :widgets, id: :integer do |t|
  t.column :type_time, "time without time zone"
  t.column :type_timetz, "time with time zone"
end

change_column_null :widgets, :id, false
