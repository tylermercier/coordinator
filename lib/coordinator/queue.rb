module Coordinator
  class Queue < RedisQueue
    attr_reader :skill

    def initialize(skill, capacity=nil, &block)
      @skill = skill
      @custom_block = block if block_given?

      super(skill)

      self.capacity = capacity if capacity
    end

    def next_task(skills)
      task = peek
      return nil unless task && eligible?(task, skills)
      return task if remove(task)
      next_task(skills)
    end

    def eligible?(task, skills)
      if @custom_block
        self.instance_exec(task, skills, &@custom_block)
      else
        skills.include?(@skill)
      end
    end

    def details
      {
        "name" => @skill,
        "full" => full?,
        "capacity" => capacity,
        "count" => length,
        "items" => items
      }
    end
  end
end
