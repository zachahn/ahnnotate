require "test_helper"

class DirectlyInheritedTest < TestCase
  include FeatureHelper

  private

  def config
    {
      "autorun" => {
        "enabled" => true,
      },
      "annotate" => {
        "models" => {
          "enabled" => true
        }
      }
    }
  end

  def current_dir
    Pathname.new(__dir__)
  end
end
