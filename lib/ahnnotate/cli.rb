require "optparse"

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
      config ||= Function::Main.config_in(root)

      Function::Main.new(root, @options, config).call
    end

    private

    def parser
      if instance_variable_defined?(:@parser)
        return @parser
      end

      @parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{@name} [options]"
        opts.separator "Note: Most options can only be set via the config file"
        opts.separator ""

        opts.on("--[no-]fix", "Actually modify files") do |fix|
          @options.fix = fix
        end

        opts.on_tail("-h", "--help", "Prints this help message") do
          @options.exit = true
          puts opts
        end

        opts.on_tail("--version", "Print version") do
          @options.exit = true
          puts Ahnnotate::VERSION
        end
      end

      @parser
    end
  end
end
