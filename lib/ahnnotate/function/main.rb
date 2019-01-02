module Ahnnotate
  module Function
    class Main
      def self.config_in(app_root)
        config_path = app_root.join(".ahnnotate.yml")

        if !config_path.exist?
          return {}
        end

        config = YAML.safe_load(File.read(config_path))

        if config.is_a?(Hash)
          config
        else
          {}
        end
      end

      def initialize(root, options, config)
        @root = root
        @options = options
        @config = config
      end

      def call
        if @config.key?("boot")
          eval @config["boot"]
        end

        vfs = Vfs.new(vfs_driver)

        runner = Run.new(@config, vfs)
        runner.call
      end

      private

      def vfs_driver
        if @options.fix?
          VfsDriver::Filesystem.new(root: @root)
        else
          VfsDriver::ReadOnlyFilesystem.new(root: @root)
        end
      end
    end
  end
end
