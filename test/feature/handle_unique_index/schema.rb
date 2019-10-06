create_table :posts, id: :integer do |t|
  t.text :title
  t.integer :slug
end

add_index :posts, :title, unique: true
add_index :posts, :slug, unique: true

change_column_null :posts, :id, false
