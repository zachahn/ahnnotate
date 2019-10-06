create_table :authors, id: :integer

create_table :posts, id: :integer do |t|
  t.integer :author_id
end

if !(ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR == 1)
  add_foreign_key :posts, :authors
end

change_column_null :posts, :id, false
