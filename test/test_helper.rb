$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "pry"
require "ahnnotate"
require "minitest/autorun"
require "support/feature"
require "thread"
require "tmpdir"
require "fileutils"

class TestCase < Minitest::Test
end
