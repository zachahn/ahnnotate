create_table :users, id: :integer do |t|
  t.text :preferred_name
end

change_column_null :users, :id, false
