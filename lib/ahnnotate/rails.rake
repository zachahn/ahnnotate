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
  desc "Add annotations"
  task :add do
    require "ahnnotate/cli"

    argv = ENV.fetch("AHNNOTATE_ADD", "--fix")

    puts "Adding annotations..."

    cli = Ahnnotate::Cli.new(name: "ahnnotate")
    cli.run(argv, $rake_ahnnotate_config)

    puts "Done!"
  end

  desc "Remove annotations"
  task :remove do
    require "ahnnotate/cli"

    argv = ENV.fetch("AHNNOTATE_REMOVE", "--fix --remove")

    puts "Removing annotations..."

    cli = Ahnnotate::Cli.new(name: "ahnnotate")
    cli.run(argv, $rake_ahnnotate_config)

    puts "Done!"
  end
end

desc "Run rake task `ahnnotate:add`"
task ahnnotate: "ahnnotate:add"
