# Ahnnotate

[Ahnnotate][rubygem] comments on your ActiveRecord models with their respective
schemas!

Ahnnotate performs static analysis on your files to determine which files
should be annotated. The primary goals of ahnnotate are ease of configuration
and correctness.

It's very similar to [annotate][annotate] and was inspired heavily by it.
Annotate has more features than ahnnotate does; it may fit your needs a bit
better.


## Installation

Add this line to your application's Gemfile:

```ruby
gem "ahnnotate"
```

And then execute:

```
bundle
```


## Usage

Please use source control management software like git, mercurial, etc! The
purpose of this software is to overwrite your source files. Although I'm pretty
comfortable running this, I've definitely made a couple bugs in my lifetime!


### In a Rails app

To run it manually, run:

```bash
bundle exec ahnnotate --fix
# OR
bundle exec rake ahnnotate
```

(Leaving out the `--fix` argument runs the command but doesn't make any changes
to your filesystem. However, the rake task assumes that you do want to fix by
default.)

Ahnnotate automatically runs after running migrations. This can be disabled,
though by creating a `.ahnnotate.yml` configuration file and setting
`rake_db_autorun: false`.

See `bundle exec ahnnotate --help` for some more help.


### In apps using ActiveRecord but not Rails

You'll need some initial configuration to get things working. But I'm sure
you're used to that since you aren't using Rails! 😝

You'll need a `.ahnnotate.yml` file at the root of your project with one key,
`boot:`. Ahnnotate will `eval` the contents, and it really just needs it to
connect to your database. It might look something like the following, I tested
it with one of my Rails apps:

```yaml
---
boot: |
  require "dotenv/load" # If you use something like dotenv to load ENV variables
  require "yaml"
  require "erb"
  require "active_record"

  config_file = File.read("config/database.yml")
  config_file = ERB.new(config_file).result(binding)
  config = YAML.load(config_file)

  environment = ENV.fetch("RAILS_ENV", "development")
  database_config = config[environment]

  ActiveRecord::Base.establish_connection(database_config)
```

You may also need to configure the location of your models.

```yaml
annotate:
  models:
    path: path/to/your/models # also accepts an array of paths
```

It doesn't officially support automatically running after migrations on
non-Rails apps.

See `bundle exec ahnnotate --help` for some more help.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on its [project page][github].


## License

The gem is available as open source under the terms of the [MIT License][mit].


[annotate]: https://github.com/ctran/annotate_models
[github]: https://github.com/zachahn/ahnnotate
[mit]: https://opensource.org/licenses/MIT
[rubygem]: https://rubygems.org/gems/ahnnotate
