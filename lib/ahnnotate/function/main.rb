module Ahnnotate
  module Function
    class Main
      def initialize(root, options, config)
        @root = root
        @options = options
        @config = config
      end

      def call
        if @config["boot"]
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
