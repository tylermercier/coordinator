require 'json'

module Coordinator
  class RedisQueue
    def initialize(name)
      @name = name
      raise Coordinator::Error.new("'Redis.current' not set") unless Redis.current
      @redis = Redis.current
    end

    def push(item)
      data = serialize(item)
      @redis.rpush(@name, data) unless items.include?(data)
    end

    def left_push(item)
      data = serialize(item)
      @redis.lpush(@name, data) unless items.include?(data)
    end

    def pop
      data = @redis.lpop(@name)
      parse(data)
    end

    def remove(item)
      data = serialize(item)
      @redis.lrem(@name, 1, data)
    end

    def peek
      data = @redis.lrange(@name, 0, 0).first
      parse(data)
    end

    def length
      @redis.llen(@name)
    end

    private

    def items
      @redis.lrange(@name, 0, length)
    end

    def serialize(item)
      item.is_a?(String) ? item : item.to_json
    end

    def parse(item)
      return item if item.nil?
      return item.to_i if item.to_i.to_s == item
      begin
        JSON::parse(item)
      rescue JSON::ParserError
        item # regular string
      end
    end
  end
end
