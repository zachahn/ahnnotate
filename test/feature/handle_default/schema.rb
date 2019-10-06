create_table :posts, id: :integer do |t|
  t.text :content, null: false, default: "hi"
  t.boolean :pinned, null: false, default: false
  t.text :author_name, default: "Author"
end

change_column_null :posts, :id, false
