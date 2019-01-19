module FeatureTest
  def self.define(feature_name:)
    feature_test_file, lineno, * = caller.first.split(":")

    klass = Class.new(TestCase)
    klass.class_exec(&Proc.new)
    klass.class_eval(
      File.read(File.join(__dir__, "feature_test_contents.rb")),
      feature_test_file,
      lineno.to_i
    )

    Object.const_set("feature_#{feature_name}".upcase, klass)
  end
end

class FeatureTester
  attr_reader :current_dir

  def initialize(adapter:, current_dir:)
    @current_dir = current_dir
    @adapter = adapter
  end

  def call(config)
    function = Ahnnotate::Function::Main.new(
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
      YAML.load_file(current_dir.join(test_case_file_basename))
  end

  def test_case_file_basename
    if @test_case_file_basename
      return @test_case_file_basename
    end

    version =
      "#{ActiveRecord::VERSION::MAJOR}_" \
      "#{ActiveRecord::VERSION::MINOR}_" \
      "#{@adapter}"

    @test_case_file_basename = version_to_version(version) + ".yml"
  end

  # Replaces `$` with `#` in file contents since `#` is a comment in YAML
  def convert_dollars_to_hashes(files)
    files
      .map { |path, contents| [path, contents.gsub(/^( *)\$/, "\\1#")] }
      .to_h
  end

  def version_to_version(version)
    @version_to_version_mapping ||= {}

    @version_to_version_mapping[version] || "5_2_#{@adapter}"
  end
end
