create_table :widgets, id: :integer do |t|
  t.column :created_at, "timestamp with time zone", null: false
  t.column :updated_at, "timestamp with time zone", null: false
end

change_column_null :widgets, :id, false
