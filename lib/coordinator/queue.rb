module Coordinator
  class Queue
    attr_reader :skill

    def initialize(skill)
      @skill = skill
      @store = Coordinator::RedisQueue.new(@skill)
    end

    def add_task(task)
      @store.push(task)
    end

    def add_priority_task(task)
      @store.left_push(task)
    end

    def next_task(skills)
      can_work?(skills) ? @store.pop : nil
    end

    def can_work?(skills)
      skills.include? @skill
    end
  end
end
