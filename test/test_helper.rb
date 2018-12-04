$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "pry"
require "ahnnotate"
require "minitest/autorun"
require "support/feature"

class TestCase < Minitest::Test
end
