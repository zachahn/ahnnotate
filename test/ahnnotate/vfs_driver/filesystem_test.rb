require "test_helper"
require "is_a_virtual_file_system"

class VfsDriverFilesystemTest < TestCase
  include IsAVirtualFileSystem

  def setup
    @tmp_roots = Queue.new
  end

  def teardown
    until @tmp_roots.empty?
      root = @tmp_roots.pop
      FileUtils.remove_entry(root)
    end
  end

  def new_instance
    tmpdir_path = Dir.mktmpdir
    @tmp_roots.push(tmpdir_path)

    starting_files_and_contents.each do |path, content|
      absolute_path = File.join(tmpdir_path, path)
      dirname = File.dirname(absolute_path)
      FileUtils.mkdir_p(dirname)
      File.write(absolute_path, content)
    end

    Ahnnotate::VfsDriver::Filesystem.new(root: tmpdir_path)
  end
end
