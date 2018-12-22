module IsAVirtualFileSystem
  # Expects following method(s) to be defined:
  #
  # -  #new_instance
  #
  # The instance must be initialized with whatever is necessary to replicate
  # the `starting_files_and_contents`.
  #

  def test_each_in_yields_only_selected_subset
    expected_paths = {
      "app/models/post.rb" => false,
      "app/models/application_record.rb" => false,
    }

    instance.each_in(["app/models"]) do |path, _content|
      assert_equal(false, expected_paths[path])
      expected_paths[path] = true
    end

    assert_equal(true, expected_paths.values.all?)
  end

  def test_each_in_with_no_paths_is_an_empty_subset
    assert_equal(false, instance.each_in([]).any?)
  end

  def test_each_in_with_nonexistant_path_is_an_empty_subset
    assert_equal(false, instance.each_in("config/").any?)
  end

  def test_each_iterates_through_all_available_files
    assert_kind_of(Enumerator, instance.each)

    iterated_paths = []
    instance.each do |path, content|
      iterated_paths.push(path)
      assert_equal(starting_files_and_contents[path], content)
    end

    assert_equal(starting_files_and_contents.keys.sort, iterated_paths.sort)
  end

  def test_reading_existing_files
    assert_equal(
      starting_files_and_contents["app/models/post.rb"],
      instance["app/models/post.rb"]
    )
  end

  def test_reading_absolute_paths
    assert_raises(Ahnnotate::Error::VfsOutsideOfRoot) { instance["/app/models/post.rb"] }
  end

  def test_reading_nonexisting_files
    assert_nil(instance["this/file/doesnt/exist"])
  end

  def test_reading_files_outside_of_root
    assert_raises(Ahnnotate::Error::VfsOutsideOfRoot) { instance["/etc/ssh/sshd_config"] }
    assert_raises(Ahnnotate::Error::VfsOutsideOfRoot) { instance["~/.DS_Store"] }
    assert_raises(Ahnnotate::Error::VfsOutsideOfRoot) { instance["~/.bash_profile"] }
    assert_raises(Ahnnotate::Error::VfsOutsideOfRoot) { instance["~/.bashrc"] }
    assert_raises(Ahnnotate::Error::VfsOutsideOfRoot) { instance["~/.zshrc"] }
  end

  def test_reading_directory_raises_error
    assert_raises(Ahnnotate::Error::VfsReadError) { instance["app"] }
    assert_raises(Ahnnotate::Error::VfsReadError) { instance["app/"] }
  end

  def test_overwriting_file
    # This file already exists
    instance["app/models/post.rb"] = "Post = Struct.new\n"

    assert_equal("Post = Struct.new\n", instance["app/models/post.rb"])
  end

  def test_writing_new_file
    instance["app/models/author.rb"] = "Author = Struct.new\n"

    assert_equal("Author = Struct.new\n", instance["app/models/author.rb"])
  end

  def test_writing_new_file_does_mkdir_p
    instance["lib/tasks/lol.rake"] = %(task backfill: :environment do\nend\n)

    assert_equal(
      %(task backfill: :environment do\nend\n),
      instance["lib/tasks/lol.rake"]
    )
  end

  def test_writing_onto_a_directory_noops
    assert_raises(Ahnnotate::Error::VfsWriteError) do
      instance["app"] = "Oh. Hi.\n"
    end
  end

  def test_setting_file_to_nil_does_nothing
    instance["app/controllers/application_controller.rb"] = nil

    assert_equal(
      starting_files_and_contents["app/controllers/application_controller.rb"],
      instance["app/controllers/application_controller.rb"]
    )
  end

  def starting_files_and_contents
    {
      "app/controllers/application_controller.rb" => "class ApplicationController < ActionController::Base; end\n",
      "app/models/post.rb" => "class Post < ApplicationRecord; end\n",
      "app/models/application_record.rb" => "class ApplicationRecord < ActiveRecord::Base; end\n",
      "lib/utils.rb" => "module Utils; end\n"
    }
  end

  def instance
    @instance ||= Ahnnotate::Vfs.new(new_instance)
  end
end
