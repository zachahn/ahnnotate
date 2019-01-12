module Ahnnotate
  module Refinement
    module PathnameGlob
      if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5.0")
        refine Pathname do
          def glob(pattern)
            Dir.glob(self.join(pattern)).map { |path| Pathname.new(path) }
          end
        end
      end
    end
  end
end
