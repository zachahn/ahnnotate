require "ahnnotate"

# This RSpec matcher only works for Rails. Here's a quick usage example:
#
#   require "rails_helper"
#   require "ahnnotate/rspec"
#
#   RSpec.describe Ahnnotate do
#     it { is_expected.to be_up_to_date }
#   end
class AhnnotateUpToDateMatcher
  attr_reader :actual
  attr_reader :expected

  def diffable?
    true
  end

  def matches?(_)
    options = Ahnnotate::Options.new(fix: false)
    config = Ahnnotate::Config.load(root: Rails.root)
    main = Ahnnotate::Function::Main.new(Rails.root, options, config)

    main.call

    writes = main.vfs.instance_variable_get(:@driver).changes

    format = proc do |vfs_hash|
      vfs_hash
        .map { |path, contents| "~~~ #{path} ~~~\n#{contents}" }
        .join("\n")
    end

    expected = writes.map { |path, _content| [path, File.read(path)] }.to_h
    @expected = format.call(expected)
    @actual = format.call(writes)

    @actual == @expected
  end

  def description
    "be up to date (you may need to run `rails db:test:prepare`)"
  end

  def failure_message
    "expected Ahnnotate to be up to date"
  end

  def failure_message_when_negated
    "expected Ahnnotate not to be up to date"
  end
end

module AhnnotateBeUpToDate
  def be_up_to_date
    AhnnotateUpToDateMatcher.new
  end
end

RSpec.configure do |c|
  c.include AhnnotateBeUpToDate
end
