require 'json'

module Coordinator
  class RedisQueue
    def initialize(name)
      @name = name
      raise "redis not find, please set 'Redis.current'" unless Redis.current
      @redis = Redis.current
    end

    def push(item)
      @redis.rpush(@name, serialize(item))
    end

    def left_push(item)
      @redis.lpush(@name, serialize(item))
    end

    def pop
      parse(@redis.lpop(@name))
    end

    def remove(item)
      @redis.lrem(@name, 1, serialize(item))
    end

    def peek
      @redis.lrange(@name, 0, 0).first
    end

    def items
      @redis.lrange(@name, 0, length)
    end

    def length
      @redis.llen(@name)
    end

    private

    def serialize(item)
      (item.is_a? String) ? item : item.to_json
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
