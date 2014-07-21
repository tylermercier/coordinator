module Coordinator
  class Queue
    attr_reader :skill

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
      task = @store.peek
      return nil unless task && eligible?(task, skills)
      return task if @store.remove(task)
      next_task(skills)
    end

    def eligible?(task, skills)
      if @custom_block
        self.instance_exec(task, skills, &@custom_block)
      else
        skills.include?(@skill)
      end
    end

    def set_capacity(capacity)
      @store.capacity = capacity
    end

    def details
      {
        "name" => @skill,
        "full" => @store.full?,
        "capacity" => @store.capacity,
        "count" => @store.length,
        "items" => @store.items
      }
    end

    def length
      @store.length
    end

    def peek
      @store.peek
    end
  end
end
