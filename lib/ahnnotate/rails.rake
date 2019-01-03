namespace :db do
  task :migrate do
    $rake_ahnnotate_config ||= Ahnnotate::Config.load(root: Rails.root)

    if $rake_ahnnotate_config["rake_db_autorun"]
      Rake::Task["ahnnotate:all"].reenable
      Rake::Task["ahnnotate:all"].invoke
    end
  end

  task :rollback do
    $rake_ahnnotate_config ||= Ahnnotate::Config.load(root: Rails.root)

    if $rake_ahnnotate_config["rake_db_autorun"]
      Rake::Task["ahnnotate:all"].reenable
      Rake::Task["ahnnotate:all"].invoke
    end
  end
end

namespace :ahnnotate do
  desc "Run ahnnotate"
  task :all do
    require "ahnnotate/cli"
    require "shellwords"

    # This should either be `rails` or `rake` (since newer versions of Rails
    # can call rake tasks with either executable)
    exe_name = File.basename($0)

    argv = ENV.fetch("AHNNOTATE", "--fix")
    argv = Shellwords.split(argv)

    puts "Annotating models..."

    cli = Ahnnotate::Cli.new(name: "#{exe_name} ahnnotate")
    cli.run(argv, $rake_ahnnotate_config)

    puts "Done!"
  end
end

desc "Run rake task `ahnnotate:all`"
task ahnnotate: "ahnnotate:all"
