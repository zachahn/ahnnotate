module FeatureHelper
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

        integrator.call(config)

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

  def integration_databases
    {
      sqlite3: "sqlite3::memory:",
    }
  end
end

class FeatureTester
  attr_reader :current_dir

  def initialize(adapter:, current_dir:)
    @current_dir = current_dir
    @adapter = adapter
  end

  def call(config)
    runner = Ahnnotate::Function::Run.new(config, vfs)
    runner.call
  end

  def vfs
    @vfs ||= Ahnnotate::Vfs.new(Ahnnotate::VfsDriver::Hash.new(convert_dollars_to_hashes(test_case["before"])))
  end

  def schema
    @schema ||= File.read(current_dir.join("schema.rb"))
  end

  def expected_outfiles
    @expected_outfiles ||= convert_dollars_to_hashes(test_case["after"])
  end

  def test_case
    @test_case ||=
      YAML.load_file(current_dir.join(test_case_file_basename))
  end

  def test_case_file_basename
    @test_case_file_basename ||=
      "#{ActiveRecord::VERSION::MAJOR}_" \
      "#{ActiveRecord::VERSION::MINOR}_" \
      "#{@adapter}" \
      ".yml"
  end

  # Replaces `$` with `#` in file contents since `#` is a comment in YAML
  def convert_dollars_to_hashes(files)
    files
      .map { |path, contents| [path, contents.gsub(/^( *)\$/, "\\1#")] }
      .to_h
  end
end
