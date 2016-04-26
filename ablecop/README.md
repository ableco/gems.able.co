# ablecop

ablecop is a collection of best practices for writing code at Able. These
practices are reinforced on the project level through comments on commits
and pull requests that find violations.

## Installation

Add this line to your application's Gemfile to both the `:development` and `:test` groups:

```ruby
group :development, :test do
  gem "ablecop"
end
```

And then execute:

    $ bundle

## CircleCI Usage

To enable CircleCI to run ablecop's checks and comment on commits with each
push, add the following line to your project's `circle.yml`:

```yml
test:
  post:
    - "RAILS_ENV=development bundle exec rake ablecop:run_on_circleci"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ableco/able-cop.
