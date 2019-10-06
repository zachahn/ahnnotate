create_table :widgets, id: :integer do |t|
  t.text :name
end

change_column_null :widgets, :id, false
