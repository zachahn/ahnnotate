module Ahnnotate
  class Error < StandardError
    class VfsError < Error; end
    class VfsReadError < VfsError; end
    class VfsWriteError < VfsError; end
    class VfsOutsideOfRoot < VfsError; end
  end
end
