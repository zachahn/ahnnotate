module Ahnnotate
  class Vfs
    include Enumerable

    def initialize(driver)
      @driver = driver
    end

    def []=(path, content)
      if content.nil?
        return
      end

      if @driver.dir?(path)
        raise Error::VfsWriteError, "can't write to directory"
      end

      if !accessible_path?(path)
        raise Error::VfsOutsideOfRoot, "path seems to be outside of root"
      end

      @driver[path] = content
    end

    def [](path)
      if @driver.dir?(path)
        raise Error::VfsReadError, "can't read a directory"
      end

      if !accessible_path?(path)
        raise Error::VfsOutsideOfRoot, "path seems to be outside of root"
      end

      @driver[path]
    end

    def each
      if !block_given?
        return enum_for(:each)
      end

      @driver.each(&Proc.new)
    end

    def each_in(paths, extensions = [])
      if !block_given?
        return enum_for(:each_in, paths)
      end

      paths =
        if paths.is_a?(Array)
          paths
        else
          [paths]
        end

      extensions = [extensions].flatten.compact

      @driver.each_in(paths) do |path, content|
        if extensions.any?
          if !extensions.include?(File.extname(path))
            next
          end
        end

        yield(path, content)
      end
    end

    private

    def accessible_path?(path)
      random_safe_prefix = "/#{SecureRandom.hex}"
      expanded_path = File.expand_path(path, random_safe_prefix)

      /\A#{random_safe_prefix}\b/ === expanded_path
    end
  end
end
