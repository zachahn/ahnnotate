create_table :posts do |t|
  t.text :content, null: false, default: "hi"
  t.boolean :pinned, null: false, default: false
  t.text :author_name, default: "Fish"

  t.timestamps
end
