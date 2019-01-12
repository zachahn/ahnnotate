module Ahnnotate
  module Refinement
    module YieldSelf
      if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5.0")
        refine Object do
          def yield_self
            if !block_given?
              return enum_for(:yield_self)
            end

            yield self
          end
        end
      end
    end
  end
end
