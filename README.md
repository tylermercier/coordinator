# Coordinator

Ruby gem for coordinating multiple redis queues

## Status
[![Gem Version](https://badge.fury.io/rb/coordinator.png)](http://badge.fury.io/rb/coordinator)
[![Build Status](https://secure.travis-ci.org/tylermercier/coordinator.png)](http://travis-ci.org/tylermercier/coordinator)
[![Code Climate](https://codeclimate.com/github/tylermercier/coordinator.png)](https://codeclimate.com/github/tylermercier/coordinator)

## Installation

Add this line to your application's Gemfile:

    gem 'coordinator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coordinator

## Usage

    @coordinator = Coordinator::Base.new([
      Coordinator::Queue.new("high"),
      Coordinator::Queue.new("medium"),
      Coordinator::Queue.new("low")
    ])
    
    @coordinator.add_task("high", 1)
    @coordinator.add_task("medium", 2)
    @coordinator.add_priority_task("high", 3)
    
    @coordinator.next_task(["high"]) # returns 3
    @coordinator.next_task(["medium"]) # returns 2

## Contributing

1. Fork it ( http://github.com/<my-github-username>/coordinator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
