create_table :authors do |t|
  t.text :name
end

create_table :posts do |t|
  t.text :content
  t.integer :author_id
end

add_foreign_key :posts, :authors
