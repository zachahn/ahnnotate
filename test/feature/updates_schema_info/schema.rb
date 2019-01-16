create_table :posts do |t|
  t.text :content
  t.integer :likes_count
  t.boolean :pinned

  t.timestamps null: false
end
