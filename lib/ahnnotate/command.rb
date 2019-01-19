module Ahnnotate
  module Command
    def self.included(other)
      other.class_eval do
        attr_writer :vfs
      end
    end

    def initialize(root, options, config)
      @root = root
      @options = options
      @config = config
    end

    def vfs
      @vfs ||= Vfs.new(vfs_driver)
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
