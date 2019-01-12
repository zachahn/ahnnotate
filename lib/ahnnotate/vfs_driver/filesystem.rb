using Ahnnotate::Refinement::PathnameGlob

module Ahnnotate
  module VfsDriver
    class Filesystem
      def initialize(root:)
        @root = root
      end

      def each
        paths =
          root
            .glob("**/*")
            .select(&:file?)
            .map { |path| path.relative_path_from(root).to_s }

        root.glob("**/*").select(&:file?).each do |abspath|
          relpath = abspath.relative_path_from(root).to_s

          yield relpath, File.read(abspath)
        end
      end

      def each_in(subset_paths)
        subset_paths = subset_paths.map { |path| root.join(path) }

        subset_paths.each do |subset_path|
          subset_path.glob("**/*").select(&:file?).map do |abspath|
            relpath = abspath.relative_path_from(root).to_s

            yield relpath, File.read(abspath)
          end
        end
      end

      def [](path)
        path = root.join(path)

        if path.exist?
          File.read(path)
        end
      end

      def []=(path, content)
        path = root.join(path)
        holding_directory = path.dirname

        if holding_directory.file?
          raise "File is not a directory"
        end

        if !holding_directory.exist?
          holding_directory.mkpath
        end

        File.write(path, content)
      end

      def dir?(path)
        root.join(path).directory?
      end

      private

      def root
        Pathname.new(@root)
      end
    end
  end
end
