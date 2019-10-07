module Ahnnotate
  module VfsDriver
    class ReadOnlyFilesystem < Filesystem
      attr_reader :changes

      def initialize(root:)
        super
        @changes = {}
      end

      def []=(path, content)
        @changes[path] = content
        nil
      end
    end
  end
end
