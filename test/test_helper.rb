require 'minitest/autorun'
require 'minitest/reporters'
require "fakeredis"

Redis.current = Redis.new
Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new(color: true))

ENV['RACK_ENV'] = 'test'

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each do |file|
  require File.basename(file, File.extname(file))
end
