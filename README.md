# Bork

Bork attempts to run tests, saves the output separately by stream (stdout/stderr), parses the output. It allows filtering and selecting tests by path, run status (passing/erroring/failing/crashing/etc). Allows creation of testing "sessions", caches test output and results to disk. Allows tagging of tests within sessions with persistent metadata.

## Note

Bork was made for a very specific use case, to be used by a specific team. It is mostly undocumented. If you aren't using RVM, are using a test environment other than MiniTest or Test::Unit, or have named your test files anything other than `*test.rb`, bork will not work for you without modification. Use at your own risk.

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
You will be dropped into a console session.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bork.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
