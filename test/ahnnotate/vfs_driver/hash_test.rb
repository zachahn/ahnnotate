require "test_helper"
require "is_a_virtual_file_system"

class VfsDriverHashTest < TestCase
  include IsAVirtualFileSystem

  def new_instance
    Ahnnotate::VfsDriver::Hash.new(starting_files_and_contents.dup)
  end
end
