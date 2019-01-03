require "test_helper"

class HandleUniqueIndexTest < TestCase
  include FeatureHelper

  private

  def config
  end

  def current_dir
    Pathname.new(__dir__)
  end
end
