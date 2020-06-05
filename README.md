# Cem = Christopher's Ruby Gem of Common Helpers 

This gem is an assorted collection of common helpers that I use in a lot of projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cem'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cem

## Usage

    require 'cem'
    
Key things includes:

### crequire

crequire is a replacement for require for situations where bundler would be overkill. It solves the frustration of having to manually install gems to run a particular ruby script which requires other gems. 

For example when you want to require 'qml' from the 'ruby-qml' gem, use the following line:

```crequire 'qml', 'ruby-qml'```

This will attempt to require qml and if it can't be found in the local RubyGems, then it will try to `gem install ruby-qml`

### Array::with_progress

Monkey patches array to return an enumeration which prints progress while lazy evaluating the enumeration.

require 'cem'
[a,b,c].with_progress.each { |x|
  puts x
}

Uses the [https://github.com/paul/progress_bar](progress_bar gem).

### Numeric monkey patch

Make all methods in Math module available as methods for numeric (e.g. 3.sqrt instead of Math.sqrt(3))

### Advent of Code Puzzle Helpers

Defines integer based `Point2D`, `Seg2D` (line segment), `Dir2D` (relative direction in 2D), `Point3D`, `Grid` (2D array) to help with Advent of Code puzzles, by providing commonly needed methods such as manhattan distances, string to indices conversion, enumeration of adjacent cells, etc.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/coezbek/cem.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## What's with the name?

Cem is pronounced like `Jam` in Turkish, which is close enough to `Gem` and exactely short enough to type.
