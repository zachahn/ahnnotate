create_table :posts, id: :integer do |t|
  t.text :content
end

change_column_null :posts, :id, false
