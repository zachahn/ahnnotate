# The all caps stuff is gsubbed in the file named `feature.rb`
def test_PLACEHOLDER_DB_ADAPTER_works
  ActiveRecord::Base.logger = nil
  ActiveRecord::Migration.verbose = false

  integrator = FeatureTester.new(adapter: "PLACEHOLDER_DB_ADAPTER", current_dir: current_dir, target: target_class)

  if integrator.test_case.empty?
    skip "No yaml test file for PLACEHOLDER_DB_ADAPTER"
  end

  begin
    connection_pool = ActiveRecord::Base.establish_connection("PLACEHOLDER_DB_URL")

    ActiveRecord::Schema.define do
      instance_eval(integrator.schema, __FILE__, __LINE__)
    end

    integrator.call(config_with_fallback)

    vfs_as_hash = integrator.vfs.each.to_h

    integrator.expected_outfiles.each do |path, expected|
      actual = vfs_as_hash.delete(path)
      assert_equal(expected, actual)
    end

    vfs_as_hash.each do |path, actual|
      expected = integrator.expected_outfiles[path]
      assert_equal(expected, actual)
    end
  ensure
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table, force: :cascade, if_exists: true)
    end

    ActiveRecord::Base.remove_connection
  end
end
