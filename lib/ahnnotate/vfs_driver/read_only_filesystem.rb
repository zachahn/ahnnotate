module Ahnnotate
  module VfsDriver
    class ReadOnlyFilesystem < Filesystem
      def []=(_path, _content)
      end
    end
  end
end
