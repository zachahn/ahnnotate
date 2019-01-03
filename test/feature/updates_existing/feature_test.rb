require "test_helper"

class UpdatesExistingTest < TestCase
  include FeatureHelper

  private

  def config
  end

  def current_dir
    Pathname.new(__dir__)
  end
end
