module Ahnnotate
  module VfsDriver
    class Hash
      def initialize(files, subdirectories = nil)
        @files = files
        @subdirectories = nil
      end

      def each
        @files.each do |path, content|
          yield path, content
        end
      end

      def each_in(subset_paths)
        subset_patterns = subset_paths.map { |path| /\A#{path}\b/ }

        @files.each do |path, content|
          if subset_patterns.none? { |pattern| pattern === path }
            next
          end

          yield path, content
        end
      end

      def [](path)
        @files[path]
      end

      def []=(path, content)
        if content.nil?
          return
        end

        @files[path] = content
      end

      def subset(in: nil)
        subdirectories = binding.local_variable_get(:in)

        self.class.new(the_subset, subdirectories)
      end

      def dir?(path)
        path_with_trailing_slash =
          if path[-1] == "/"
            path
          else
            path + "/"
          end

        @files.any? do |filepath, _|
          filepath.start_with?(path_with_trailing_slash)
        end
      end
    end
  end
end
