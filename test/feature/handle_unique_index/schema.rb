create_table :posts do |t|
  t.text :title
  t.text :content
  t.integer :likes_count
  t.boolean :pinned

  t.timestamps null: false
end

add_index :posts, :title, unique: true
