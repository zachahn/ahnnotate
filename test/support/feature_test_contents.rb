def test_it_works
  ActiveRecord::Base.logger = nil
  ActiveRecord::Migration.verbose = false

  integration_databases.each do |adapter, connection_string|
    integrator = FeatureTester.new(adapter: adapter, current_dir: current_dir)

    begin
      connection = ActiveRecord::Base.establish_connection(connection_string)

      ActiveRecord::Schema.define do
        instance_eval(integrator.schema, __FILE__, __LINE__)
      end

      integrator.call(konfig)

      vfs_as_hash = integrator.vfs.each.to_a.to_h

      integrator.expected_outfiles.each do |path, expected|
        actual = vfs_as_hash.delete(path)
        assert_equal(expected, actual)
      end

      vfs_as_hash.each do |path, actual|
        expected = integrator.expected_outfiles[path]
        assert_equal(expected, actual)
      end
    ensure
      ActiveRecord::Base.remove_connection
    end
  end
end

private

def konfig
  if respond_to?(:config)
    config
  else
    nil
  end
end

def integration_databases
  {
    sqlite3: "sqlite3::memory:",
  }
end
