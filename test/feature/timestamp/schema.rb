create_table :widgets, id: :integer do |t|
  t.timestamps null: false
end

change_column_null :widgets, :id, false
