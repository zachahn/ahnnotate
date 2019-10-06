module FeatureTest
  def self.define(feature_name:, target: Ahnnotate::Function::Main)
    klass = Class.new(TestCase)
    klass.class_exec(&Proc.new)
    integration_databases.each do |adapter, database_url|
      test_method_contents =
        feature_test_method_template
          .gsub(/PLACEHOLDER_DB_ADAPTER/, adapter)
          .gsub(/PLACEHOLDER_DB_URL/, database_url)

      klass.class_eval(test_method_contents, feature_test_method_template_path)
    end

    klass.class_eval(feature_test_helpers_contents, feature_test_helpers_contents)

    klass.class_eval do
      define_method :target_class do
        target
      end
    end

    Object.const_set("feature_#{feature_name}".upcase, klass)
  end

  def self.integration_databases
    @integration_databases ||= {
      "sqlite3" => "sqlite3::memory:",
      "postgres" => ENV["AHNNOTATE_POSTGRES_DATABASE_URL"],
    }
  end

  def self.feature_test_helpers_contents
    @feature_test_helpers_contents ||= File.read(feature_test_helpers_contents_path)
  end

  def self.feature_test_method_template
    @feature_test_method_template ||= File.read(feature_test_method_template_path)
  end

  def self.feature_test_helpers_contents_path
    File.join(__dir__, "feature_test_helpers.rb")
  end

  def self.feature_test_method_template_path
    File.join(__dir__, "feature_test_method.rb")
  end
end

class FeatureTester
  attr_reader :current_dir

  def initialize(adapter:, current_dir:, target:)
    @current_dir = current_dir
    @adapter = adapter
    @target = target
  end

  def call(config)
    function = @target.new(
      %(this "path" is used for `vfs_driver` which isn't used in tests),
      Ahnnotate::Options.new,
      Ahnnotate::Config.new(config)
    )
    function.vfs = vfs
    function.call
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
      if test_case_file_path
        YAML.load_file(test_case_file_path)
      else
        {}
      end
  end

  private

  # Replaces `$` with `#` in file contents since `#` is a comment in YAML
  def convert_dollars_to_hashes(files)
    files
      .map { |path, contents| [path, contents.gsub(/^( *)\$/, "\\1#")] }
      .to_h
  end

  def test_case_file_path
    if instance_variable_defined?(:@test_case_file_path)
      return @test_case_file_path
    end

    basenames = [
      "#{ActiveRecord::VERSION::MAJOR}_#{ActiveRecord::VERSION::MINOR}_#{@adapter}.yml",
      "#{ActiveRecord::VERSION::MAJOR}_#{@adapter}.yml",
      "#{ActiveRecord::VERSION::MAJOR}_#{ActiveRecord::VERSION::MINOR}_fallback.yml",
      "#{ActiveRecord::VERSION::MAJOR}_fallback.yml",
      "all_#{@adapter}.yml",
      "all_fallback.yml",
    ]

    @test_case_file_path =
      basenames.map { |bn| current_dir.join(bn) }.find(&:exist?)
  end
end
