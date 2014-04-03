require 'json'

module Coordinator
  class RedisQueue
    def initialize(name)
      @queue_name = "#{name}-queue"
      @capacity_name = "#{name}-capacity"
      raise Coordinator::Error, "'Redis.current' not set" unless Redis.current
      @redis = Redis.current
    end

    def push(item)
      return false if full?
      data = serialize(item)
      @redis.rpush(@queue_name, data) unless items.include?(data)
    end

    def left_push(item)
      data = serialize(item)
      @redis.lpush(@queue_name, data) unless items.include?(data)
    end

    def pop
      data = @redis.lpop(@queue_name)
      deserialize(data)
    end

    def remove(item)
      data = serialize(item)
      @redis.lrem(@queue_name, 1, data) == 1
    end

    def peek
      data = @redis.lrange(@queue_name, 0, 0).first
      deserialize(data)
    end

    def length
      @redis.llen(@queue_name)
    end

    def capacity
      data = @redis.get(@capacity_name)
      deserialize(data)
    end

    def capacity=(capacity)
      @redis.set(@capacity_name, capacity)
    end

    def items
      @redis.lrange(@queue_name, 0, length).map { |i| deserialize(i) }
    end

    private

    def full?
      capacity && capacity <= length
    end

    def serialize(item)
      item.is_a?(String) ? item : item.to_json
    end

    def deserialize(item)
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
