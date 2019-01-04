require "test_helper"

FeatureTest.define(feature_name: File.basename(__dir__)) do
  def current_dir
    Pathname.new(__dir__)
  end
end
