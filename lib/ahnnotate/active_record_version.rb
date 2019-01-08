module Ahnnotate
  class ActiveRecordVersion
    class << self
      def actual
        @actual ||= Gem::Version.new(ActiveRecord::VERSION::STRING)
      end

      def five_and_up?
        actual >= five
      end

      private

      def five
        @five ||= Gem::Version.new("5")
      end
    end
  end
end
