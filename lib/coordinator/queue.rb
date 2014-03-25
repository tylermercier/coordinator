module Coordinator
  class Queue
    attr_reader :skill, :rules

    def initialize(skill, capacity=nil, &block)
      @skill = skill
      @store = Coordinator::RedisQueue.new(@skill)
      @store.capacity = capacity if capacity
      @custom_block = block if block_given?
    end

    def add_task(task)
      @store.push(task)
    end

    def add_priority_task(task)
      @store.left_push(task)
    end

    def remove_task(task)
      @store.remove(task)
    end

    def next_task(skills)
      eligible?(@store.peek, skills) ? @store.pop : nil
    end

    def eligible?(task, skills)
      return true if skills.include?(@skill)
      @custom_block ? @custom_block.call(task, skills) : false
    end

    def set_capacity(capacity)
      @store.capacity = capacity
    end
  end
end
