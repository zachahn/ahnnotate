create_table :employees, id: :integer do |t|
  t.text :name
  t.text :type
end

change_column_null :employees, :id, false
