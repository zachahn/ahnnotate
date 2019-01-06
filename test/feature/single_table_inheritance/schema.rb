create_table :employees do |t|
  t.text :name
  t.text :type, null: :false

  t.timestamps
end
