# Bork

Bork attempts to run tests, saves the output separately by stream (stdout/stderr), parses the output. It allows filtering and selecting tests by path, run status (passing/erroring/failing/crashing/etc). Allows creation of testing "sessions", caches test output and results to disk. Allows tagging of tests within sessions with persistent metadata.

## Installation

Bork requires a recent version of [RVM](https://rvm.io/).

```
curl https://raw.githubusercontent.com/josh-lauer/bork/master/install | bash -s
```

That's it. It might take a few minutes if it needs to install a ruby.

Bork creates a directory at `~/.bork` to install the gem, save test output, metadata, and preferences. and installs an executable to `/usr/local/bin/bork`. To completely remove Bork:

```
rm -rf ~/.bork && rm /usr/local/bin/bork
```


## Usage

Go to a folder with some files that end in "test.rb" somewhere in it (at any search depth), and
```
bork
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bork.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
