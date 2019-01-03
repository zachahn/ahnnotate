require "test_helper"

class InheritsApplicationRecordTest < TestCase
  include FeatureHelper

  private

  def config
  end

  def current_dir
    Pathname.new(__dir__)
  end
end
