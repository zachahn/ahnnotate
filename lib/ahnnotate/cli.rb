require "optparse"
require "rubygems/text"

module Ahnnotate
  class Cli
    def initialize(name:)
      @name = name
      @options = Options.new(fix: false)
    end

    def run(argv, config = nil)
      argv = argv.dup

      debug_options = argv.delete("--debug-opts") || argv.delete("--debug-options")

      parser.parse(argv)

      if debug_options
        puts @options
      end

      if @options.exit?
        return
      end

      root = Pathname.new(Dir.pwd)
      config ||= Config.load(root: root)

      Function::Main.new(root, @options, config).call
    end

    private

    def parser
      if instance_variable_defined?(:@parser)
        return @parser
      end

      @parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{@name} [options]"
        opts.separator ""
        opts.separator "Command line options:"
        opts.separator ""

        opts.on("--[no-]fix", "Actually modify files") do |fix|
          @options.fix = fix
        end

        opts.on("-h", "--help", "Prints this help message") do
          @options.exit = true
          puts opts
        end

        opts.on("--version", "Print version") do
          @options.exit = true
          puts Ahnnotate::VERSION
        end

        opts.separator ""
        opts.separator ""
        opts.separator "Configuration file:"
        opts.separator ""

        # The gsub converts all non-consecutive newlines into a space.
        # Consecutive newlines are left alone.
        configuration_file_help = <<-MSG.gsub(/(?<!\n)\n(?!\n)/, " ")
The configuration file (`.ahnnotate.yml`) must be placed at the root of your
project, or wherever you will be calling this script. Any unset config option
will fall back to the following default configuration:

%{default}

In Rails projects (projects which explicitly use the `Rails` gem), ahnnotate
merges the following configs in with the defaults. This should allow ahnnotate
to work out of the box.

%{rails_additions}

(It should generally be possible to speed up the "boot" process by only loading
ActiveRecord, custom inflections, etc. Note though that the actual models do
not need to be loaded into the runtime; ahnnotate will read them as needed)
        MSG

        output = format(
          configuration_file_help,
          default: yaml_dump_and_indent(Ahnnotate::Config.default, indent: 4),
          rails_additions: yaml_dump_and_indent(Ahnnotate::Config.rails_additions, indent: 4)
        )

        opts.separator wrap_and_indent(text: output, width: 72 + 4, indent: 4)
      end

      @parser
    end

    def yaml_dump_and_indent(object, indent:)
      YAML.dump(object).gsub(/^/, " " * indent)
    end

    def wrap_and_indent(text:, width:, indent:)
      GemTextWrapper.format_text(text, width, indent)
    end
  end

  # I really had a feeling Ruby would have a "word wrap" feature somewhere.
  # Somewhere in the Rubygems code was not my first guess lol.
  module GemTextWrapper
    class << self
      include Gem::Text

      def clean_text(text)
        text
      end
    end
  end
end
