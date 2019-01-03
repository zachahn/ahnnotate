require "test_helper"

class IgnoresNonActiverecordTest < TestCase
  include FeatureHelper

  private

  def config
  end

  def current_dir
    Pathname.new(__dir__)
  end
end
