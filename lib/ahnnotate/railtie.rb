module Ahnnotate
  class Railtie < Rails::Railtie
    rake_tasks do
      load "ahnnotate/rails.rake"
    end
  end
end
