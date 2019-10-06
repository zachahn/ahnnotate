create_table :authors do |t|
  t.text :name
end

create_table :posts do |t|
  t.text :content
  t.integer :author_id
end

if !(ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR == 1)
  add_foreign_key :posts, :authors
end
