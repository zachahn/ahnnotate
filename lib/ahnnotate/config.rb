using Ahnnotate::Refinement::Dig

module Ahnnotate
  class Config
    def self.load(root:)
      config_path = root.join(".ahnnotate.yml")

      if !config_path.exist?
        return new({})
      end

      loaded_config = YAML.safe_load(File.read(config_path))
      new(loaded_config)
    end

    def self.default
      @default ||= {
        "boot" => nil,
        "rake_db_autorun" => false,
        "annotate" => {
          "models" => {
            "enabled" => true,
            "path" => "app/models",
          },
        },
      }
    end

    def self.rails_additions
      @rails_additions ||= {
        "boot" => %(require File.expand_path("config/environment").to_s),
        "rake_db_autorun" => true,
      }
    end

    def self.effective_default
      if @effective_default
        return @effective_default
      end

      @effective_default ||= YAML.load(YAML.dump(default)) # deep dup

      if Gem.loaded_specs.key?("rails")
        @effective_default.merge!(rails_additions)
      end

      @effective_default
    end

    def initialize(config)
      @config =
        if config.is_a?(Hash)
          config
        else
          {}
        end
    end

    def [](*args)
      specified_config = @config.dig(*args)

      if specified_config.nil?
        self.class.effective_default.dig(*args)
      else
        specified_config
      end
    end
  end
end
